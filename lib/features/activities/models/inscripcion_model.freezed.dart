// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inscripcion_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

InscripcionModel _$InscripcionModelFromJson(Map<String, dynamic> json) {
  return _InscripcionModel.fromJson(json);
}

/// @nodoc
mixin _$InscripcionModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'actividad_nombre')
  String get actividadNombre => throw _privateConstructorUsedError;
  @JsonKey(name: 'actividad_icono')
  String? get actividadIcono => throw _privateConstructorUsedError;
  @JsonKey(name: 'actividad_color')
  String? get actividadColor => throw _privateConstructorUsedError;
  @JsonKey(name: 'grupo_nombre')
  String? get grupoNombre => throw _privateConstructorUsedError;
  @JsonKey(name: 'equipo_nombre')
  String? get equipoNombre => throw _privateConstructorUsedError;
  @JsonKey(name: 'dia_semana_str')
  String? get diaSemanaStr => throw _privateConstructorUsedError;
  @JsonKey(name: 'fecha_clase_str')
  String? get fechaClaseStr => throw _privateConstructorUsedError; // "Jue 16 de Abr"
  @JsonKey(name: 'horario_str')
  String? get horarioStr => throw _privateConstructorUsedError; // "18:00 - 19:00 hrs"
  @JsonKey(name: 'lugar_asiento')
  String? get lugarAsiento => throw _privateConstructorUsedError; // "A1"
  @JsonKey(name: 'lugar')
  String? get lugar => throw _privateConstructorUsedError;
  @JsonKey(name: 'fecha_inscripcion')
  String? get fechaInscripcion => throw _privateConstructorUsedError;

  /// Serializes this InscripcionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InscripcionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InscripcionModelCopyWith<InscripcionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InscripcionModelCopyWith<$Res> {
  factory $InscripcionModelCopyWith(
    InscripcionModel value,
    $Res Function(InscripcionModel) then,
  ) = _$InscripcionModelCopyWithImpl<$Res, InscripcionModel>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'actividad_nombre') String actividadNombre,
    @JsonKey(name: 'actividad_icono') String? actividadIcono,
    @JsonKey(name: 'actividad_color') String? actividadColor,
    @JsonKey(name: 'grupo_nombre') String? grupoNombre,
    @JsonKey(name: 'equipo_nombre') String? equipoNombre,
    @JsonKey(name: 'dia_semana_str') String? diaSemanaStr,
    @JsonKey(name: 'fecha_clase_str') String? fechaClaseStr,
    @JsonKey(name: 'horario_str') String? horarioStr,
    @JsonKey(name: 'lugar_asiento') String? lugarAsiento,
    @JsonKey(name: 'lugar') String? lugar,
    @JsonKey(name: 'fecha_inscripcion') String? fechaInscripcion,
  });
}

