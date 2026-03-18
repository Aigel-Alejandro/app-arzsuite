// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GuestImpl _$$GuestImplFromJson(Map<String, dynamic> json) => _$GuestImpl(
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  secondLastName: json['secondLastName'] as String?,
  email: json['email'] as String,
  phone: json['phone'] as String,
  relationship: json['relationship'] as String,
  titularMembershipNumber: json['titularMembershipNumber'] as String,
);

Map<String, dynamic> _$$GuestImplToJson(_$GuestImpl instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'secondLastName': instance.secondLastName,
      'email': instance.email,
      'phone': instance.phone,
      'relationship': instance.relationship,
      'titularMembershipNumber': instance.titularMembershipNumber,
    };
