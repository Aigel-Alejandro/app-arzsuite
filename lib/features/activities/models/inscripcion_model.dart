import 'package:freezed_annotation/freezed_annotation.dart';

part 'inscripcion_model.freezed.dart';
part 'inscripcion_model.g.dart';

@freezed
class InscripcionModel with _$InscripcionModel {
  const factory InscripcionModel({
    required int id,
    @JsonKey(name: 'actividad_nombre') required String actividadNombre,
    @JsonKey(name: 'actividad_icono') String? actividadIcono,
    @JsonKey(name: 'actividad_color') String? actividadColor,
    @JsonKey(name: 'grupo_nombre') String? grupoNombre,
    @JsonKey(name: 'equipo_nombre') String? equipoNombre,
    @JsonKey(name: 'dia_semana_str') String? diaSemanaStr,
    @JsonKey(name: 'fecha_clase_str') String? fechaClaseStr,   // "Jue 16 de Abr"
    @JsonKey(name: 'horario_str') String? horarioStr,          // "18:00 - 19:00 hrs"
    @JsonKey(name: 'lugar_asiento') String? lugarAsiento,      // "A1"
    @JsonKey(name: 'lugar') String? lugar,
    @JsonKey(name: 'fecha_inscripcion') String? fechaInscripcion,
  }) = _InscripcionModel;

  factory InscripcionModel.fromJson(Map<String, dynamic> json) =>
      _$InscripcionModelFromJson(json);
}
