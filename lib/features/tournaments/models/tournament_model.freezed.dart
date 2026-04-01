// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TournamentModel _$TournamentModelFromJson(Map<String, dynamic> json) {
  return _TournamentModel.fromJson(json);
}

/// @nodoc
mixin _$TournamentModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'actividad_id')
  int? get actividadId => throw _privateConstructorUsedError;
  @JsonKey(name: 'actividad_nombre')
  String? get actividadNombre => throw _privateConstructorUsedError;
  @JsonKey(name: 'club_nombre')
  String? get clubNombre => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  String? get descripcion => throw _privateConstructorUsedError;
  String? get formato => throw _privateConstructorUsedError;
  String? get sede => throw _privateConstructorUsedError;
  @JsonKey(name: 'fecha_inicio')
  String? get fechaInicio => throw _privateConstructorUsedError;
  @JsonKey(name: 'fecha_fin')
  String? get fechaFin => throw _privateConstructorUsedError;
  @JsonKey(name: 'equipos_disponibles', defaultValue: [])
  List<TournamentTeamModel> get equiposDisponibles =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'socios_inscritos', defaultValue: [])
  List<String> get sociosInscritos => throw _privateConstructorUsedError;
  @JsonKey(name: 'participantes', defaultValue: [])
  List<TournamentParticipantModel> get participantes =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'partidos', defaultValue: [])
  List<TournamentMatchModel> get partidos => throw _privateConstructorUsedError;

  /// Serializes this TournamentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TournamentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TournamentModelCopyWith<TournamentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TournamentModelCopyWith<$Res> {
  factory $TournamentModelCopyWith(
    TournamentModel value,
    $Res Function(TournamentModel) then,
  ) = _$TournamentModelCopyWithImpl<$Res, TournamentModel>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'actividad_id') int? actividadId,
    @JsonKey(name: 'actividad_nombre') String? actividadNombre,
    @JsonKey(name: 'club_nombre') String? clubNombre,
    String nombre,
    String? descripcion,
    String? formato,
    String? sede,
    @JsonKey(name: 'fecha_inicio') String? fechaInicio,
    @JsonKey(name: 'fecha_fin') String? fechaFin,
    @JsonKey(name: 'equipos_disponibles', defaultValue: [])
    List<TournamentTeamModel> equiposDisponibles,
    @JsonKey(name: 'socios_inscritos', defaultValue: [])
    List<String> sociosInscritos,
    @JsonKey(name: 'participantes', defaultValue: [])
    List<TournamentParticipantModel> participantes,
    @JsonKey(name: 'partidos', defaultValue: [])
    List<TournamentMatchModel> partidos,
  });
}

/// @nodoc
class _$TournamentModelCopyWithImpl<$Res, $Val extends TournamentModel>
    implements $TournamentModelCopyWith<$Res> {
  _$TournamentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TournamentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? actividadId = freezed,
    Object? actividadNombre = freezed,
    Object? clubNombre = freezed,
    Object? nombre = null,
    Object? descripcion = freezed,
    Object? formato = freezed,
    Object? sede = freezed,
    Object? fechaInicio = freezed,
    Object? fechaFin = freezed,
    Object? equiposDisponibles = null,
    Object? sociosInscritos = null,
    Object? participantes = null,
    Object? partidos = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            actividadId: freezed == actividadId
                ? _value.actividadId
                : actividadId // ignore: cast_nullable_to_non_nullable
                      as int?,
            actividadNombre: freezed == actividadNombre
                ? _value.actividadNombre
                : actividadNombre // ignore: cast_nullable_to_non_nullable
                      as String?,
            clubNombre: freezed == clubNombre
                ? _value.clubNombre
                : clubNombre // ignore: cast_nullable_to_non_nullable
                      as String?,
            nombre: null == nombre
                ? _value.nombre
                : nombre // ignore: cast_nullable_to_non_nullable
                      as String,
            descripcion: freezed == descripcion
                ? _value.descripcion
                : descripcion // ignore: cast_nullable_to_non_nullable
                      as String?,
            formato: freezed == formato
                ? _value.formato
                : formato // ignore: cast_nullable_to_non_nullable
                      as String?,
            sede: freezed == sede
                ? _value.sede
                : sede // ignore: cast_nullable_to_non_nullable
                      as String?,
            fechaInicio: freezed == fechaInicio
                ? _value.fechaInicio
                : fechaInicio // ignore: cast_nullable_to_non_nullable
                      as String?,
            fechaFin: freezed == fechaFin
                ? _value.fechaFin
                : fechaFin // ignore: cast_nullable_to_non_nullable
                      as String?,
            equiposDisponibles: null == equiposDisponibles
                ? _value.equiposDisponibles
                : equiposDisponibles // ignore: cast_nullable_to_non_nullable
                      as List<TournamentTeamModel>,
            sociosInscritos: null == sociosInscritos
                ? _value.sociosInscritos
                : sociosInscritos // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            participantes: null == participantes
                ? _value.participantes
                : participantes // ignore: cast_nullable_to_non_nullable
                      as List<TournamentParticipantModel>,
            partidos: null == partidos
                ? _value.partidos
                : partidos // ignore: cast_nullable_to_non_nullable
                      as List<TournamentMatchModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TournamentModelImplCopyWith<$Res>
    implements $TournamentModelCopyWith<$Res> {
  factory _$$TournamentModelImplCopyWith(
    _$TournamentModelImpl value,
    $Res Function(_$TournamentModelImpl) then,
  ) = __$$TournamentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'actividad_id') int? actividadId,
    @JsonKey(name: 'actividad_nombre') String? actividadNombre,
    @JsonKey(name: 'club_nombre') String? clubNombre,
    String nombre,
    String? descripcion,
    String? formato,
    String? sede,
    @JsonKey(name: 'fecha_inicio') String? fechaInicio,
    @JsonKey(name: 'fecha_fin') String? fechaFin,
    @JsonKey(name: 'equipos_disponibles', defaultValue: [])
    List<TournamentTeamModel> equiposDisponibles,
    @JsonKey(name: 'socios_inscritos', defaultValue: [])
    List<String> sociosInscritos,
    @JsonKey(name: 'participantes', defaultValue: [])
    List<TournamentParticipantModel> participantes,
    @JsonKey(name: 'partidos', defaultValue: [])
    List<TournamentMatchModel> partidos,
  });
}