/// @nodoc
class _$InscripcionModelCopyWithImpl<$Res, $Val extends InscripcionModel>
    implements $InscripcionModelCopyWith<$Res> {
  _$InscripcionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InscripcionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? actividadNombre = null,
    Object? actividadIcono = freezed,
    Object? actividadColor = freezed,
    Object? grupoNombre = freezed,
    Object? equipoNombre = freezed,
    Object? diaSemanaStr = freezed,
    Object? fechaClaseStr = freezed,
    Object? horarioStr = freezed,
    Object? lugarAsiento = freezed,
    Object? lugar = freezed,
    Object? fechaInscripcion = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            actividadNombre: null == actividadNombre
                ? _value.actividadNombre
                : actividadNombre // ignore: cast_nullable_to_non_nullable
                      as String,
            actividadIcono: freezed == actividadIcono
                ? _value.actividadIcono
                : actividadIcono // ignore: cast_nullable_to_non_nullable
                      as String?,
            actividadColor: freezed == actividadColor
                ? _value.actividadColor
                : actividadColor // ignore: cast_nullable_to_non_nullable
                      as String?,
            grupoNombre: freezed == grupoNombre
                ? _value.grupoNombre
                : grupoNombre // ignore: cast_nullable_to_non_nullable
                      as String?,
            equipoNombre: freezed == equipoNombre
                ? _value.equipoNombre
                : equipoNombre // ignore: cast_nullable_to_non_nullable
                      as String?,
            diaSemanaStr: freezed == diaSemanaStr
                ? _value.diaSemanaStr
                : diaSemanaStr // ignore: cast_nullable_to_non_nullable
                      as String?,
            fechaClaseStr: freezed == fechaClaseStr
                ? _value.fechaClaseStr
                : fechaClaseStr // ignore: cast_nullable_to_non_nullable
                      as String?,
            horarioStr: freezed == horarioStr
                ? _value.horarioStr
                : horarioStr // ignore: cast_nullable_to_non_nullable
                      as String?,
            lugarAsiento: freezed == lugarAsiento
                ? _value.lugarAsiento
                : lugarAsiento // ignore: cast_nullable_to_non_nullable
                      as String?,
            lugar: freezed == lugar
                ? _value.lugar
                : lugar // ignore: cast_nullable_to_non_nullable
                      as String?,
            fechaInscripcion: freezed == fechaInscripcion
                ? _value.fechaInscripcion
                : fechaInscripcion // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InscripcionModelImplCopyWith<$Res>
    implements $InscripcionModelCopyWith<$Res> {
  factory _$$InscripcionModelImplCopyWith(
    _$InscripcionModelImpl value,
    $Res Function(_$InscripcionModelImpl) then,
  ) = __$$InscripcionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'actividad_nombre') String actividadNombre,
    @JsonKey(name: 'actividad_icono') String? actividadIcono,
    @JsonKey(name: 'actividad_color') String? actividadColor,
    @JsonKey(name: 'grupo_nombre') String? grupoNombre,
    @JsonKey(name: 'equipo_nombre') String? equipoNombre,
    @JsonKey(name: 'dia_semana_str') String? diaSemanaStr,
    @JsonKey(name: 'fecha_clase_str') String? fechaClaseStr,
    @JsonKey(name: 'horario_str') String? horarioStr,
    @JsonKey(name: 'lugar_asiento') String? lugarAsiento,
    @JsonKey(name: 'lugar') String? lugar,
    @JsonKey(name: 'fecha_inscripcion') String? fechaInscripcion,
  });
}

