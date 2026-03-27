import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/summer_course_state.dart';
import '../models/member.dart';
import '../models/guest.dart';
import '../models/registration_participant.dart';
import '../../../core/providers/auth_provider.dart';
import '../services/summer_course_service.dart';

class SummerCourseNotifier extends StateNotifier<SummerCourseState> {
  final SummerCourseService _service;

  SummerCourseNotifier(this._service, Member? loggedInUser) : super(const SummerCourseState()) {
    if (loggedInUser != null) {
      selectTitular(loggedInUser);
    }
  }
  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  Future<void> nextStep() async {
    if (state.currentStep < 3) {
      if (state.currentStep == 1) {
        state = state.copyWith(isLoading: true);
        await refreshCosts();
        state = state.copyWith(isLoading: false);
      }
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  Future<void> previousStep() async {
    if (state.currentStep > 0) {
      if (state.currentStep == 3) {
        state = state.copyWith(isLoading: true);
        await refreshCosts();
        state = state.copyWith(isLoading: false);
      }
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  Future<void> selectTitular(Member titular) async {
    state = state.copyWith(
      selectedTitular: titular,
      selectedParticipants: [], 
      isLoading: true,
      errorMessage: null,
      activeRegistration: null,
      courseCosts: [],
    );
    
    try {
      final beneficiaries = await _service.getBeneficiaries(titular.id);
      final activeReg = await _service.getActiveRegistration(titular.id);
      final costs = await _service.getCosts();
      final intensiveActivities = await _service.getIntensiveActivities();

      state = state.copyWith(
        beneficiariesList: beneficiaries,
        activeRegistration: activeReg,
        courseCosts: costs,
        intensiveActivities: intensiveActivities,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al obtener datos: $e',
        beneficiariesList: [],
      );
    }
  }

  void reset() {
    final titular = state.selectedTitular;
    state = const SummerCourseState();
    if (titular != null) {
      selectTitular(titular);
    }
  }

  Future<void> refreshCosts() async {
    try {
      final costs = await _service.getCosts();
      final intensiveActivities = await _service.getIntensiveActivities();
      state = state.copyWith(courseCosts: costs, intensiveActivities: intensiveActivities);
      
      final updatedParticipants = state.selectedParticipants.map((p) {
        final newCost = _calculateCost(p.type, p.selectedWeekIds.length, p.intensiveActivityId);
        return p.copyWith(calculatedCost: newCost);
      }).toList();
      
      state = state.copyWith(selectedParticipants: updatedParticipants);
    } catch (_) {}
  }

  void toggleBeneficiary(Member beneficiary) {
    final isSelected = state.selectedParticipants.any((p) => p.member?.id == beneficiary.id);
    
    if (isSelected) {
      state = state.copyWith(
        selectedParticipants: state.selectedParticipants.where((p) => p.member?.id != beneficiary.id).toList(),
      );
    } else {
      final isColaborador = state.selectedTitular?.memberType.toLowerCase().contains('colaborador') ?? false;
      final newParticipant = RegistrationParticipant(
        member: beneficiary,
        type: isColaborador ? ParticipantType.colaborador : ParticipantType.socio,
      );
      state = state.copyWith(
        selectedParticipants: [...state.selectedParticipants, newParticipant],
      );
    }
  }

  void addGuest(Guest guest) {
    final isColaborador = state.selectedTitular?.memberType.toLowerCase().contains('colaborador') ?? false;
    final newParticipant = RegistrationParticipant(
      guest: guest,
      type: isColaborador ? ParticipantType.invColaborador : ParticipantType.invitado,
    );
    state = state.copyWith(
      selectedParticipants: [...state.selectedParticipants, newParticipant],
    );
  }

  void removeParticipant(String identifier) {
    state = state.copyWith(
      selectedParticipants: state.selectedParticipants.where((p) => p.identifier != identifier).toList(),
    );
  }

  double _calculateCost(ParticipantType type, int weeksCount, [int? intensiveActivityId]) {
    double baseCost = 0.0;
    
    if (weeksCount > 0 && state.courseCosts.isNotEmpty) {
      final costEntry = state.courseCosts.firstWhere(
        (c) => c['weeks_count'] == weeksCount, 
        orElse: () => <String, dynamic>{}
      );
      
      if (costEntry.isNotEmpty) {
        switch (type) {
          case ParticipantType.socio:
            baseCost = double.tryParse(costEntry['socio'].toString()) ?? 0.0;
            break;
          case ParticipantType.invitado:
            baseCost = double.tryParse(costEntry['invitado'].toString()) ?? 0.0;
            break;
          case ParticipantType.colaborador:
            baseCost = double.tryParse(costEntry['colaborador'].toString()) ?? 0.0;
            break;
          case ParticipantType.invColaborador:
            baseCost = double.tryParse(costEntry['inv_colaborador'].toString()) ?? 0.0;
            break;
        }
      }
    }

    double extraCost = 0.0;
    if (intensiveActivityId != null && state.intensiveActivities.isNotEmpty) {
      final activity = state.intensiveActivities.firstWhere(
        (a) => a['id'] == intensiveActivityId,
        orElse: () => <String, dynamic>{}
      );
      if (activity.isNotEmpty) {
        extraCost = double.tryParse(activity['extra_cost'].toString()) ?? 0.0;
      }
    }

    return baseCost + extraCost;
  }

  void updateWeeks(String identifier, List<int> weeks) {
    state = state.copyWith(
      selectedParticipants: state.selectedParticipants.map((p) {
        if (p.identifier == identifier) {
          final newCost = _calculateCost(p.type, weeks.length, p.intensiveActivityId);
          return p.copyWith(selectedWeekIds: weeks, calculatedCost: newCost);
        }
        return p;
      }).toList(),
    );
  }

  void updateIntensiveActivity(String identifier, int? activityId) {
    state = state.copyWith(
      selectedParticipants: state.selectedParticipants.map((p) {
        if (p.identifier == identifier) {
          final newCost = _calculateCost(p.type, p.selectedWeekIds.length, activityId);
          return p.copyWith(intensiveActivityId: activityId, calculatedCost: newCost);
        }
        return p;
      }).toList(),
    );
  }

  Future<void> submitRegistration() async {
    if (state.selectedTitular == null) return;

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final registrationData = {
        'titular_id': state.selectedTitular?.id,
        'membership_number': state.selectedTitular?.membershipNumber,
        'participants': state.selectedParticipants.map((p) => {
          'id': p.member?.id ?? p.guest?.email,
          'fullName': p.fullName,
          'member_id': p.member?.id,
          'guest': p.guest != null ? {
            'first_name': p.guest!.firstName,
            'last_name': p.guest!.lastName,
            'email': p.guest!.email,
            'phone': p.guest!.phone,
          } : null,
          'type': p.type.name,
          'weeks': p.selectedWeekIds,
          'intensive_activity_id': p.intensiveActivityId,
          'total_cost': p.totalCost,
        }).toList(),
        'total_amount': state.totalGeneral,
      };

      final resultPayload = await _service.register(registrationData);
      
      state = state.copyWith(
        isLoading: false, 
        salesOrderId: resultPayload['sales_order_id']?.toString() ?? 'N/A',
        masterToken: resultPayload['master_token']?.toString(),
        pickUpTokens: resultPayload['pick_up_tokens'] as List<dynamic>?,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final summerCourseProvider = StateNotifierProvider.autoDispose<SummerCourseNotifier, SummerCourseState>((ref) {
  final user = ref.watch(authProvider);
  final service = ref.watch(summerCourseServiceProvider);
  return SummerCourseNotifier(service, user);
});