/// @nodoc
class __$$TournamentModelImplCopyWithImpl<$Res>
    extends _$TournamentModelCopyWithImpl<$Res, _$TournamentModelImpl>
    implements _$$TournamentModelImplCopyWith<$Res> {
  __$$TournamentModelImplCopyWithImpl(
    _$TournamentModelImpl _value,
    $Res Function(_$TournamentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TournamentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? actividadId = freezed,
    Object? actividadNombre = freezed,
    Object? clubNombre = freezed,
    Object? nombre = null,
    Object? descripcion = freezed,
    Object? formato = freezed,
    Object? sede = freezed,
    Object? fechaInicio = freezed,
    Object? fechaFin = freezed,
    Object? equiposDisponibles = null,
    Object? sociosInscritos = null,
    Object? participantes = null,
    Object? partidos = null,
  }) {
    return _then(
      _$TournamentModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        actividadId: freezed == actividadId
            ? _value.actividadId
            : actividadId // ignore: cast_nullable_to_non_nullable
                  as int?,
        actividadNombre: freezed == actividadNombre
            ? _value.actividadNombre
            : actividadNombre // ignore: cast_nullable_to_non_nullable
                  as String?,
        clubNombre: freezed == clubNombre
            ? _value.clubNombre
            : clubNombre // ignore: cast_nullable_to_non_nullable
                  as String?,
        nombre: null == nombre
            ? _value.nombre
            : nombre // ignore: cast_nullable_to_non_nullable
                  as String,
        descripcion: freezed == descripcion
            ? _value.descripcion
            : descripcion // ignore: cast_nullable_to_non_nullable
                  as String?,
        formato: freezed == formato
            ? _value.formato
            : formato // ignore: cast_nullable_to_non_nullable
                  as String?,
        sede: freezed == sede
            ? _value.sede
            : sede // ignore: cast_nullable_to_non_nullable
                  as String?,
        fechaInicio: freezed == fechaInicio
            ? _value.fechaInicio
            : fechaInicio // ignore: cast_nullable_to_non_nullable
                  as String?,
        fechaFin: freezed == fechaFin
            ? _value.fechaFin
            : fechaFin // ignore: cast_nullable_to_non_nullable
                  as String?,
        equiposDisponibles: null == equiposDisponibles
            ? _value._equiposDisponibles
            : equiposDisponibles // ignore: cast_nullable_to_non_nullable
                  as List<TournamentTeamModel>,
        sociosInscritos: null == sociosInscritos
            ? _value._sociosInscritos
            : sociosInscritos // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        participantes: null == participantes
            ? _value._participantes
            : participantes // ignore: cast_nullable_to_non_nullable
                  as List<TournamentParticipantModel>,
        partidos: null == partidos
            ? _value._partidos
            : partidos // ignore: cast_nullable_to_non_nullable
                  as List<TournamentMatchModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TournamentModelImpl implements _TournamentModel {
  const _$TournamentModelImpl({
    required this.id,
    @JsonKey(name: 'actividad_id') this.actividadId,
    @JsonKey(name: 'actividad_nombre') this.actividadNombre,
    @JsonKey(name: 'club_nombre') this.clubNombre,
    required this.nombre,
    this.descripcion,
    this.formato,
    this.sede,
    @JsonKey(name: 'fecha_inicio') this.fechaInicio,
    @JsonKey(name: 'fecha_fin') this.fechaFin,
    @JsonKey(name: 'equipos_disponibles', defaultValue: [])
    required final List<TournamentTeamModel> equiposDisponibles,
    @JsonKey(name: 'socios_inscritos', defaultValue: [])
    required final List<String> sociosInscritos,
    @JsonKey(name: 'participantes', defaultValue: [])
    required final List<TournamentParticipantModel> participantes,
    @JsonKey(name: 'partidos', defaultValue: [])
    final List<TournamentMatchModel> partidos = const [],
  }) : _equiposDisponibles = equiposDisponibles,
       _sociosInscritos = sociosInscritos,
       _participantes = participantes,
       _partidos = partidos;

  factory _$TournamentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TournamentModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'actividad_id')
  final int? actividadId;
  @override
  @JsonKey(name: 'actividad_nombre')
  final String? actividadNombre;
  @override
  @JsonKey(name: 'club_nombre')
  final String? clubNombre;
  @override
  final String nombre;
  @override
  final String? descripcion;
  @override
  final String? formato;
  @override
  final String? sede;
  @override
  @JsonKey(name: 'fecha_inicio')
  final String? fechaInicio;
  @override
  @JsonKey(name: 'fecha_fin')
  final String? fechaFin;
  final List<TournamentTeamModel> _equiposDisponibles;
  @override
  @JsonKey(name: 'equipos_disponibles', defaultValue: [])
  List<TournamentTeamModel> get equiposDisponibles {
    if (_equiposDisponibles is EqualUnmodifiableListView)
      return _equiposDisponibles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_equiposDisponibles);
  }

  final List<String> _sociosInscritos;
  @override
  @JsonKey(name: 'socios_inscritos', defaultValue: [])
  List<String> get sociosInscritos {
    if (_sociosInscritos is EqualUnmodifiableListView) return _sociosInscritos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sociosInscritos);
  }

  final List<TournamentParticipantModel> _participantes;
  @override
  @JsonKey(name: 'participantes', defaultValue: [])
  List<TournamentParticipantModel> get participantes {
    if (_participantes is EqualUnmodifiableListView) return _participantes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participantes);
  }

  final List<TournamentMatchModel> _partidos;
  @override
  @JsonKey(name: 'partidos', defaultValue: [])
  List<TournamentMatchModel> get partidos {
    if (_partidos is EqualUnmodifiableListView) return _partidos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_partidos);
  }

  @override
  String toString() {
    return 'TournamentModel(id: $id, actividadId: $actividadId, actividadNombre: $actividadNombre, clubNombre: $clubNombre, nombre: $nombre, descripcion: $descripcion, formato: $formato, sede: $sede, fechaInicio: $fechaInicio, fechaFin: $fechaFin, equiposDisponibles: $equiposDisponibles, sociosInscritos: $sociosInscritos, participantes: $participantes, partidos: $partidos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TournamentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.actividadId, actividadId) ||
                other.actividadId == actividadId) &&
            (identical(other.actividadNombre, actividadNombre) ||
                other.actividadNombre == actividadNombre) &&
            (identical(other.clubNombre, clubNombre) ||
                other.clubNombre == clubNombre) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.descripcion, descripcion) ||
                other.descripcion == descripcion) &&
            (identical(other.formato, formato) || other.formato == formato) &&
            (identical(other.sede, sede) || other.sede == sede) &&
            (identical(other.fechaInicio, fechaInicio) ||
                other.fechaInicio == fechaInicio) &&
            (identical(other.fechaFin, fechaFin) ||
                other.fechaFin == fechaFin) &&
            const DeepCollectionEquality().equals(
              other._equiposDisponibles,
              _equiposDisponibles,
            ) &&
            const DeepCollectionEquality().equals(
              other._sociosInscritos,
              _sociosInscritos,
            ) &&
            const DeepCollectionEquality().equals(
              other._participantes,
              _participantes,
            ) &&
            const DeepCollectionEquality().equals(other._partidos, _partidos));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    actividadId,
    actividadNombre,
    clubNombre,
    nombre,
    descripcion,
    formato,
    sede,
    fechaInicio,
    fechaFin,
    const DeepCollectionEquality().hash(_equiposDisponibles),
    const DeepCollectionEquality().hash(_sociosInscritos),
    const DeepCollectionEquality().hash(_participantes),
    const DeepCollectionEquality().hash(_partidos),
  );

  /// Create a copy of TournamentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TournamentModelImplCopyWith<_$TournamentModelImpl> get copyWith =>
      __$$TournamentModelImplCopyWithImpl<_$TournamentModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TournamentModelImplToJson(this);
  }
}

