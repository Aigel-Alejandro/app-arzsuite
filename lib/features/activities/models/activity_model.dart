import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_model.freezed.dart';
part 'activity_model.g.dart';

@freezed
class ActivityModel with _$ActivityModel {
  const factory ActivityModel({
    required int id,
    @JsonKey(name: 'club_id') required int clubId,
    @JsonKey(name: 'club_name') String? clubName,
    @JsonKey(name: 'acceso_clubes') List<String>? accesoClubes,
    required String nombre,
    String? descripcion,
    String? icono,
    String? color,
    String? tipo,
    @JsonKey(name: 'tiene_costo') required bool tieneCosto,
    double? monto,
    @Default([]) List<ActivityGroupModel> grupos,
  }) = _ActivityModel;

  factory ActivityModel.fromJson(Map<String, dynamic> json) => _$ActivityModelFromJson(json);
}

@freezed
class ActivityGroupModel with _$ActivityGroupModel {
  const factory ActivityGroupModel({
    required int id,
    required String nombre,
    String? descripcion,
    @JsonKey(name: 'edad_min') int? edadMin,
    @JsonKey(name: 'edad_max') int? edadMax,
    @JsonKey(name: 'cupo_disponible') int? cupoDisponible,
    @JsonKey(name: 'tiene_cupo') required bool tieneCupo,
    @JsonKey(name: 'requiere_seleccion_lugares') @Default(false) bool requiereSeleccionLugares,
    @Default([]) List<ActivityTeamModel> equipos,
  }) = _ActivityGroupModel;

  factory ActivityGroupModel.fromJson(Map<String, dynamic> json) => _$ActivityGroupModelFromJson(json);
}

@freezed
class ActivityTeamModel with _$ActivityTeamModel {
  const factory ActivityTeamModel({
    required int id,
    required String nombre,
    String? color,
    @JsonKey(name: 'lugares_ocupados') @Default([]) List<String> lugaresOcupados,
    @Default([]) List<ActivityScheduleModel> horarios,
  }) = _ActivityTeamModel;

  factory ActivityTeamModel.fromJson(Map<String, dynamic> json) => _$ActivityTeamModelFromJson(json);
}

@freezed
class ActivityAreaPlanoPositionModel with _$ActivityAreaPlanoPositionModel {
  const factory ActivityAreaPlanoPositionModel({
    @JsonKey(name: 'fila_index') required int filaIndex,
    @JsonKey(name: 'columna_index') required int columnaIndex,
    required String etiqueta,
    required String tipo,
    @JsonKey(name: 'is_active') required bool isActive,
  }) = _ActivityAreaPlanoPositionModel;

  factory ActivityAreaPlanoPositionModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityAreaPlanoPositionModelFromJson(json);
}

@freezed
class ActivityAreaPlanoModel with _$ActivityAreaPlanoModel {
  const factory ActivityAreaPlanoModel({
    required int filas,
    required int columnas,
    @Default([]) List<ActivityAreaPlanoPositionModel> posiciones,
  }) = _ActivityAreaPlanoModel;

  factory ActivityAreaPlanoModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityAreaPlanoModelFromJson(json);
}

@freezed
class ActivityScheduleModel with _$ActivityScheduleModel {
  const factory ActivityScheduleModel({
    required int id,
    @JsonKey(name: 'dia_semana') required int diaSemana,
    @JsonKey(name: 'hora_inicio') required String horaInicio,
    @JsonKey(name: 'hora_fin') required String horaFin,
    String? lugar,
    @JsonKey(name: 'cupo_disponible') int? cupoDisponible,
    @JsonKey(name: 'tiene_cupo') @Default(false) bool tieneCupo,
    @JsonKey(name: 'cupo_maximo') int? cupoMaximo,
    @JsonKey(name: 'lugares_ocupados') @Default([]) List<String> lugaresOcupados,
    @JsonKey(name: 'area_id') int? areaId,
    @JsonKey(name: 'plano') ActivityAreaPlanoModel? plano,
  }) = _ActivityScheduleModel;

  factory ActivityScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityScheduleModelFromJson(json);
}