/// @nodoc
class __$$InscripcionModelImplCopyWithImpl<$Res>
    extends _$InscripcionModelCopyWithImpl<$Res, _$InscripcionModelImpl>
    implements _$$InscripcionModelImplCopyWith<$Res> {
  __$$InscripcionModelImplCopyWithImpl(
    _$InscripcionModelImpl _value,
    $Res Function(_$InscripcionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InscripcionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? actividadNombre = null,
    Object? actividadIcono = freezed,
    Object? actividadColor = freezed,
    Object? grupoNombre = freezed,
    Object? equipoNombre = freezed,
    Object? diaSemanaStr = freezed,
    Object? fechaClaseStr = freezed,
    Object? horarioStr = freezed,
    Object? lugarAsiento = freezed,
    Object? lugar = freezed,
    Object? fechaInscripcion = freezed,
  }) {
    return _then(
      _$InscripcionModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        actividadNombre: null == actividadNombre
            ? _value.actividadNombre
            : actividadNombre // ignore: cast_nullable_to_non_nullable
                  as String,
        actividadIcono: freezed == actividadIcono
            ? _value.actividadIcono
            : actividadIcono // ignore: cast_nullable_to_non_nullable
                  as String?,
        actividadColor: freezed == actividadColor
            ? _value.actividadColor
            : actividadColor // ignore: cast_nullable_to_non_nullable
                  as String?,
        grupoNombre: freezed == grupoNombre
            ? _value.grupoNombre
            : grupoNombre // ignore: cast_nullable_to_non_nullable
                  as String?,
        equipoNombre: freezed == equipoNombre
            ? _value.equipoNombre
            : equipoNombre // ignore: cast_nullable_to_non_nullable
                  as String?,
        diaSemanaStr: freezed == diaSemanaStr
            ? _value.diaSemanaStr
            : diaSemanaStr // ignore: cast_nullable_to_non_nullable
                  as String?,
        fechaClaseStr: freezed == fechaClaseStr
            ? _value.fechaClaseStr
            : fechaClaseStr // ignore: cast_nullable_to_non_nullable
                  as String?,
        horarioStr: freezed == horarioStr
            ? _value.horarioStr
            : horarioStr // ignore: cast_nullable_to_non_nullable
                  as String?,
        lugarAsiento: freezed == lugarAsiento
            ? _value.lugarAsiento
            : lugarAsiento // ignore: cast_nullable_to_non_nullable
                  as String?,
        lugar: freezed == lugar
            ? _value.lugar
            : lugar // ignore: cast_nullable_to_non_nullable
                  as String?,
        fechaInscripcion: freezed == fechaInscripcion
            ? _value.fechaInscripcion
            : fechaInscripcion // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InscripcionModelImpl implements _InscripcionModel {
  const _$InscripcionModelImpl({
    required this.id,
    @JsonKey(name: 'actividad_nombre') required this.actividadNombre,
    @JsonKey(name: 'actividad_icono') this.actividadIcono,
    @JsonKey(name: 'actividad_color') this.actividadColor,
    @JsonKey(name: 'grupo_nombre') this.grupoNombre,
    @JsonKey(name: 'equipo_nombre') this.equipoNombre,
    @JsonKey(name: 'dia_semana_str') this.diaSemanaStr,
    @JsonKey(name: 'fecha_clase_str') this.fechaClaseStr,
    @JsonKey(name: 'horario_str') this.horarioStr,
    @JsonKey(name: 'lugar_asiento') this.lugarAsiento,
    @JsonKey(name: 'lugar') this.lugar,
    @JsonKey(name: 'fecha_inscripcion') this.fechaInscripcion,
  });

  factory _$InscripcionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InscripcionModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'actividad_nombre')
  final String actividadNombre;
  @override
  @JsonKey(name: 'actividad_icono')
  final String? actividadIcono;
  @override
  @JsonKey(name: 'actividad_color')
  final String? actividadColor;
  @override
  @JsonKey(name: 'grupo_nombre')
  final String? grupoNombre;
  @override
  @JsonKey(name: 'equipo_nombre')
  final String? equipoNombre;
  @override
  @JsonKey(name: 'dia_semana_str')
  final String? diaSemanaStr;
  @override
  @JsonKey(name: 'fecha_clase_str')
  final String? fechaClaseStr;
  // "Jue 16 de Abr"
  @override
  @JsonKey(name: 'horario_str')
  final String? horarioStr;
  // "18:00 - 19:00 hrs"
  @override
  @JsonKey(name: 'lugar_asiento')
  final String? lugarAsiento;
  // "A1"
  @override
  @JsonKey(name: 'lugar')
  final String? lugar;
  @override
  @JsonKey(name: 'fecha_inscripcion')
  final String? fechaInscripcion;

  @override
  String toString() {
    return 'InscripcionModel(id: $id, actividadNombre: $actividadNombre, actividadIcono: $actividadIcono, actividadColor: $actividadColor, grupoNombre: $grupoNombre, equipoNombre: $equipoNombre, diaSemanaStr: $diaSemanaStr, fechaClaseStr: $fechaClaseStr, horarioStr: $horarioStr, lugarAsiento: $lugarAsiento, lugar: $lugar, fechaInscripcion: $fechaInscripcion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InscripcionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.actividadNombre, actividadNombre) ||
                other.actividadNombre == actividadNombre) &&
            (identical(other.actividadIcono, actividadIcono) ||
                other.actividadIcono == actividadIcono) &&
            (identical(other.actividadColor, actividadColor) ||
                other.actividadColor == actividadColor) &&
            (identical(other.grupoNombre, grupoNombre) ||
                other.grupoNombre == grupoNombre) &&
            (identical(other.equipoNombre, equipoNombre) ||
                other.equipoNombre == equipoNombre) &&
            (identical(other.diaSemanaStr, diaSemanaStr) ||
                other.diaSemanaStr == diaSemanaStr) &&
            (identical(other.fechaClaseStr, fechaClaseStr) ||
                other.fechaClaseStr == fechaClaseStr) &&
            (identical(other.horarioStr, horarioStr) ||
                other.horarioStr == horarioStr) &&
            (identical(other.lugarAsiento, lugarAsiento) ||
                other.lugarAsiento == lugarAsiento) &&
            (identical(other.lugar, lugar) || other.lugar == lugar) &&
            (identical(other.fechaInscripcion, fechaInscripcion) ||
                other.fechaInscripcion == fechaInscripcion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    actividadNombre,
    actividadIcono,
    actividadColor,
    grupoNombre,
    equipoNombre,
    diaSemanaStr,
    fechaClaseStr,
    horarioStr,
    lugarAsiento,
    lugar,
    fechaInscripcion,
  );

  /// Create a copy of InscripcionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InscripcionModelImplCopyWith<_$InscripcionModelImpl> get copyWith =>
      __$$InscripcionModelImplCopyWithImpl<_$InscripcionModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InscripcionModelImplToJson(this);
  }
}