abstract class _TournamentModel implements TournamentModel {
  const factory _TournamentModel({
    required final int id,
    @JsonKey(name: 'actividad_id') final int? actividadId,
    @JsonKey(name: 'actividad_nombre') final String? actividadNombre,
    @JsonKey(name: 'club_nombre') final String? clubNombre,
    required final String nombre,
    final String? descripcion,
    final String? formato,
    final String? sede,
    @JsonKey(name: 'fecha_inicio') final String? fechaInicio,
    @JsonKey(name: 'fecha_fin') final String? fechaFin,
    @JsonKey(name: 'equipos_disponibles', defaultValue: [])
    required final List<TournamentTeamModel> equiposDisponibles,
    @JsonKey(name: 'socios_inscritos', defaultValue: [])
    required final List<String> sociosInscritos,
    @JsonKey(name: 'participantes', defaultValue: [])
    required final List<TournamentParticipantModel> participantes,
    @JsonKey(name: 'partidos', defaultValue: [])
    final List<TournamentMatchModel> partidos,
  }) = _$TournamentModelImpl;

  factory _TournamentModel.fromJson(Map<String, dynamic> json) =
      _$TournamentModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'actividad_id')
  int? get actividadId;
  @override
  @JsonKey(name: 'actividad_nombre')
  String? get actividadNombre;
  @override
  @JsonKey(name: 'club_nombre')
  String? get clubNombre;
  @override
  String get nombre;
  @override
  String? get descripcion;
  @override
  String? get formato;
  @override
  String? get sede;
  @override
  @JsonKey(name: 'fecha_inicio')
  String? get fechaInicio;
  @override
  @JsonKey(name: 'fecha_fin')
  String? get fechaFin;
  @override
  @JsonKey(name: 'equipos_disponibles', defaultValue: [])
  List<TournamentTeamModel> get equiposDisponibles;
  @override
  @JsonKey(name: 'socios_inscritos', defaultValue: [])
  List<String> get sociosInscritos;
  @override
  @JsonKey(name: 'participantes', defaultValue: [])
  List<TournamentParticipantModel> get participantes;
  @override
  @JsonKey(name: 'partidos', defaultValue: [])
  List<TournamentMatchModel> get partidos;

  /// Create a copy of TournamentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TournamentModelImplCopyWith<_$TournamentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TournamentTeamModel _$TournamentTeamModelFromJson(Map<String, dynamic> json) {
  return _TournamentTeamModel.fromJson(json);
}

/// @nodoc
mixin _$TournamentTeamModel {
  int get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  @JsonKey(name: 'edad_minima')
  int? get edadMinima => throw _privateConstructorUsedError;
  @JsonKey(name: 'edad_maxima')
  int? get edadMaxima => throw _privateConstructorUsedError;
  @JsonKey(name: 'genero_permitido')
  String? get generoPermitido => throw _privateConstructorUsedError;
  @JsonKey(name: 'cupo_maximo')
  int? get cupoMaximo => throw _privateConstructorUsedError;
  @JsonKey(name: 'cupo_actual', defaultValue: 0)
  int get cupoActual => throw _privateConstructorUsedError;
  @JsonKey(name: 'capitan_actual')
  String? get capitanActual => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_user_captain')
  bool get isUserCaptain => throw _privateConstructorUsedError;

  /// Serializes this TournamentTeamModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TournamentTeamModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TournamentTeamModelCopyWith<TournamentTeamModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TournamentTeamModelCopyWith<$Res> {
  factory $TournamentTeamModelCopyWith(
    TournamentTeamModel value,
    $Res Function(TournamentTeamModel) then,
  ) = _$TournamentTeamModelCopyWithImpl<$Res, TournamentTeamModel>;
  @useResult
  $Res call({
    int id,
    String nombre,
    String? color,
    @JsonKey(name: 'edad_minima') int? edadMinima,
    @JsonKey(name: 'edad_maxima') int? edadMaxima,
    @JsonKey(name: 'genero_permitido') String? generoPermitido,
    @JsonKey(name: 'cupo_maximo') int? cupoMaximo,
    @JsonKey(name: 'cupo_actual', defaultValue: 0) int cupoActual,
    @JsonKey(name: 'capitan_actual') String? capitanActual,
    @JsonKey(name: 'is_user_captain') bool isUserCaptain,
  });
}

