import 'package:freezed_annotation/freezed_annotation.dart';
import 'member.dart';
import 'registration_participant.dart';

part 'summer_course_state.freezed.dart';
part 'summer_course_state.g.dart';

@freezed
class SummerCourseState with _$SummerCourseState {
  const factory SummerCourseState({
    @Default(0) int currentStep,
    Member? selectedTitular,
    @Default([]) List<Member> beneficiariesList, // Options for current titular
    @Default([]) List<RegistrationParticipant> selectedParticipants, // From beneficiaries + guests
    @Default(false) bool isLoading,
    String? errorMessage,
    String? salesOrderId, // ID generated at the end
    String? masterToken, // Master Netkey for the whole registration
    List<dynamic>? pickUpTokens, // Tokens_acceso para recoger a los niños
    Map<String, dynamic>? activeRegistration,
    @Default([]) List<Map<String, dynamic>> courseCosts,
    @Default([]) List<Map<String, dynamic>> intensiveActivities,
  }) = _SummerCourseState;

  factory SummerCourseState.fromJson(Map<String, dynamic> json) => 
      _$SummerCourseStateFromJson(json);

  const SummerCourseState._();

  double get totalGeneral {
    return selectedParticipants.fold(0.0, (sum, p) => sum + p.totalCost);
  }

  bool get hasParticipants => selectedParticipants.isNotEmpty;
}