abstract class _InscripcionModel implements InscripcionModel {
  const factory _InscripcionModel({
    required final int id,
    @JsonKey(name: 'actividad_nombre') required final String actividadNombre,
    @JsonKey(name: 'actividad_icono') final String? actividadIcono,
    @JsonKey(name: 'actividad_color') final String? actividadColor,
    @JsonKey(name: 'grupo_nombre') final String? grupoNombre,
    @JsonKey(name: 'equipo_nombre') final String? equipoNombre,
    @JsonKey(name: 'dia_semana_str') final String? diaSemanaStr,
    @JsonKey(name: 'fecha_clase_str') final String? fechaClaseStr,
    @JsonKey(name: 'horario_str') final String? horarioStr,
    @JsonKey(name: 'lugar_asiento') final String? lugarAsiento,
    @JsonKey(name: 'lugar') final String? lugar,
    @JsonKey(name: 'fecha_inscripcion') final String? fechaInscripcion,
  }) = _$InscripcionModelImpl;

  factory _InscripcionModel.fromJson(Map<String, dynamic> json) =
      _$InscripcionModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'actividad_nombre')
  String get actividadNombre;
  @override
  @JsonKey(name: 'actividad_icono')
  String? get actividadIcono;
  @override
  @JsonKey(name: 'actividad_color')
  String? get actividadColor;
  @override
  @JsonKey(name: 'grupo_nombre')
  String? get grupoNombre;
  @override
  @JsonKey(name: 'equipo_nombre')
  String? get equipoNombre;
  @override
  @JsonKey(name: 'dia_semana_str')
  String? get diaSemanaStr;
  @override
  @JsonKey(name: 'fecha_clase_str')
  String? get fechaClaseStr; // "Jue 16 de Abr"
  @override
  @JsonKey(name: 'horario_str')
  String? get horarioStr; // "18:00 - 19:00 hrs"
  @override
  @JsonKey(name: 'lugar_asiento')
  String? get lugarAsiento; // "A1"
  @override
  @JsonKey(name: 'lugar')
  String? get lugar;
  @override
  @JsonKey(name: 'fecha_inscripcion')
  String? get fechaInscripcion;

  /// Create a copy of InscripcionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InscripcionModelImplCopyWith<_$InscripcionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