/// @nodoc
class _$TournamentTeamModelCopyWithImpl<$Res, $Val extends TournamentTeamModel>
    implements $TournamentTeamModelCopyWith<$Res> {
  _$TournamentTeamModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TournamentTeamModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? color = freezed,
    Object? edadMinima = freezed,
    Object? edadMaxima = freezed,
    Object? generoPermitido = freezed,
    Object? cupoMaximo = freezed,
    Object? cupoActual = null,
    Object? capitanActual = freezed,
    Object? isUserCaptain = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            nombre: null == nombre
                ? _value.nombre
                : nombre // ignore: cast_nullable_to_non_nullable
                      as String,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
            edadMinima: freezed == edadMinima
                ? _value.edadMinima
                : edadMinima // ignore: cast_nullable_to_non_nullable
                      as int?,
            edadMaxima: freezed == edadMaxima
                ? _value.edadMaxima
                : edadMaxima // ignore: cast_nullable_to_non_nullable
                      as int?,
            generoPermitido: freezed == generoPermitido
                ? _value.generoPermitido
                : generoPermitido // ignore: cast_nullable_to_non_nullable
                      as String?,
            cupoMaximo: freezed == cupoMaximo
                ? _value.cupoMaximo
                : cupoMaximo // ignore: cast_nullable_to_non_nullable
                      as int?,
            cupoActual: null == cupoActual
                ? _value.cupoActual
                : cupoActual // ignore: cast_nullable_to_non_nullable
                      as int,
            capitanActual: freezed == capitanActual
                ? _value.capitanActual
                : capitanActual // ignore: cast_nullable_to_non_nullable
                      as String?,
            isUserCaptain: null == isUserCaptain
                ? _value.isUserCaptain
                : isUserCaptain // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TournamentTeamModelImplCopyWith<$Res>
    implements $TournamentTeamModelCopyWith<$Res> {
  factory _$$TournamentTeamModelImplCopyWith(
    _$TournamentTeamModelImpl value,
    $Res Function(_$TournamentTeamModelImpl) then,
  ) = __$$TournamentTeamModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String nombre,
    String? color,
    @JsonKey(name: 'edad_minima') int? edadMinima,
    @JsonKey(name: 'edad_maxima') int? edadMaxima,
    @JsonKey(name: 'genero_permitido') String? generoPermitido,
    @JsonKey(name: 'cupo_maximo') int? cupoMaximo,
    @JsonKey(name: 'cupo_actual', defaultValue: 0) int cupoActual,
    @JsonKey(name: 'capitan_actual') String? capitanActual,
    @JsonKey(name: 'is_user_captain') bool isUserCaptain,
  });
}

/// @nodoc
class __$$TournamentTeamModelImplCopyWithImpl<$Res>
    extends _$TournamentTeamModelCopyWithImpl<$Res, _$TournamentTeamModelImpl>
    implements _$$TournamentTeamModelImplCopyWith<$Res> {
  __$$TournamentTeamModelImplCopyWithImpl(
    _$TournamentTeamModelImpl _value,
    $Res Function(_$TournamentTeamModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TournamentTeamModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? color = freezed,
    Object? edadMinima = freezed,
    Object? edadMaxima = freezed,
    Object? generoPermitido = freezed,
    Object? cupoMaximo = freezed,
    Object? cupoActual = null,
    Object? capitanActual = freezed,
    Object? isUserCaptain = null,
  }) {
    return _then(
      _$TournamentTeamModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        nombre: null == nombre
            ? _value.nombre
            : nombre // ignore: cast_nullable_to_non_nullable
                  as String,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
        edadMinima: freezed == edadMinima
            ? _value.edadMinima
            : edadMinima // ignore: cast_nullable_to_non_nullable
                  as int?,
        edadMaxima: freezed == edadMaxima
            ? _value.edadMaxima
            : edadMaxima // ignore: cast_nullable_to_non_nullable
                  as int?,
        generoPermitido: freezed == generoPermitido
            ? _value.generoPermitido
            : generoPermitido // ignore: cast_nullable_to_non_nullable
                  as String?,
        cupoMaximo: freezed == cupoMaximo
            ? _value.cupoMaximo
            : cupoMaximo // ignore: cast_nullable_to_non_nullable
                  as int?,
        cupoActual: null == cupoActual
            ? _value.cupoActual
            : cupoActual // ignore: cast_nullable_to_non_nullable
                  as int,
        capitanActual: freezed == capitanActual
            ? _value.capitanActual
            : capitanActual // ignore: cast_nullable_to_non_nullable
                  as String?,
        isUserCaptain: null == isUserCaptain
            ? _value.isUserCaptain
            : isUserCaptain // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TournamentTeamModelImpl implements _TournamentTeamModel {
  const _$TournamentTeamModelImpl({
    required this.id,
    required this.nombre,
    this.color,
    @JsonKey(name: 'edad_minima') this.edadMinima,
    @JsonKey(name: 'edad_maxima') this.edadMaxima,
    @JsonKey(name: 'genero_permitido') this.generoPermitido,
    @JsonKey(name: 'cupo_maximo') this.cupoMaximo,
    @JsonKey(name: 'cupo_actual', defaultValue: 0) required this.cupoActual,
    @JsonKey(name: 'capitan_actual') this.capitanActual,
    @JsonKey(name: 'is_user_captain') this.isUserCaptain = false,
  });

  factory _$TournamentTeamModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TournamentTeamModelImplFromJson(json);

  @override
  final int id;
  @override
  final String nombre;
  @override
  final String? color;
  @override
  @JsonKey(name: 'edad_minima')
  final int? edadMinima;
  @override
  @JsonKey(name: 'edad_maxima')
  final int? edadMaxima;
  @override
  @JsonKey(name: 'genero_permitido')
  final String? generoPermitido;
  @override
  @JsonKey(name: 'cupo_maximo')
  final int? cupoMaximo;
  @override
  @JsonKey(name: 'cupo_actual', defaultValue: 0)
  final int cupoActual;
  @override
  @JsonKey(name: 'capitan_actual')
  final String? capitanActual;
  @override
  @JsonKey(name: 'is_user_captain')
  final bool isUserCaptain;

  @override
  String toString() {
    return 'TournamentTeamModel(id: $id, nombre: $nombre, color: $color, edadMinima: $edadMinima, edadMaxima: $edadMaxima, generoPermitido: $generoPermitido, cupoMaximo: $cupoMaximo, cupoActual: $cupoActual, capitanActual: $capitanActual, isUserCaptain: $isUserCaptain)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TournamentTeamModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.edadMinima, edadMinima) ||
                other.edadMinima == edadMinima) &&
            (identical(other.edadMaxima, edadMaxima) ||
                other.edadMaxima == edadMaxima) &&
            (identical(other.generoPermitido, generoPermitido) ||
                other.generoPermitido == generoPermitido) &&
            (identical(other.cupoMaximo, cupoMaximo) ||
                other.cupoMaximo == cupoMaximo) &&
            (identical(other.cupoActual, cupoActual) ||
                other.cupoActual == cupoActual) &&
            (identical(other.capitanActual, capitanActual) ||
                other.capitanActual == capitanActual) &&
            (identical(other.isUserCaptain, isUserCaptain) ||
                other.isUserCaptain == isUserCaptain));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    nombre,
    color,
    edadMinima,
    edadMaxima,
    generoPermitido,
    cupoMaximo,
    cupoActual,
    capitanActual,
    isUserCaptain,
  );

  /// Create a copy of TournamentTeamModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TournamentTeamModelImplCopyWith<_$TournamentTeamModelImpl> get copyWith =>
      __$$TournamentTeamModelImplCopyWithImpl<_$TournamentTeamModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TournamentTeamModelImplToJson(this);
  }
}

