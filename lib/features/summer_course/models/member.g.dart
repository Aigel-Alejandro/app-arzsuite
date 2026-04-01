// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemberImpl _$$MemberImplFromJson(Map<String, dynamic> json) => _$MemberImpl(
  id: json['id'] as String,
  membershipNumber: json['membershipNumber'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  secondLastName: json['secondLastName'] as String?,
  memberType: json['memberType'] as String,
  isTitular: json['isTitular'] as bool? ?? false,
  photoUrl: json['photoUrl'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  token: json['token'] as String?,
  permissions:
      (json['permissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  age: (json['age'] as num?)?.toInt(),
);

Map<String, dynamic> _$$MemberImplToJson(_$MemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'membershipNumber': instance.membershipNumber,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'secondLastName': instance.secondLastName,
      'memberType': instance.memberType,
      'isTitular': instance.isTitular,
      'photoUrl': instance.photoUrl,
      'email': instance.email,
      'phone': instance.phone,
      'token': instance.token,
      'permissions': instance.permissions,
      'age': instance.age,
    };
