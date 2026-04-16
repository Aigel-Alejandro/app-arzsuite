// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TournamentModelImpl _$$TournamentModelImplFromJson(
  Map<String, dynamic> json,
) => _$TournamentModelImpl(
  id: (json['id'] as num).toInt(),
  actividadId: (json['actividad_id'] as num?)?.toInt(),
  actividadNombre: json['actividad_nombre'] as String?,
  clubNombre: json['club_nombre'] as String?,
  nombre: json['nombre'] as String,
  descripcion: json['descripcion'] as String?,
  formato: json['formato'] as String?,
  sede: json['sede'] as String?,
  fechaInicio: json['fecha_inicio'] as String?,
  fechaFin: json['fecha_fin'] as String?,
  equiposDisponibles:
      (json['equipos_disponibles'] as List<dynamic>?)
          ?.map((e) => TournamentTeamModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  sociosInscritos:
      (json['socios_inscritos'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  participantes:
      (json['participantes'] as List<dynamic>?)
          ?.map(
            (e) =>
                TournamentParticipantModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
  partidos:
      (json['partidos'] as List<dynamic>?)
          ?.map((e) => TournamentMatchModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  isUserInscribed: json['is_user_inscribed'] as bool? ?? false,
);

Map<String, dynamic> _$$TournamentModelImplToJson(
  _$TournamentModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'actividad_id': instance.actividadId,
  'actividad_nombre': instance.actividadNombre,
  'club_nombre': instance.clubNombre,
  'nombre': instance.nombre,
  'descripcion': instance.descripcion,
  'formato': instance.formato,
  'sede': instance.sede,
  'fecha_inicio': instance.fechaInicio,
  'fecha_fin': instance.fechaFin,
  'equipos_disponibles': instance.equiposDisponibles,
  'socios_inscritos': instance.sociosInscritos,
  'participantes': instance.participantes,
  'partidos': instance.partidos,
  'is_user_inscribed': instance.isUserInscribed,
};

_$TournamentTeamModelImpl _$$TournamentTeamModelImplFromJson(
  Map<String, dynamic> json,
) => _$TournamentTeamModelImpl(
  id: (json['id'] as num).toInt(),
  nombre: json['nombre'] as String,
  color: json['color'] as String?,
  edadMinima: (json['edad_minima'] as num?)?.toInt(),
  edadMaxima: (json['edad_maxima'] as num?)?.toInt(),
  generoPermitido: json['genero_permitido'] as String?,
  cupoMaximo: (json['cupo_maximo'] as num?)?.toInt(),
  cupoActual: (json['cupo_actual'] as num?)?.toInt() ?? 0,
  capitanActual: json['capitan_actual'] as String?,
  isUserCaptain: json['is_user_captain'] as bool? ?? false,
);

Map<String, dynamic> _$$TournamentTeamModelImplToJson(
  _$TournamentTeamModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'nombre': instance.nombre,
  'color': instance.color,
  'edad_minima': instance.edadMinima,
  'edad_maxima': instance.edadMaxima,
  'genero_permitido': instance.generoPermitido,
  'cupo_maximo': instance.cupoMaximo,
  'cupo_actual': instance.cupoActual,
  'capitan_actual': instance.capitanActual,
  'is_user_captain': instance.isUserCaptain,
};

_$TournamentParticipantModelImpl _$$TournamentParticipantModelImplFromJson(
  Map<String, dynamic> json,
) => _$TournamentParticipantModelImpl(
  nombre: json['nombre'] as String,
  equipoId: (json['equipo_id'] as num).toInt(),
  edad: (json['edad'] as num?)?.toInt(),
);

Map<String, dynamic> _$$TournamentParticipantModelImplToJson(
  _$TournamentParticipantModelImpl instance,
) => <String, dynamic>{
  'nombre': instance.nombre,
  'equipo_id': instance.equipoId,
  'edad': instance.edad,
};

_$TournamentMatchModelImpl _$$TournamentMatchModelImplFromJson(
  Map<String, dynamic> json,
) => _$TournamentMatchModelImpl(
  id: (json['id'] as num).toInt(),
  torneoId: (json['torneo_id'] as num).toInt(),
  equipoLocalId: (json['equipo_local_id'] as num).toInt(),
  rivalNombre: json['rival_nombre'] as String,
  fecha: json['fecha'] as String?,
  lugar: json['lugar'] as String?,
  esLocal: json['es_local'] as bool? ?? true,
  golesLocal: (json['goles_local'] as num?)?.toInt(),
  golesVisitante: (json['goles_visitante'] as num?)?.toInt(),
  estado: json['estado'] as String?,
  resultadoAprobadoLocal: json['resultado_aprobado_local'] as bool? ?? false,
  resultadoAprobadoVisitante:
      json['resultado_aprobado_visitante'] as bool? ?? false,
);

Map<String, dynamic> _$$TournamentMatchModelImplToJson(
  _$TournamentMatchModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'torneo_id': instance.torneoId,
  'equipo_local_id': instance.equipoLocalId,
  'rival_nombre': instance.rivalNombre,
  'fecha': instance.fecha,
  'lugar': instance.lugar,
  'es_local': instance.esLocal,
  'goles_local': instance.golesLocal,
  'goles_visitante': instance.golesVisitante,
  'estado': instance.estado,
  'resultado_aprobado_local': instance.resultadoAprobadoLocal,
  'resultado_aprobado_visitante': instance.resultadoAprobadoVisitante,
};
