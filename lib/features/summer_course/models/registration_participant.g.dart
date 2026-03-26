// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegistrationParticipantImpl _$$RegistrationParticipantImplFromJson(
  Map<String, dynamic> json,
) => _$RegistrationParticipantImpl(
  member: json['member'] == null
      ? null
      : Member.fromJson(json['member'] as Map<String, dynamic>),
  guest: json['guest'] == null
      ? null
      : Guest.fromJson(json['guest'] as Map<String, dynamic>),
  type: $enumDecode(_$ParticipantTypeEnumMap, json['type']),
  selectedWeekIds:
      (json['selectedWeekIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  calculatedCost: (json['calculatedCost'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$$RegistrationParticipantImplToJson(
  _$RegistrationParticipantImpl instance,
) => <String, dynamic>{
  'member': instance.member,
  'guest': instance.guest,
  'type': _$ParticipantTypeEnumMap[instance.type]!,
  'selectedWeekIds': instance.selectedWeekIds,
  'calculatedCost': instance.calculatedCost,
};

const _$ParticipantTypeEnumMap = {
  ParticipantType.socio: 'socio',
  ParticipantType.invitado: 'invitado',
  ParticipantType.colaborador: 'colaborador',
  ParticipantType.invColaborador: 'invColaborador',
};
