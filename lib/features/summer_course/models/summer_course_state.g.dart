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
  pickUpTokens: json['pickUpTokens'] as List<dynamic>?,
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
  'pickUpTokens': instance.pickUpTokens,
};
