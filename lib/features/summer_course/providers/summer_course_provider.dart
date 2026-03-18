import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/summer_course_state.dart';
import '../models/member.dart';
import '../models/guest.dart';
import '../models/registration_participant.dart';

class SummerCourseNotifier extends StateNotifier<SummerCourseState> {
  SummerCourseNotifier() : super(const SummerCourseState());

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void nextStep() {
    if (state.currentStep < 4) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void selectTitular(Member titular) {
    state = state.copyWith(
      selectedTitular: titular,
      // Clear previous family selections when changing titular
      selectedParticipants: [], 
    );
    // TODO: In a real implementation, this would trigger fetching beneficiaries
    // For now we'll have a method to mock this or provide it.
    _mockBeneficiariesFor(titular);
  }

  void _mockBeneficiariesFor(Member titular) {
    // Logic: members with same base excluding '00'
    final base = titular.membershipNumber.substring(0, titular.membershipNumber.length - 2);
    final mockBeneficiaries = [
      Member(
        id: '${titular.id}01',
        membershipNumber: '${base}01',
        firstName: 'Martha Silvia',
        lastName: 'Martínez',
        secondLastName: 'Vázquez',
        memberType: '2',
        isTitular: false,
      ),
      Member(
        id: '${titular.id}02',
        membershipNumber: '${base}02',
        firstName: 'Juan Pablo',
        lastName: 'Ferez',
        secondLastName: 'Martínez',
        memberType: '2',
        isTitular: false,
      ),
    ];
    state = state.copyWith(beneficiariesList: mockBeneficiaries);
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
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // TODO: Call API to generate NetSuite Order
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      state = state.copyWith(
        isLoading: false, 
        salesOrderId: 'SO-2026-00123',
        // Permanecemos en el paso actual (4) para mostrar el éxito
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final summerCourseProvider = StateNotifierProvider<SummerCourseNotifier, SummerCourseState>((ref) {
  return SummerCourseNotifier();
});
