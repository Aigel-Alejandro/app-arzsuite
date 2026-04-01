// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityModelImpl _$$ActivityModelImplFromJson(Map<String, dynamic> json) =>
    _$ActivityModelImpl(
      id: (json['id'] as num).toInt(),
      clubId: (json['club_id'] as num).toInt(),
      clubName: json['club_name'] as String?,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      icono: json['icono'] as String?,
      color: json['color'] as String?,
      tipo: json['tipo'] as String?,
      tieneCosto: json['tiene_costo'] as bool,
      monto: (json['monto'] as num?)?.toDouble(),
      grupos:
          (json['grupos'] as List<dynamic>?)
              ?.map(
                (e) => ActivityGroupModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ActivityModelImplToJson(_$ActivityModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'club_id': instance.clubId,
      'club_name': instance.clubName,
      'nombre': instance.nombre,
      'descripcion': instance.descripcion,
      'icono': instance.icono,
      'color': instance.color,
      'tipo': instance.tipo,
      'tiene_costo': instance.tieneCosto,
      'monto': instance.monto,
      'grupos': instance.grupos,
    };

_$ActivityGroupModelImpl _$$ActivityGroupModelImplFromJson(
  Map<String, dynamic> json,
) => _$ActivityGroupModelImpl(
  id: (json['id'] as num).toInt(),
  nombre: json['nombre'] as String,
  descripcion: json['descripcion'] as String?,
  edadMin: (json['edad_min'] as num?)?.toInt(),
  edadMax: (json['edad_max'] as num?)?.toInt(),
  cupoDisponible: (json['cupo_disponible'] as num?)?.toInt(),
  tieneCupo: json['tiene_cupo'] as bool,
  equipos:
      (json['equipos'] as List<dynamic>?)
          ?.map((e) => ActivityTeamModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ActivityGroupModelImplToJson(
  _$ActivityGroupModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'nombre': instance.nombre,
  'descripcion': instance.descripcion,
  'edad_min': instance.edadMin,
  'edad_max': instance.edadMax,
  'cupo_disponible': instance.cupoDisponible,
  'tiene_cupo': instance.tieneCupo,
  'equipos': instance.equipos,
};

_$ActivityTeamModelImpl _$$ActivityTeamModelImplFromJson(
  Map<String, dynamic> json,
) => _$ActivityTeamModelImpl(
  id: (json['id'] as num).toInt(),
  nombre: json['nombre'] as String,
  color: json['color'] as String?,
  horarios:
      (json['horarios'] as List<dynamic>?)
          ?.map(
            (e) => ActivityScheduleModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ActivityTeamModelImplToJson(
  _$ActivityTeamModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'nombre': instance.nombre,
  'color': instance.color,
  'horarios': instance.horarios,
};

_$ActivityScheduleModelImpl _$$ActivityScheduleModelImplFromJson(
  Map<String, dynamic> json,
) => _$ActivityScheduleModelImpl(
  id: (json['id'] as num).toInt(),
  diaSemana: (json['dia_semana'] as num).toInt(),
  horaInicio: json['hora_inicio'] as String,
  horaFin: json['hora_fin'] as String,
  lugar: json['lugar'] as String?,
  cupoDisponible: (json['cupo_disponible'] as num?)?.toInt(),
  tieneCupo: json['tiene_cupo'] as bool? ?? false,
);

Map<String, dynamic> _$$ActivityScheduleModelImplToJson(
  _$ActivityScheduleModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'dia_semana': instance.diaSemana,
  'hora_inicio': instance.horaInicio,
  'hora_fin': instance.horaFin,
  'lugar': instance.lugar,
  'cupo_disponible': instance.cupoDisponible,
  'tiene_cupo': instance.tieneCupo,
};
