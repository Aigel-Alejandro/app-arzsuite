// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inscripcion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InscripcionModelImpl _$$InscripcionModelImplFromJson(
  Map<String, dynamic> json,
) => _$InscripcionModelImpl(
  id: (json['id'] as num).toInt(),
  actividadNombre: json['actividad_nombre'] as String,
  actividadIcono: json['actividad_icono'] as String?,
  actividadColor: json['actividad_color'] as String?,
  grupoNombre: json['grupo_nombre'] as String?,
  equipoNombre: json['equipo_nombre'] as String?,
  diaSemanaStr: json['dia_semana_str'] as String?,
  fechaClaseStr: json['fecha_clase_str'] as String?,
  horarioStr: json['horario_str'] as String?,
  lugarAsiento: json['lugar_asiento'] as String?,
  lugar: json['lugar'] as String?,
  fechaInscripcion: json['fecha_inscripcion'] as String?,
);

Map<String, dynamic> _$$InscripcionModelImplToJson(
  _$InscripcionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'actividad_nombre': instance.actividadNombre,
  'actividad_icono': instance.actividadIcono,
  'actividad_color': instance.actividadColor,
  'grupo_nombre': instance.grupoNombre,
  'equipo_nombre': instance.equipoNombre,
  'dia_semana_str': instance.diaSemanaStr,
  'fecha_clase_str': instance.fechaClaseStr,
  'horario_str': instance.horarioStr,
  'lugar_asiento': instance.lugarAsiento,
  'lugar': instance.lugar,
  'fecha_inscripcion': instance.fechaInscripcion,
};
