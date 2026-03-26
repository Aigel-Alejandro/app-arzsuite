// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubMemberModelImpl _$$SubMemberModelImplFromJson(Map<String, dynamic> json) =>
    _$SubMemberModelImpl(
      id: json['id'] as String,
      fullname: json['fullname'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      membershipNumber: json['membershipNumber'] as String,
      memberType: json['memberType'] as String,
    );

Map<String, dynamic> _$$SubMemberModelImplToJson(
  _$SubMemberModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'fullname': instance.fullname,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'membershipNumber': instance.membershipNumber,
  'memberType': instance.memberType,
};
