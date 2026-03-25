// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileModelImpl _$$ProfileModelImplFromJson(Map<String, dynamic> json) =>
    _$ProfileModelImpl(
      id: json['id'] as String,
      entityid: json['entityid'] as String,
      fullname: json['fullname'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      rfc: json['rfc'] as String?,
      curp: json['curp'] as String?,
      address: json['address'] as String?,
      fiscalData: json['fiscal_data'] as Map<String, dynamic>?,
      settings: ProfileSettingsModel.fromJson(
        json['settings'] as Map<String, dynamic>,
      ),
      associatedMembers:
          (json['associated_members'] as List<dynamic>?)
              ?.map((e) => SubMemberModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ProfileModelImplToJson(_$ProfileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityid': instance.entityid,
      'fullname': instance.fullname,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'rfc': instance.rfc,
      'curp': instance.curp,
      'address': instance.address,
      'fiscal_data': instance.fiscalData,
      'settings': instance.settings,
      'associated_members': instance.associatedMembers,
    };