abstract class _TournamentTeamModel implements TournamentTeamModel {
  const factory _TournamentTeamModel({
    required final int id,
    required final String nombre,
    final String? color,
    @JsonKey(name: 'edad_minima') final int? edadMinima,
    @JsonKey(name: 'edad_maxima') final int? edadMaxima,
    @JsonKey(name: 'genero_permitido') final String? generoPermitido,
    @JsonKey(name: 'cupo_maximo') final int? cupoMaximo,
    @JsonKey(name: 'cupo_actual', defaultValue: 0)
    required final int cupoActual,
    @JsonKey(name: 'capitan_actual') final String? capitanActual,
    @JsonKey(name: 'is_user_captain') final bool isUserCaptain,
  }) = _$TournamentTeamModelImpl;

  factory _TournamentTeamModel.fromJson(Map<String, dynamic> json) =
      _$TournamentTeamModelImpl.fromJson;

  @override
  int get id;
  @override
  String get nombre;
  @override
  String? get color;
  @override
  @JsonKey(name: 'edad_minima')
  int? get edadMinima;
  @override
  @JsonKey(name: 'edad_maxima')
  int? get edadMaxima;
  @override
  @JsonKey(name: 'genero_permitido')
  String? get generoPermitido;
  @override
  @JsonKey(name: 'cupo_maximo')
  int? get cupoMaximo;
  @override
  @JsonKey(name: 'cupo_actual', defaultValue: 0)
  int get cupoActual;
  @override
  @JsonKey(name: 'capitan_actual')
  String? get capitanActual;
  @override
  @JsonKey(name: 'is_user_captain')
  bool get isUserCaptain;

  /// Create a copy of TournamentTeamModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TournamentTeamModelImplCopyWith<_$TournamentTeamModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TournamentParticipantModel _$TournamentParticipantModelFromJson(
  Map<String, dynamic> json,
) {
  return _TournamentParticipantModel.fromJson(json);
}

/// @nodoc
mixin _$TournamentParticipantModel {
  @JsonKey(name: 'nombre')
  String get nombre => throw _privateConstructorUsedError;
  @JsonKey(name: 'equipo_id')
  int get equipoId => throw _privateConstructorUsedError;
  @JsonKey(name: 'edad')
  int? get edad => throw _privateConstructorUsedError;

  /// Serializes this TournamentParticipantModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TournamentParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TournamentParticipantModelCopyWith<TournamentParticipantModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TournamentParticipantModelCopyWith<$Res> {
  factory $TournamentParticipantModelCopyWith(
    TournamentParticipantModel value,
    $Res Function(TournamentParticipantModel) then,
  ) =
      _$TournamentParticipantModelCopyWithImpl<
        $Res,
        TournamentParticipantModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'nombre') String nombre,
    @JsonKey(name: 'equipo_id') int equipoId,
    @JsonKey(name: 'edad') int? edad,
  });
}

/// @nodoc
class _$TournamentParticipantModelCopyWithImpl<
  $Res,
  $Val extends TournamentParticipantModel
>
    implements $TournamentParticipantModelCopyWith<$Res> {
  _$TournamentParticipantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TournamentParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nombre = null,
    Object? equipoId = null,
    Object? edad = freezed,
  }) {
    return _then(
      _value.copyWith(
            nombre: null == nombre
                ? _value.nombre
                : nombre // ignore: cast_nullable_to_non_nullable
                      as String,
            equipoId: null == equipoId
                ? _value.equipoId
                : equipoId // ignore: cast_nullable_to_non_nullable
                      as int,
            edad: freezed == edad
                ? _value.edad
                : edad // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TournamentParticipantModelImplCopyWith<$Res>
    implements $TournamentParticipantModelCopyWith<$Res> {
  factory _$$TournamentParticipantModelImplCopyWith(
    _$TournamentParticipantModelImpl value,
    $Res Function(_$TournamentParticipantModelImpl) then,
  ) = __$$TournamentParticipantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'nombre') String nombre,
    @JsonKey(name: 'equipo_id') int equipoId,
    @JsonKey(name: 'edad') int? edad,
  });
}

