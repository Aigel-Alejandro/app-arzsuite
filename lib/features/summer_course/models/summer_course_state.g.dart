// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summer_course_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SummerCourseStateImpl _$$SummerCourseStateImplFromJson(
  Map<String, dynamic> json,
) => _$SummerCourseStateImpl(
  currentStep: (json['currentStep'] as num?)?.toInt() ?? 0,
  selectedTitular: json['selectedTitular'] == null
      ? null
      : Member.fromJson(json['selectedTitular'] as Map<String, dynamic>),
  beneficiariesList:
      (json['beneficiariesList'] as List<dynamic>?)
          ?.map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  selectedParticipants:
      (json['selectedParticipants'] as List<dynamic>?)
          ?.map(
            (e) => RegistrationParticipant.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  isLoading: json['isLoading'] as bool? ?? false,
  errorMessage: json['errorMessage'] as String?,
  salesOrderId: json['salesOrderId'] as String?,
  masterToken: json['masterToken'] as String?,
  pickUpTokens: json['pickUpTokens'] as List<dynamic>?,
  activeRegistration: json['activeRegistration'] as Map<String, dynamic>?,
  courseCosts:
      (json['courseCosts'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ??
      const [],
  courseWeeks:
      (json['courseWeeks'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ??
      const [],
  intensiveActivities:
      (json['intensiveActivities'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ??
      const [],
  termsAccepted: json['termsAccepted'] as bool? ?? false,
  termsRequired: json['termsRequired'] as bool? ?? false,
  termsContent: json['termsContent'] as String?,
  termsVersion: json['termsVersion'] as String?,
  termsId: (json['termsId'] as num?)?.toInt(),
);

Map<String, dynamic> _$$SummerCourseStateImplToJson(
  _$SummerCourseStateImpl instance,
) => <String, dynamic>{
  'currentStep': instance.currentStep,
  'selectedTitular': instance.selectedTitular,
  'beneficiariesList': instance.beneficiariesList,
  'selectedParticipants': instance.selectedParticipants,
  'isLoading': instance.isLoading,
  'errorMessage': instance.errorMessage,
  'salesOrderId': instance.salesOrderId,
  'masterToken': instance.masterToken,
  'pickUpTokens': instance.pickUpTokens,
  'activeRegistration': instance.activeRegistration,
  'courseCosts': instance.courseCosts,
  'courseWeeks': instance.courseWeeks,
  'intensiveActivities': instance.intensiveActivities,
  'termsAccepted': instance.termsAccepted,
  'termsRequired': instance.termsRequired,
  'termsContent': instance.termsContent,
  'termsVersion': instance.termsVersion,
  'termsId': instance.termsId,
};
