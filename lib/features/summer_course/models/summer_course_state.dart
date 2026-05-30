import 'member.dart';
import 'registration_participant.dart';

class SummerCourseState {
  final int currentStep;
  final Member? selectedTitular;
  final List<Member> beneficiariesList;
  final List<RegistrationParticipant> selectedParticipants;
  final bool isLoading;
  final String? errorMessage;
  final String? salesOrderId;
  final String? masterToken;
  final List<dynamic>? pickUpTokens;
  final Map<String, dynamic>? activeRegistration;
  final List<Map<String, dynamic>> courseCosts;
  final List<Map<String, dynamic>> courseWeeks;
  final List<Map<String, dynamic>> intensiveActivities;
  final bool termsAccepted;
  final bool termsRequired;
  final String? termsContent;
  final String? termsVersion;
  final int? termsId;

  const SummerCourseState({
    this.currentStep = 0,
    this.selectedTitular,
    this.beneficiariesList = const [],
    this.selectedParticipants = const [],
    this.isLoading = false,
    this.errorMessage,
    this.salesOrderId,
    this.masterToken,
    this.pickUpTokens,
    this.activeRegistration,
    this.courseCosts = const [],
    this.courseWeeks = const [],
    this.intensiveActivities = const [],
    this.termsAccepted = false,
    this.termsRequired = false,
    this.termsContent,
    this.termsVersion,
    this.termsId,
  });

  SummerCourseState copyWith({
    int? currentStep,
    Object? selectedTitular = const Object(),
    List<Member>? beneficiariesList,
    List<RegistrationParticipant>? selectedParticipants,
    bool? isLoading,
    Object? errorMessage = const Object(),
    Object? salesOrderId = const Object(),
    Object? masterToken = const Object(),
    Object? pickUpTokens = const Object(),
    Object? activeRegistration = const Object(),
    List<Map<String, dynamic>>? courseCosts,
    List<Map<String, dynamic>>? courseWeeks,
    List<Map<String, dynamic>>? intensiveActivities,
    bool? termsAccepted,
    bool? termsRequired,
    Object? termsContent = const Object(),
    Object? termsVersion = const Object(),
    Object? termsId = const Object(),
  }) {
    return SummerCourseState(
      currentStep: currentStep ?? this.currentStep,
      selectedTitular: selectedTitular == const Object() ? this.selectedTitular : selectedTitular as Member?,
      beneficiariesList: beneficiariesList ?? this.beneficiariesList,
      selectedParticipants: selectedParticipants ?? this.selectedParticipants,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage == const Object() ? this.errorMessage : errorMessage as String?,
      salesOrderId: salesOrderId == const Object() ? this.salesOrderId : salesOrderId as String?,
      masterToken: masterToken == const Object() ? this.masterToken : masterToken as String?,
      pickUpTokens: pickUpTokens == const Object() ? this.pickUpTokens : pickUpTokens as List<dynamic>?,
      activeRegistration: activeRegistration == const Object() ? this.activeRegistration : activeRegistration as Map<String, dynamic>?,
      courseCosts: courseCosts ?? this.courseCosts,
      courseWeeks: courseWeeks ?? this.courseWeeks,
      intensiveActivities: intensiveActivities ?? this.intensiveActivities,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      termsRequired: termsRequired ?? this.termsRequired,
      termsContent: termsContent == const Object() ? this.termsContent : termsContent as String?,
      termsVersion: termsVersion == const Object() ? this.termsVersion : termsVersion as String?,
      termsId: termsId == const Object() ? this.termsId : termsId as int?,
    );
  }

  factory SummerCourseState.fromJson(Map<String, dynamic> json) {
    return SummerCourseState(
      currentStep: json['currentStep'] as int? ?? 0,
      selectedTitular: json['selectedTitular'] != null ? Member.fromJson(json['selectedTitular']) : null,
      beneficiariesList: (json['beneficiariesList'] as List<dynamic>?)?.map((e) => Member.fromJson(e)).toList() ?? const [],
      selectedParticipants: (json['selectedParticipants'] as List<dynamic>?)?.map((e) => RegistrationParticipant.fromJson(e)).toList() ?? const [],
      isLoading: json['isLoading'] as bool? ?? false,
      errorMessage: json['errorMessage'] as String?,
      salesOrderId: json['salesOrderId'] as String?,
      masterToken: json['masterToken'] as String?,
      pickUpTokens: json['pickUpTokens'] as List<dynamic>?,
      activeRegistration: json['activeRegistration'] as Map<String, dynamic>?,
      courseCosts: (json['courseCosts'] as List<dynamic>?)?.map((e) => e as Map<String, dynamic>).toList() ?? const [],
      courseWeeks: (json['courseWeeks'] as List<dynamic>?)?.map((e) => e as Map<String, dynamic>).toList() ?? const [],
      intensiveActivities: (json['intensiveActivities'] as List<dynamic>?)?.map((e) => e as Map<String, dynamic>).toList() ?? const [],
      termsAccepted: json['termsAccepted'] as bool? ?? false,
      termsRequired: json['termsRequired'] as bool? ?? false,
      termsContent: json['termsContent'] as String?,
      termsVersion: json['termsVersion'] as String?,
      termsId: json['termsId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStep': currentStep,
      'selectedTitular': selectedTitular?.toJson(),
      'beneficiariesList': beneficiariesList.map((e) => e.toJson()).toList(),
      'selectedParticipants': selectedParticipants.map((e) => e.toJson()).toList(),
      'isLoading': isLoading,
      'errorMessage': errorMessage,
      'salesOrderId': salesOrderId,
      'masterToken': masterToken,
      'pickUpTokens': pickUpTokens,
      'activeRegistration': activeRegistration,
      'courseCosts': courseCosts,
      'courseWeeks': courseWeeks,
      'intensiveActivities': intensiveActivities,
      'termsAccepted': termsAccepted,
      'termsRequired': termsRequired,
      'termsContent': termsContent,
      'termsVersion': termsVersion,
      'termsId': termsId,
    };
  }

  double get totalGeneral {
    return selectedParticipants.fold(0.0, (sum, p) => sum + p.totalCost);
  }

  bool get hasParticipants => selectedParticipants.isNotEmpty;
}