/// @nodoc
class __$$TournamentParticipantModelImplCopyWithImpl<$Res>
    extends
        _$TournamentParticipantModelCopyWithImpl<
          $Res,
          _$TournamentParticipantModelImpl
        >
    implements _$$TournamentParticipantModelImplCopyWith<$Res> {
  __$$TournamentParticipantModelImplCopyWithImpl(
    _$TournamentParticipantModelImpl _value,
    $Res Function(_$TournamentParticipantModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TournamentParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nombre = null,
    Object? equipoId = null,
    Object? edad = freezed,
  }) {
    return _then(
      _$TournamentParticipantModelImpl(
        nombre: null == nombre
            ? _value.nombre
            : nombre // ignore: cast_nullable_to_non_nullable
                  as String,
        equipoId: null == equipoId
            ? _value.equipoId
            : equipoId // ignore: cast_nullable_to_non_nullable
                  as int,
        edad: freezed == edad
            ? _value.edad
            : edad // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TournamentParticipantModelImpl implements _TournamentParticipantModel {
  const _$TournamentParticipantModelImpl({
    @JsonKey(name: 'nombre') required this.nombre,
    @JsonKey(name: 'equipo_id') required this.equipoId,
    @JsonKey(name: 'edad') this.edad,
  });

  factory _$TournamentParticipantModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$TournamentParticipantModelImplFromJson(json);

  @override
  @JsonKey(name: 'nombre')
  final String nombre;
  @override
  @JsonKey(name: 'equipo_id')
  final int equipoId;
  @override
  @JsonKey(name: 'edad')
  final int? edad;

  @override
  String toString() {
    return 'TournamentParticipantModel(nombre: $nombre, equipoId: $equipoId, edad: $edad)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TournamentParticipantModelImpl &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.equipoId, equipoId) ||
                other.equipoId == equipoId) &&
            (identical(other.edad, edad) || other.edad == edad));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nombre, equipoId, edad);

  /// Create a copy of TournamentParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TournamentParticipantModelImplCopyWith<_$TournamentParticipantModelImpl>
  get copyWith =>
      __$$TournamentParticipantModelImplCopyWithImpl<
        _$TournamentParticipantModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TournamentParticipantModelImplToJson(this);
  }
}

abstract class _TournamentParticipantModel
    implements TournamentParticipantModel {
  const factory _TournamentParticipantModel({
    @JsonKey(name: 'nombre') required final String nombre,
    @JsonKey(name: 'equipo_id') required final int equipoId,
    @JsonKey(name: 'edad') final int? edad,
  }) = _$TournamentParticipantModelImpl;

  factory _TournamentParticipantModel.fromJson(Map<String, dynamic> json) =
      _$TournamentParticipantModelImpl.fromJson;

  @override
  @JsonKey(name: 'nombre')
  String get nombre;
  @override
  @JsonKey(name: 'equipo_id')
  int get equipoId;
  @override
  @JsonKey(name: 'edad')
  int? get edad;

  /// Create a copy of TournamentParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TournamentParticipantModelImplCopyWith<_$TournamentParticipantModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

TournamentMatchModel _$TournamentMatchModelFromJson(Map<String, dynamic> json) {
  return _TournamentMatchModel.fromJson(json);
}

/// @nodoc
mixin _$TournamentMatchModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'torneo_id')
  int get torneoId => throw _privateConstructorUsedError;
  @JsonKey(name: 'equipo_local_id')
  int get equipoLocalId => throw _privateConstructorUsedError;
  @JsonKey(name: 'rival_nombre')
  String get rivalNombre => throw _privateConstructorUsedError;
  String? get fecha => throw _privateConstructorUsedError;
  String? get lugar => throw _privateConstructorUsedError;
  @JsonKey(name: 'es_local')
  bool get esLocal => throw _privateConstructorUsedError;
  @JsonKey(name: 'goles_local')
  int? get golesLocal => throw _privateConstructorUsedError;
  @JsonKey(name: 'goles_visitante')
  int? get golesVisitante => throw _privateConstructorUsedError;
  String? get estado =>
      throw _privateConstructorUsedError; // programado, en_curso, finalizado, cancelado, pospuesto
  @JsonKey(name: 'resultado_aprobado_local')
  bool get resultadoAprobadoLocal => throw _privateConstructorUsedError;
  @JsonKey(name: 'resultado_aprobado_visitante')
  bool get resultadoAprobadoVisitante => throw _privateConstructorUsedError;

  /// Serializes this TournamentMatchModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TournamentMatchModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TournamentMatchModelCopyWith<TournamentMatchModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TournamentMatchModelCopyWith<$Res> {
  factory $TournamentMatchModelCopyWith(
    TournamentMatchModel value,
    $Res Function(TournamentMatchModel) then,
  ) = _$TournamentMatchModelCopyWithImpl<$Res, TournamentMatchModel>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'torneo_id') int torneoId,
    @JsonKey(name: 'equipo_local_id') int equipoLocalId,
    @JsonKey(name: 'rival_nombre') String rivalNombre,
    String? fecha,
    String? lugar,
    @JsonKey(name: 'es_local') bool esLocal,
    @JsonKey(name: 'goles_local') int? golesLocal,
    @JsonKey(name: 'goles_visitante') int? golesVisitante,
    String? estado,
    @JsonKey(name: 'resultado_aprobado_local') bool resultadoAprobadoLocal,
    @JsonKey(name: 'resultado_aprobado_visitante')
    bool resultadoAprobadoVisitante,
  });
}

