import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/summer_course_state.dart';
import '../models/member.dart';
import '../models/guest.dart';
import '../models/registration_participant.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/terms_provider.dart';
import '../services/summer_course_service.dart';

class SummerCourseNotifier extends StateNotifier<SummerCourseState> {
  final SummerCourseService _service;
  final TermsService _termsService;

  SummerCourseNotifier(this._service, this._termsService, Member? loggedInUser) : super(const SummerCourseState()) {
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
        state = state.copyWith(isLoading: false, currentStep: state.currentStep + 1);
      } else {
        state = state.copyWith(currentStep: state.currentStep + 1);
      }
    }
  }

  Future<void> previousStep() async {
    if (state.currentStep > 0) {
      if (state.currentStep == 3) {
        state = state.copyWith(isLoading: true);
        await refreshCosts();
        state = state.copyWith(isLoading: false, currentStep: state.currentStep - 1);
      } else {
        state = state.copyWith(currentStep: state.currentStep - 1);
      }
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
      
      final activeCourse = await _service.getActiveCourse();
      List<Map<String, dynamic>> costs = [];
      List<Map<String, dynamic>> weeks = [];
      if (activeCourse != null && activeCourse['has_active_course'] == true) {
         final courseData = activeCourse['course'];
         if (courseData is Map) {
           final rawCosts = courseData['sc_costs'];
           if (rawCosts is List) {
             costs = rawCosts.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
           }
           final rawWeeks = courseData['sc_weeks'];
           if (rawWeeks is List) {
             weeks = rawWeeks.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
             weeks.sort((a, b) => (a['week_number'] as int? ?? 0).compareTo(b['week_number'] as int? ?? 0));
           }
         }
      }

      final intensiveActivities = await _service.getIntensiveActivities();
      final termsStatus = await _termsService.checkTerms('cursos_verano');

      state = state.copyWith(
        beneficiariesList: beneficiaries,
        activeRegistration: activeReg,
        courseCosts: costs,
        courseWeeks: weeks,
        intensiveActivities: intensiveActivities,
        termsRequired: termsStatus.required,
        termsAccepted: termsStatus.accepted || !termsStatus.required,
        termsContent: termsStatus.terminos?.contenido,
        termsVersion: termsStatus.terminos?.version.toString(),
        termsId: termsStatus.terminos?.id,
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
      final activeCourse = await _service.getActiveCourse();
      List<Map<String, dynamic>> costs = [];
      List<Map<String, dynamic>> weeks = [];
      if (activeCourse != null && activeCourse['has_active_course'] == true) {
         final courseData = activeCourse['course'];
         if (courseData is Map) {
           final rawCosts = courseData['sc_costs'];
           if (rawCosts is List) {
             costs = rawCosts.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
           }
           final rawWeeks = courseData['sc_weeks'];
           if (rawWeeks is List) {
             weeks = rawWeeks.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
             weeks.sort((a, b) => (a['week_number'] as int? ?? 0).compareTo(b['week_number'] as int? ?? 0));
           }
         }
      }
      
      final intensiveActivities = await _service.getIntensiveActivities();
      state = state.copyWith(courseCosts: costs, courseWeeks: weeks, intensiveActivities: intensiveActivities);
      
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
      String typeKey = '';
      if (type == ParticipantType.socio) typeKey = 'member';
      else if (type == ParticipantType.invitado) typeKey = 'guest';
      else if (type == ParticipantType.colaborador) typeKey = 'staff';
      else if (type == ParticipantType.invColaborador) typeKey = 'staff_guest';

      String typeKeyEs = '';
      if (type == ParticipantType.socio) typeKeyEs = 'socio';
      else if (type == ParticipantType.invitado) typeKeyEs = 'invitado';
      else if (type == ParticipantType.colaborador) typeKeyEs = 'colaborador';
      else if (type == ParticipantType.invColaborador) typeKeyEs = 'inv_colaborador';

      final costEntry = state.courseCosts.firstWhere(
        (c) => c['participant_type'] == typeKey || c['participant_type'] == typeKeyEs, 
        orElse: () => <String, dynamic>{}
      );
      
      if (costEntry.isNotEmpty) {
         double costPerWeek = double.tryParse(costEntry['cost_per_week'].toString()) ?? 0.0;
         baseCost = costPerWeek * weeksCount;
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
            'birth_date': p.guest!.birthDate,
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

  Future<bool> acceptTerms() async {
    if (state.termsId == null || state.termsVersion == null) return false;
    bool ok = await _termsService.acceptTerms('cursos_verano', int.parse(state.termsVersion!), state.termsId!);
    if (ok) {
      state = state.copyWith(termsAccepted: true);
    }
    return ok;
  }
}

final summerCourseProvider = StateNotifierProvider.autoDispose<SummerCourseNotifier, SummerCourseState>((ref) {
  final user = ref.watch(authProvider);
  final service = ref.watch(summerCourseServiceProvider);
  final termsService = ref.watch(termsProvider);
  return SummerCourseNotifier(service, termsService, user);
});
