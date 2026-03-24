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

  void nextStep() {
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  Future<void> selectTitular(Member titular) async {
    state = state.copyWith(
      selectedTitular: titular,
      selectedParticipants: [], 
      isLoading: true,
      errorMessage: null,
    );
    
    try {
      final beneficiaries = await _service.getBeneficiaries(titular.id);
      state = state.copyWith(
        beneficiariesList: beneficiaries,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al obtener familiares: $e',
        // Fallback or empty if error
        beneficiariesList: [],
      );
    }
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

  void updateWeeks(String identifier, List<int> weeks) {
    state = state.copyWith(
      selectedParticipants: state.selectedParticipants.map((p) {
        if (p.identifier == identifier) {
          return p.copyWith(selectedWeekIds: weeks);
        }
        return p;
      }).toList(),
    );
  }

  Future<void> submitRegistration() async {
    if (state.selectedTitular == null) return;

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // Preparar data para el backend
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
          'type': p.type.name, // e.g., 'socio', 'invitado'
          'weeks': p.selectedWeekIds,
        }).toList(),
        'total_amount': state.totalGeneral,
      };

      final resultPayload = await _service.register(registrationData);
      
      state = state.copyWith(
        isLoading: false, 
        salesOrderId: resultPayload['sales_order_id']?.toString() ?? 'N/A',
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