/// @nodoc
class _$TournamentMatchModelCopyWithImpl<
  $Res,
  $Val extends TournamentMatchModel
>
    implements $TournamentMatchModelCopyWith<$Res> {
  _$TournamentMatchModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TournamentMatchModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? torneoId = null,
    Object? equipoLocalId = null,
    Object? rivalNombre = null,
    Object? fecha = freezed,
    Object? lugar = freezed,
    Object? esLocal = null,
    Object? golesLocal = freezed,
    Object? golesVisitante = freezed,
    Object? estado = freezed,
    Object? resultadoAprobadoLocal = null,
    Object? resultadoAprobadoVisitante = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            torneoId: null == torneoId
                ? _value.torneoId
                : torneoId // ignore: cast_nullable_to_non_nullable
                      as int,
            equipoLocalId: null == equipoLocalId
                ? _value.equipoLocalId
                : equipoLocalId // ignore: cast_nullable_to_non_nullable
                      as int,
            rivalNombre: null == rivalNombre
                ? _value.rivalNombre
                : rivalNombre // ignore: cast_nullable_to_non_nullable
                      as String,
            fecha: freezed == fecha
                ? _value.fecha
                : fecha // ignore: cast_nullable_to_non_nullable
                      as String?,
            lugar: freezed == lugar
                ? _value.lugar
                : lugar // ignore: cast_nullable_to_non_nullable
                      as String?,
            esLocal: null == esLocal
                ? _value.esLocal
                : esLocal // ignore: cast_nullable_to_non_nullable
                      as bool,
            golesLocal: freezed == golesLocal
                ? _value.golesLocal
                : golesLocal // ignore: cast_nullable_to_non_nullable
                      as int?,
            golesVisitante: freezed == golesVisitante
                ? _value.golesVisitante
                : golesVisitante // ignore: cast_nullable_to_non_nullable
                      as int?,
            estado: freezed == estado
                ? _value.estado
                : estado // ignore: cast_nullable_to_non_nullable
                      as String?,
            resultadoAprobadoLocal: null == resultadoAprobadoLocal
                ? _value.resultadoAprobadoLocal
                : resultadoAprobadoLocal // ignore: cast_nullable_to_non_nullable
                      as bool,
            resultadoAprobadoVisitante: null == resultadoAprobadoVisitante
                ? _value.resultadoAprobadoVisitante
                : resultadoAprobadoVisitante // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TournamentMatchModelImplCopyWith<$Res>
    implements $TournamentMatchModelCopyWith<$Res> {
  factory _$$TournamentMatchModelImplCopyWith(
    _$TournamentMatchModelImpl value,
    $Res Function(_$TournamentMatchModelImpl) then,
  ) = __$$TournamentMatchModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'torneo_id') int torneoId,
    @JsonKey(name: 'equipo_local_id') int equipoLocalId,
    @JsonKey(name: 'rival_nombre') String rivalNombre,
    String? fecha,
    String? lugar,
    @JsonKey(name: 'es_local') bool esLocal,
    @JsonKey(name: 'goles_local') int? golesLocal,
    @JsonKey(name: 'goles_visitante') int? golesVisitante,
    String? estado,
    @JsonKey(name: 'resultado_aprobado_local') bool resultadoAprobadoLocal,
    @JsonKey(name: 'resultado_aprobado_visitante')
    bool resultadoAprobadoVisitante,
  });
}

