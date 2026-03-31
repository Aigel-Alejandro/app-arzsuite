import 'package:freezed_annotation/freezed_annotation.dart';

part 'tournament_model.freezed.dart';
part 'tournament_model.g.dart';

@freezed
class TournamentModel with _$TournamentModel {
  const factory TournamentModel({
    required int id,
    @JsonKey(name: 'actividad_id') int? actividadId,
    @JsonKey(name: 'actividad_nombre') String? actividadNombre,
    @JsonKey(name: 'club_nombre') String? clubNombre,
    required String nombre,
    String? descripcion,
    String? formato,
    String? sede,
    @JsonKey(name: 'fecha_inicio') String? fechaInicio,
    @JsonKey(name: 'fecha_fin') String? fechaFin,
    @JsonKey(name: 'equipos_disponibles', defaultValue: []) required List<TournamentTeamModel> equiposDisponibles,
    @JsonKey(name: 'socios_inscritos', defaultValue: []) required List<String> sociosInscritos,
    @JsonKey(name: 'participantes', defaultValue: []) required List<TournamentParticipantModel> participantes,
    @JsonKey(name: 'partidos', defaultValue: []) @Default([]) List<TournamentMatchModel> partidos,
  }) = _TournamentModel;

  factory TournamentModel.fromJson(Map<String, dynamic> json) => _$TournamentModelFromJson(json);
}

@freezed
class TournamentTeamModel with _$TournamentTeamModel {
  const factory TournamentTeamModel({
    required int id,
    required String nombre,
    String? color,
    @JsonKey(name: 'edad_minima') int? edadMinima,
    @JsonKey(name: 'edad_maxima') int? edadMaxima,
    @JsonKey(name: 'genero_permitido') String? generoPermitido,
    @JsonKey(name: 'cupo_maximo') int? cupoMaximo,
    @JsonKey(name: 'cupo_actual', defaultValue: 0) required int cupoActual,
    @JsonKey(name: 'capitan_actual') String? capitanActual,
    @JsonKey(name: 'is_user_captain') @Default(false) bool isUserCaptain,
  }) = _TournamentTeamModel;

  factory TournamentTeamModel.fromJson(Map<String, dynamic> json) => _$TournamentTeamModelFromJson(json);
}

@freezed
class TournamentParticipantModel with _$TournamentParticipantModel {
  const factory TournamentParticipantModel({
    @JsonKey(name: 'nombre') required String nombre,
    @JsonKey(name: 'equipo_id') required int equipoId,
    @JsonKey(name: 'edad') int? edad,
  }) = _TournamentParticipantModel;

  factory TournamentParticipantModel.fromJson(Map<String, dynamic> json) => _$TournamentParticipantModelFromJson(json);
}

@freezed
class TournamentMatchModel with _$TournamentMatchModel {
  const factory TournamentMatchModel({
    required int id,
    @JsonKey(name: 'torneo_id') required int torneoId,
    @JsonKey(name: 'equipo_local_id') required int equipoLocalId,
    @JsonKey(name: 'rival_nombre') required String rivalNombre,
    String? fecha,
    String? lugar,
    @JsonKey(name: 'es_local') @Default(true) bool esLocal,
    @JsonKey(name: 'goles_local') int? golesLocal,
    @JsonKey(name: 'goles_visitante') int? golesVisitante,
    String? estado, // programado, en_curso, finalizado, cancelado, pospuesto
    @JsonKey(name: 'resultado_aprobado_local') @Default(false) bool resultadoAprobadoLocal,
    @JsonKey(name: 'resultado_aprobado_visitante') @Default(false) bool resultadoAprobadoVisitante,
  }) = _TournamentMatchModel;

  factory TournamentMatchModel.fromJson(Map<String, dynamic> json) => _$TournamentMatchModelFromJson(json);
}