/// @nodoc
class __$$TournamentMatchModelImplCopyWithImpl<$Res>
    extends _$TournamentMatchModelCopyWithImpl<$Res, _$TournamentMatchModelImpl>
    implements _$$TournamentMatchModelImplCopyWith<$Res> {
  __$$TournamentMatchModelImplCopyWithImpl(
    _$TournamentMatchModelImpl _value,
    $Res Function(_$TournamentMatchModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TournamentMatchModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? torneoId = null,
    Object? equipoLocalId = null,
    Object? rivalNombre = null,
    Object? fecha = freezed,
    Object? lugar = freezed,
    Object? esLocal = null,
    Object? golesLocal = freezed,
    Object? golesVisitante = freezed,
    Object? estado = freezed,
    Object? resultadoAprobadoLocal = null,
    Object? resultadoAprobadoVisitante = null,
  }) {
    return _then(
      _$TournamentMatchModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        torneoId: null == torneoId
            ? _value.torneoId
            : torneoId // ignore: cast_nullable_to_non_nullable
                  as int,
        equipoLocalId: null == equipoLocalId
            ? _value.equipoLocalId
            : equipoLocalId // ignore: cast_nullable_to_non_nullable
                  as int,
        rivalNombre: null == rivalNombre
            ? _value.rivalNombre
            : rivalNombre // ignore: cast_nullable_to_non_nullable
                  as String,
        fecha: freezed == fecha
            ? _value.fecha
            : fecha // ignore: cast_nullable_to_non_nullable
                  as String?,
        lugar: freezed == lugar
            ? _value.lugar
            : lugar // ignore: cast_nullable_to_non_nullable
                  as String?,
        esLocal: null == esLocal
            ? _value.esLocal
            : esLocal // ignore: cast_nullable_to_non_nullable
                  as bool,
        golesLocal: freezed == golesLocal
            ? _value.golesLocal
            : golesLocal // ignore: cast_nullable_to_non_nullable
                  as int?,
        golesVisitante: freezed == golesVisitante
            ? _value.golesVisitante
            : golesVisitante // ignore: cast_nullable_to_non_nullable
                  as int?,
        estado: freezed == estado
            ? _value.estado
            : estado // ignore: cast_nullable_to_non_nullable
                  as String?,
        resultadoAprobadoLocal: null == resultadoAprobadoLocal
            ? _value.resultadoAprobadoLocal
            : resultadoAprobadoLocal // ignore: cast_nullable_to_non_nullable
                  as bool,
        resultadoAprobadoVisitante: null == resultadoAprobadoVisitante
            ? _value.resultadoAprobadoVisitante
            : resultadoAprobadoVisitante // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TournamentMatchModelImpl implements _TournamentMatchModel {
  const _$TournamentMatchModelImpl({
    required this.id,
    @JsonKey(name: 'torneo_id') required this.torneoId,
    @JsonKey(name: 'equipo_local_id') required this.equipoLocalId,
    @JsonKey(name: 'rival_nombre') required this.rivalNombre,
    this.fecha,
    this.lugar,
    @JsonKey(name: 'es_local') this.esLocal = true,
    @JsonKey(name: 'goles_local') this.golesLocal,
    @JsonKey(name: 'goles_visitante') this.golesVisitante,
    this.estado,
    @JsonKey(name: 'resultado_aprobado_local')
    this.resultadoAprobadoLocal = false,
    @JsonKey(name: 'resultado_aprobado_visitante')
    this.resultadoAprobadoVisitante = false,
  });

  factory _$TournamentMatchModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TournamentMatchModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'torneo_id')
  final int torneoId;
  @override
  @JsonKey(name: 'equipo_local_id')
  final int equipoLocalId;
  @override
  @JsonKey(name: 'rival_nombre')
  final String rivalNombre;
  @override
  final String? fecha;
  @override
  final String? lugar;
  @override
  @JsonKey(name: 'es_local')
  final bool esLocal;
  @override
  @JsonKey(name: 'goles_local')
  final int? golesLocal;
  @override
  @JsonKey(name: 'goles_visitante')
  final int? golesVisitante;
  @override
  final String? estado;
  // programado, en_curso, finalizado, cancelado, pospuesto
  @override
  @JsonKey(name: 'resultado_aprobado_local')
  final bool resultadoAprobadoLocal;
  @override
  @JsonKey(name: 'resultado_aprobado_visitante')
  final bool resultadoAprobadoVisitante;

  @override
  String toString() {
    return 'TournamentMatchModel(id: $id, torneoId: $torneoId, equipoLocalId: $equipoLocalId, rivalNombre: $rivalNombre, fecha: $fecha, lugar: $lugar, esLocal: $esLocal, golesLocal: $golesLocal, golesVisitante: $golesVisitante, estado: $estado, resultadoAprobadoLocal: $resultadoAprobadoLocal, resultadoAprobadoVisitante: $resultadoAprobadoVisitante)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TournamentMatchModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.torneoId, torneoId) ||
                other.torneoId == torneoId) &&
            (identical(other.equipoLocalId, equipoLocalId) ||
                other.equipoLocalId == equipoLocalId) &&
            (identical(other.rivalNombre, rivalNombre) ||
                other.rivalNombre == rivalNombre) &&
            (identical(other.fecha, fecha) || other.fecha == fecha) &&
            (identical(other.lugar, lugar) || other.lugar == lugar) &&
            (identical(other.esLocal, esLocal) || other.esLocal == esLocal) &&
            (identical(other.golesLocal, golesLocal) ||
                other.golesLocal == golesLocal) &&
            (identical(other.golesVisitante, golesVisitante) ||
                other.golesVisitante == golesVisitante) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.resultadoAprobadoLocal, resultadoAprobadoLocal) ||
                other.resultadoAprobadoLocal == resultadoAprobadoLocal) &&
            (identical(
                  other.resultadoAprobadoVisitante,
                  resultadoAprobadoVisitante,
                ) ||
                other.resultadoAprobadoVisitante ==
                    resultadoAprobadoVisitante));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    torneoId,
    equipoLocalId,
    rivalNombre,
    fecha,
    lugar,
    esLocal,
    golesLocal,
    golesVisitante,
    estado,
    resultadoAprobadoLocal,
    resultadoAprobadoVisitante,
  );

  /// Create a copy of TournamentMatchModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TournamentMatchModelImplCopyWith<_$TournamentMatchModelImpl>
  get copyWith =>
      __$$TournamentMatchModelImplCopyWithImpl<_$TournamentMatchModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TournamentMatchModelImplToJson(this);
  }
}

abstract class _TournamentMatchModel implements TournamentMatchModel {
  const factory _TournamentMatchModel({
    required final int id,
    @JsonKey(name: 'torneo_id') required final int torneoId,
    @JsonKey(name: 'equipo_local_id') required final int equipoLocalId,
    @JsonKey(name: 'rival_nombre') required final String rivalNombre,
    final String? fecha,
    final String? lugar,
    @JsonKey(name: 'es_local') final bool esLocal,
    @JsonKey(name: 'goles_local') final int? golesLocal,
    @JsonKey(name: 'goles_visitante') final int? golesVisitante,
    final String? estado,
    @JsonKey(name: 'resultado_aprobado_local')
    final bool resultadoAprobadoLocal,
    @JsonKey(name: 'resultado_aprobado_visitante')
    final bool resultadoAprobadoVisitante,
  }) = _$TournamentMatchModelImpl;

  factory _TournamentMatchModel.fromJson(Map<String, dynamic> json) =
      _$TournamentMatchModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'torneo_id')
  int get torneoId;
  @override
  @JsonKey(name: 'equipo_local_id')
  int get equipoLocalId;
  @override
  @JsonKey(name: 'rival_nombre')
  String get rivalNombre;
  @override
  String? get fecha;
  @override
  String? get lugar;
  @override
  @JsonKey(name: 'es_local')
  bool get esLocal;
  @override
  @JsonKey(name: 'goles_local')
  int? get golesLocal;
  @override
  @JsonKey(name: 'goles_visitante')
  int? get golesVisitante;
  @override
  String? get estado; // programado, en_curso, finalizado, cancelado, pospuesto
  @override
  @JsonKey(name: 'resultado_aprobado_local')
  bool get resultadoAprobadoLocal;
  @override
  @JsonKey(name: 'resultado_aprobado_visitante')
  bool get resultadoAprobadoVisitante;

  /// Create a copy of TournamentMatchModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TournamentMatchModelImplCopyWith<_$TournamentMatchModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
