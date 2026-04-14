// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) {
  return _ActivityModel.fromJson(json);
}

/// @nodoc
mixin _$ActivityModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'club_id')
  int get clubId => throw _privateConstructorUsedError;
  @JsonKey(name: 'club_name')
  String? get clubName => throw _privateConstructorUsedError;
  @JsonKey(name: 'acceso_clubes')
  List<String>? get accesoClubes => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  String? get descripcion => throw _privateConstructorUsedError;
  String? get icono => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String? get tipo => throw _privateConstructorUsedError;
  @JsonKey(name: 'tiene_costo')
  bool get tieneCosto => throw _privateConstructorUsedError;
  double? get monto => throw _privateConstructorUsedError;
  List<ActivityGroupModel> get grupos => throw _privateConstructorUsedError;

  /// Serializes this ActivityModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityModelCopyWith<ActivityModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityModelCopyWith<$Res> {
  factory $ActivityModelCopyWith(
    ActivityModel value,
    $Res Function(ActivityModel) then,
  ) = _$ActivityModelCopyWithImpl<$Res, ActivityModel>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'club_id') int clubId,
    @JsonKey(name: 'club_name') String? clubName,
    @JsonKey(name: 'acceso_clubes') List<String>? accesoClubes,
    String nombre,
    String? descripcion,
    String? icono,
    String? color,
    String? tipo,
    @JsonKey(name: 'tiene_costo') bool tieneCosto,
    double? monto,
    List<ActivityGroupModel> grupos,
  });
}

/// @nodoc
class _$ActivityModelCopyWithImpl<$Res, $Val extends ActivityModel>
    implements $ActivityModelCopyWith<$Res> {
  _$ActivityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? clubName = freezed,
    Object? accesoClubes = freezed,
    Object? nombre = null,
    Object? descripcion = freezed,
    Object? icono = freezed,
    Object? color = freezed,
    Object? tipo = freezed,
    Object? tieneCosto = null,
    Object? monto = freezed,
    Object? grupos = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            clubId: null == clubId
                ? _value.clubId
                : clubId // ignore: cast_nullable_to_non_nullable
                      as int,
            clubName: freezed == clubName
                ? _value.clubName
                : clubName // ignore: cast_nullable_to_non_nullable
                      as String?,
            accesoClubes: freezed == accesoClubes
                ? _value.accesoClubes
                : accesoClubes // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            nombre: null == nombre
                ? _value.nombre
                : nombre // ignore: cast_nullable_to_non_nullable
                      as String,
            descripcion: freezed == descripcion
                ? _value.descripcion
                : descripcion // ignore: cast_nullable_to_non_nullable
                      as String?,
            icono: freezed == icono
                ? _value.icono
                : icono // ignore: cast_nullable_to_non_nullable
                      as String?,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
            tipo: freezed == tipo
                ? _value.tipo
                : tipo // ignore: cast_nullable_to_non_nullable
                      as String?,
            tieneCosto: null == tieneCosto
                ? _value.tieneCosto
                : tieneCosto // ignore: cast_nullable_to_non_nullable
                      as bool,
            monto: freezed == monto
                ? _value.monto
                : monto // ignore: cast_nullable_to_non_nullable
                      as double?,
            grupos: null == grupos
                ? _value.grupos
                : grupos // ignore: cast_nullable_to_non_nullable
                      as List<ActivityGroupModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityModelImplCopyWith<$Res>
    implements $ActivityModelCopyWith<$Res> {
  factory _$$ActivityModelImplCopyWith(
    _$ActivityModelImpl value,
    $Res Function(_$ActivityModelImpl) then,
  ) = __$$ActivityModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'club_id') int clubId,
    @JsonKey(name: 'club_name') String? clubName,
    @JsonKey(name: 'acceso_clubes') List<String>? accesoClubes,
    String nombre,
    String? descripcion,
    String? icono,
    String? color,
    String? tipo,
    @JsonKey(name: 'tiene_costo') bool tieneCosto,
    double? monto,
    List<ActivityGroupModel> grupos,
  });
}

/// @nodoc
class __$$ActivityModelImplCopyWithImpl<$Res>
    extends _$ActivityModelCopyWithImpl<$Res, _$ActivityModelImpl>
    implements _$$ActivityModelImplCopyWith<$Res> {
  __$$ActivityModelImplCopyWithImpl(
    _$ActivityModelImpl _value,
    $Res Function(_$ActivityModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? clubName = freezed,
    Object? accesoClubes = freezed,
    Object? nombre = null,
    Object? descripcion = freezed,
    Object? icono = freezed,
    Object? color = freezed,
    Object? tipo = freezed,
    Object? tieneCosto = null,
    Object? monto = freezed,
    Object? grupos = null,
  }) {
    return _then(
      _$ActivityModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        clubId: null == clubId
            ? _value.clubId
            : clubId // ignore: cast_nullable_to_non_nullable
                  as int,
        clubName: freezed == clubName
            ? _value.clubName
            : clubName // ignore: cast_nullable_to_non_nullable
                  as String?,
        accesoClubes: freezed == accesoClubes
            ? _value._accesoClubes
            : accesoClubes // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        nombre: null == nombre
            ? _value.nombre
            : nombre // ignore: cast_nullable_to_non_nullable
                  as String,
        descripcion: freezed == descripcion
            ? _value.descripcion
            : descripcion // ignore: cast_nullable_to_non_nullable
                  as String?,
        icono: freezed == icono
            ? _value.icono
            : icono // ignore: cast_nullable_to_non_nullable
                  as String?,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
        tipo: freezed == tipo
            ? _value.tipo
            : tipo // ignore: cast_nullable_to_non_nullable
                  as String?,
        tieneCosto: null == tieneCosto
            ? _value.tieneCosto
            : tieneCosto // ignore: cast_nullable_to_non_nullable
                  as bool,
        monto: freezed == monto
            ? _value.monto
            : monto // ignore: cast_nullable_to_non_nullable
                  as double?,
        grupos: null == grupos
            ? _value._grupos
            : grupos // ignore: cast_nullable_to_non_nullable
                  as List<ActivityGroupModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityModelImpl implements _ActivityModel {
  const _$ActivityModelImpl({
    required this.id,
    @JsonKey(name: 'club_id') required this.clubId,
    @JsonKey(name: 'club_name') this.clubName,
    @JsonKey(name: 'acceso_clubes') final List<String>? accesoClubes,
    required this.nombre,
    this.descripcion,
    this.icono,
    this.color,
    this.tipo,
    @JsonKey(name: 'tiene_costo') required this.tieneCosto,
    this.monto,
    final List<ActivityGroupModel> grupos = const [],
  }) : _accesoClubes = accesoClubes,
       _grupos = grupos;

  factory _$ActivityModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'club_id')
  final int clubId;
  @override
  @JsonKey(name: 'club_name')
  final String? clubName;
  final List<String>? _accesoClubes;
  @override
  @JsonKey(name: 'acceso_clubes')
  List<String>? get accesoClubes {
    final value = _accesoClubes;
    if (value == null) return null;
    if (_accesoClubes is EqualUnmodifiableListView) return _accesoClubes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String nombre;
  @override
  final String? descripcion;
  @override
  final String? icono;
  @override
  final String? color;
  @override
  final String? tipo;
  @override
  @JsonKey(name: 'tiene_costo')
  final bool tieneCosto;
  @override
  final double? monto;
  final List<ActivityGroupModel> _grupos;
  @override
  @JsonKey()
  List<ActivityGroupModel> get grupos {
    if (_grupos is EqualUnmodifiableListView) return _grupos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_grupos);
  }

  @override
  String toString() {
    return 'ActivityModel(id: $id, clubId: $clubId, clubName: $clubName, accesoClubes: $accesoClubes, nombre: $nombre, descripcion: $descripcion, icono: $icono, color: $color, tipo: $tipo, tieneCosto: $tieneCosto, monto: $monto, grupos: $grupos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.clubName, clubName) ||
                other.clubName == clubName) &&
            const DeepCollectionEquality().equals(
              other._accesoClubes,
              _accesoClubes,
            ) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.descripcion, descripcion) ||
                other.descripcion == descripcion) &&
            (identical(other.icono, icono) || other.icono == icono) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.tieneCosto, tieneCosto) ||
                other.tieneCosto == tieneCosto) &&
            (identical(other.monto, monto) || other.monto == monto) &&
            const DeepCollectionEquality().equals(other._grupos, _grupos));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    clubId,
    clubName,
    const DeepCollectionEquality().hash(_accesoClubes),
    nombre,
    descripcion,
    icono,
    color,
    tipo,
    tieneCosto,
    monto,
    const DeepCollectionEquality().hash(_grupos),
  );

  /// Create a copy of ActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityModelImplCopyWith<_$ActivityModelImpl> get copyWith =>
      __$$ActivityModelImplCopyWithImpl<_$ActivityModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityModelImplToJson(this);
  }
}

abstract class _ActivityModel implements ActivityModel {
  const factory _ActivityModel({
    required final int id,
    @JsonKey(name: 'club_id') required final int clubId,
    @JsonKey(name: 'club_name') final String? clubName,
    @JsonKey(name: 'acceso_clubes') final List<String>? accesoClubes,
    required final String nombre,
    final String? descripcion,
    final String? icono,
    final String? color,
    final String? tipo,
    @JsonKey(name: 'tiene_costo') required final bool tieneCosto,
    final double? monto,
    final List<ActivityGroupModel> grupos,
  }) = _$ActivityModelImpl;

  factory _ActivityModel.fromJson(Map<String, dynamic> json) =
      _$ActivityModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'club_id')
  int get clubId;
  @override
  @JsonKey(name: 'club_name')
  String? get clubName;
  @override
  @JsonKey(name: 'acceso_clubes')
  List<String>? get accesoClubes;
  @override
  String get nombre;
  @override
  String? get descripcion;
  @override
  String? get icono;
  @override
  String? get color;
  @override
  String? get tipo;
  @override
  @JsonKey(name: 'tiene_costo')
  bool get tieneCosto;
  @override
  double? get monto;
  @override
  List<ActivityGroupModel> get grupos;

  /// Create a copy of ActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityModelImplCopyWith<_$ActivityModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityGroupModel _$ActivityGroupModelFromJson(Map<String, dynamic> json) {
  return _ActivityGroupModel.fromJson(json);
}

/// @nodoc
mixin _$ActivityGroupModel {
  int get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  String? get descripcion => throw _privateConstructorUsedError;
  @JsonKey(name: 'edad_min')
  int? get edadMin => throw _privateConstructorUsedError;
  @JsonKey(name: 'edad_max')
  int? get edadMax => throw _privateConstructorUsedError;
  @JsonKey(name: 'cupo_disponible')
  int? get cupoDisponible => throw _privateConstructorUsedError;
  @JsonKey(name: 'tiene_cupo')
  bool get tieneCupo => throw _privateConstructorUsedError;
  List<ActivityTeamModel> get equipos => throw _privateConstructorUsedError;

  /// Serializes this ActivityGroupModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityGroupModelCopyWith<ActivityGroupModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityGroupModelCopyWith<$Res> {
  factory $ActivityGroupModelCopyWith(
    ActivityGroupModel value,
    $Res Function(ActivityGroupModel) then,
  ) = _$ActivityGroupModelCopyWithImpl<$Res, ActivityGroupModel>;
  @useResult
  $Res call({
    int id,
    String nombre,
    String? descripcion,
    @JsonKey(name: 'edad_min') int? edadMin,
    @JsonKey(name: 'edad_max') int? edadMax,
    @JsonKey(name: 'cupo_disponible') int? cupoDisponible,
    @JsonKey(name: 'tiene_cupo') bool tieneCupo,
    List<ActivityTeamModel> equipos,
  });
}

/// @nodoc
class _$ActivityGroupModelCopyWithImpl<$Res, $Val extends ActivityGroupModel>
    implements $ActivityGroupModelCopyWith<$Res> {
  _$ActivityGroupModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? descripcion = freezed,
    Object? edadMin = freezed,
    Object? edadMax = freezed,
    Object? cupoDisponible = freezed,
    Object? tieneCupo = null,
    Object? equipos = null,
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
            descripcion: freezed == descripcion
                ? _value.descripcion
                : descripcion // ignore: cast_nullable_to_non_nullable
                      as String?,
            edadMin: freezed == edadMin
                ? _value.edadMin
                : edadMin // ignore: cast_nullable_to_non_nullable
                      as int?,
            edadMax: freezed == edadMax
                ? _value.edadMax
                : edadMax // ignore: cast_nullable_to_non_nullable
                      as int?,
            cupoDisponible: freezed == cupoDisponible
                ? _value.cupoDisponible
                : cupoDisponible // ignore: cast_nullable_to_non_nullable
                      as int?,
            tieneCupo: null == tieneCupo
                ? _value.tieneCupo
                : tieneCupo // ignore: cast_nullable_to_non_nullable
                      as bool,
            equipos: null == equipos
                ? _value.equipos
                : equipos // ignore: cast_nullable_to_non_nullable
                      as List<ActivityTeamModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityGroupModelImplCopyWith<$Res>
    implements $ActivityGroupModelCopyWith<$Res> {
  factory _$$ActivityGroupModelImplCopyWith(
    _$ActivityGroupModelImpl value,
    $Res Function(_$ActivityGroupModelImpl) then,
  ) = __$$ActivityGroupModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String nombre,
    String? descripcion,
    @JsonKey(name: 'edad_min') int? edadMin,
    @JsonKey(name: 'edad_max') int? edadMax,
    @JsonKey(name: 'cupo_disponible') int? cupoDisponible,
    @JsonKey(name: 'tiene_cupo') bool tieneCupo,
    List<ActivityTeamModel> equipos,
  });
}

/// @nodoc
class __$$ActivityGroupModelImplCopyWithImpl<$Res>
    extends _$ActivityGroupModelCopyWithImpl<$Res, _$ActivityGroupModelImpl>
    implements _$$ActivityGroupModelImplCopyWith<$Res> {
  __$$ActivityGroupModelImplCopyWithImpl(
    _$ActivityGroupModelImpl _value,
    $Res Function(_$ActivityGroupModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? descripcion = freezed,
    Object? edadMin = freezed,
    Object? edadMax = freezed,
    Object? cupoDisponible = freezed,
    Object? tieneCupo = null,
    Object? equipos = null,
  }) {
    return _then(
      _$ActivityGroupModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        nombre: null == nombre
            ? _value.nombre
            : nombre // ignore: cast_nullable_to_non_nullable
                  as String,
        descripcion: freezed == descripcion
            ? _value.descripcion
            : descripcion // ignore: cast_nullable_to_non_nullable
                  as String?,
        edadMin: freezed == edadMin
            ? _value.edadMin
            : edadMin // ignore: cast_nullable_to_non_nullable
                  as int?,
        edadMax: freezed == edadMax
            ? _value.edadMax
            : edadMax // ignore: cast_nullable_to_non_nullable
                  as int?,
        cupoDisponible: freezed == cupoDisponible
            ? _value.cupoDisponible
            : cupoDisponible // ignore: cast_nullable_to_non_nullable
                  as int?,
        tieneCupo: null == tieneCupo
            ? _value.tieneCupo
            : tieneCupo // ignore: cast_nullable_to_non_nullable
                  as bool,
        equipos: null == equipos
            ? _value._equipos
            : equipos // ignore: cast_nullable_to_non_nullable
                  as List<ActivityTeamModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityGroupModelImpl implements _ActivityGroupModel {
  const _$ActivityGroupModelImpl({
    required this.id,
    required this.nombre,
    this.descripcion,
    @JsonKey(name: 'edad_min') this.edadMin,
    @JsonKey(name: 'edad_max') this.edadMax,
    @JsonKey(name: 'cupo_disponible') this.cupoDisponible,
    @JsonKey(name: 'tiene_cupo') required this.tieneCupo,
    final List<ActivityTeamModel> equipos = const [],
  }) : _equipos = equipos;

  factory _$ActivityGroupModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityGroupModelImplFromJson(json);

  @override
  final int id;
  @override
  final String nombre;
  @override
  final String? descripcion;
  @override
  @JsonKey(name: 'edad_min')
  final int? edadMin;
  @override
  @JsonKey(name: 'edad_max')
  final int? edadMax;
  @override
  @JsonKey(name: 'cupo_disponible')
  final int? cupoDisponible;
  @override
  @JsonKey(name: 'tiene_cupo')
  final bool tieneCupo;
  final List<ActivityTeamModel> _equipos;
  @override
  @JsonKey()
  List<ActivityTeamModel> get equipos {
    if (_equipos is EqualUnmodifiableListView) return _equipos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_equipos);
  }

  @override
  String toString() {
    return 'ActivityGroupModel(id: $id, nombre: $nombre, descripcion: $descripcion, edadMin: $edadMin, edadMax: $edadMax, cupoDisponible: $cupoDisponible, tieneCupo: $tieneCupo, equipos: $equipos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityGroupModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.descripcion, descripcion) ||
                other.descripcion == descripcion) &&
            (identical(other.edadMin, edadMin) || other.edadMin == edadMin) &&
            (identical(other.edadMax, edadMax) || other.edadMax == edadMax) &&
            (identical(other.cupoDisponible, cupoDisponible) ||
                other.cupoDisponible == cupoDisponible) &&
            (identical(other.tieneCupo, tieneCupo) ||
                other.tieneCupo == tieneCupo) &&
            const DeepCollectionEquality().equals(other._equipos, _equipos));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    nombre,
    descripcion,
    edadMin,
    edadMax,
    cupoDisponible,
    tieneCupo,
    const DeepCollectionEquality().hash(_equipos),
  );

  /// Create a copy of ActivityGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityGroupModelImplCopyWith<_$ActivityGroupModelImpl> get copyWith =>
      __$$ActivityGroupModelImplCopyWithImpl<_$ActivityGroupModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityGroupModelImplToJson(this);
  }
}

abstract class _ActivityGroupModel implements ActivityGroupModel {
  const factory _ActivityGroupModel({
    required final int id,
    required final String nombre,
    final String? descripcion,
    @JsonKey(name: 'edad_min') final int? edadMin,
    @JsonKey(name: 'edad_max') final int? edadMax,
    @JsonKey(name: 'cupo_disponible') final int? cupoDisponible,
    @JsonKey(name: 'tiene_cupo') required final bool tieneCupo,
    final List<ActivityTeamModel> equipos,
  }) = _$ActivityGroupModelImpl;

  factory _ActivityGroupModel.fromJson(Map<String, dynamic> json) =
      _$ActivityGroupModelImpl.fromJson;

  @override
  int get id;
  @override
  String get nombre;
  @override
  String? get descripcion;
  @override
  @JsonKey(name: 'edad_min')
  int? get edadMin;
  @override
  @JsonKey(name: 'edad_max')
  int? get edadMax;
  @override
  @JsonKey(name: 'cupo_disponible')
  int? get cupoDisponible;
  @override
  @JsonKey(name: 'tiene_cupo')
  bool get tieneCupo;
  @override
  List<ActivityTeamModel> get equipos;

  /// Create a copy of ActivityGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityGroupModelImplCopyWith<_$ActivityGroupModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityTeamModel _$ActivityTeamModelFromJson(Map<String, dynamic> json) {
  return _ActivityTeamModel.fromJson(json);
}

/// @nodoc
mixin _$ActivityTeamModel {
  int get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  List<ActivityScheduleModel> get horarios =>
      throw _privateConstructorUsedError;

  /// Serializes this ActivityTeamModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityTeamModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityTeamModelCopyWith<ActivityTeamModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityTeamModelCopyWith<$Res> {
  factory $ActivityTeamModelCopyWith(
    ActivityTeamModel value,
    $Res Function(ActivityTeamModel) then,
  ) = _$ActivityTeamModelCopyWithImpl<$Res, ActivityTeamModel>;
  @useResult
  $Res call({
    int id,
    String nombre,
    String? color,
    List<ActivityScheduleModel> horarios,
  });
}

/// @nodoc
class _$ActivityTeamModelCopyWithImpl<$Res, $Val extends ActivityTeamModel>
    implements $ActivityTeamModelCopyWith<$Res> {
  _$ActivityTeamModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityTeamModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? color = freezed,
    Object? horarios = null,
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
            horarios: null == horarios
                ? _value.horarios
                : horarios // ignore: cast_nullable_to_non_nullable
                      as List<ActivityScheduleModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityTeamModelImplCopyWith<$Res>
    implements $ActivityTeamModelCopyWith<$Res> {
  factory _$$ActivityTeamModelImplCopyWith(
    _$ActivityTeamModelImpl value,
    $Res Function(_$ActivityTeamModelImpl) then,
  ) = __$$ActivityTeamModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String nombre,
    String? color,
    List<ActivityScheduleModel> horarios,
  });
}

/// @nodoc
class __$$ActivityTeamModelImplCopyWithImpl<$Res>
    extends _$ActivityTeamModelCopyWithImpl<$Res, _$ActivityTeamModelImpl>
    implements _$$ActivityTeamModelImplCopyWith<$Res> {
  __$$ActivityTeamModelImplCopyWithImpl(
    _$ActivityTeamModelImpl _value,
    $Res Function(_$ActivityTeamModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityTeamModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? color = freezed,
    Object? horarios = null,
  }) {
    return _then(
      _$ActivityTeamModelImpl(
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
        horarios: null == horarios
            ? _value._horarios
            : horarios // ignore: cast_nullable_to_non_nullable
                  as List<ActivityScheduleModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityTeamModelImpl implements _ActivityTeamModel {
  const _$ActivityTeamModelImpl({
    required this.id,
    required this.nombre,
    this.color,
    final List<ActivityScheduleModel> horarios = const [],
  }) : _horarios = horarios;

  factory _$ActivityTeamModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityTeamModelImplFromJson(json);

  @override
  final int id;
  @override
  final String nombre;
  @override
  final String? color;
  final List<ActivityScheduleModel> _horarios;
  @override
  @JsonKey()
  List<ActivityScheduleModel> get horarios {
    if (_horarios is EqualUnmodifiableListView) return _horarios;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_horarios);
  }

  @override
  String toString() {
    return 'ActivityTeamModel(id: $id, nombre: $nombre, color: $color, horarios: $horarios)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityTeamModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.color, color) || other.color == color) &&
            const DeepCollectionEquality().equals(other._horarios, _horarios));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    nombre,
    color,
    const DeepCollectionEquality().hash(_horarios),
  );

  /// Create a copy of ActivityTeamModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityTeamModelImplCopyWith<_$ActivityTeamModelImpl> get copyWith =>
      __$$ActivityTeamModelImplCopyWithImpl<_$ActivityTeamModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityTeamModelImplToJson(this);
  }
}

abstract class _ActivityTeamModel implements ActivityTeamModel {
  const factory _ActivityTeamModel({
    required final int id,
    required final String nombre,
    final String? color,
    final List<ActivityScheduleModel> horarios,
  }) = _$ActivityTeamModelImpl;

  factory _ActivityTeamModel.fromJson(Map<String, dynamic> json) =
      _$ActivityTeamModelImpl.fromJson;

  @override
  int get id;
  @override
  String get nombre;
  @override
  String? get color;
  @override
  List<ActivityScheduleModel> get horarios;

  /// Create a copy of ActivityTeamModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityTeamModelImplCopyWith<_$ActivityTeamModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityScheduleModel _$ActivityScheduleModelFromJson(
  Map<String, dynamic> json,
) {
  return _ActivityScheduleModel.fromJson(json);
}

/// @nodoc
mixin _$ActivityScheduleModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'dia_semana')
  int get diaSemana => throw _privateConstructorUsedError;
  @JsonKey(name: 'hora_inicio')
  String get horaInicio => throw _privateConstructorUsedError;
  @JsonKey(name: 'hora_fin')
  String get horaFin => throw _privateConstructorUsedError;
  String? get lugar => throw _privateConstructorUsedError;
  @JsonKey(name: 'cupo_disponible')
  int? get cupoDisponible => throw _privateConstructorUsedError;
  @JsonKey(name: 'tiene_cupo')
  bool get tieneCupo => throw _privateConstructorUsedError;

  /// Serializes this ActivityScheduleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityScheduleModelCopyWith<ActivityScheduleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityScheduleModelCopyWith<$Res> {
  factory $ActivityScheduleModelCopyWith(
    ActivityScheduleModel value,
    $Res Function(ActivityScheduleModel) then,
  ) = _$ActivityScheduleModelCopyWithImpl<$Res, ActivityScheduleModel>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'dia_semana') int diaSemana,
    @JsonKey(name: 'hora_inicio') String horaInicio,
    @JsonKey(name: 'hora_fin') String horaFin,
    String? lugar,
    @JsonKey(name: 'cupo_disponible') int? cupoDisponible,
    @JsonKey(name: 'tiene_cupo') bool tieneCupo,
  });
}

/// @nodoc
class _$ActivityScheduleModelCopyWithImpl<
  $Res,
  $Val extends ActivityScheduleModel
>
    implements $ActivityScheduleModelCopyWith<$Res> {
  _$ActivityScheduleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? diaSemana = null,
    Object? horaInicio = null,
    Object? horaFin = null,
    Object? lugar = freezed,
    Object? cupoDisponible = freezed,
    Object? tieneCupo = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            diaSemana: null == diaSemana
                ? _value.diaSemana
                : diaSemana // ignore: cast_nullable_to_non_nullable
                      as int,
            horaInicio: null == horaInicio
                ? _value.horaInicio
                : horaInicio // ignore: cast_nullable_to_non_nullable
                      as String,
            horaFin: null == horaFin
                ? _value.horaFin
                : horaFin // ignore: cast_nullable_to_non_nullable
                      as String,
            lugar: freezed == lugar
                ? _value.lugar
                : lugar // ignore: cast_nullable_to_non_nullable
                      as String?,
            cupoDisponible: freezed == cupoDisponible
                ? _value.cupoDisponible
                : cupoDisponible // ignore: cast_nullable_to_non_nullable
                      as int?,
            tieneCupo: null == tieneCupo
                ? _value.tieneCupo
                : tieneCupo // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityScheduleModelImplCopyWith<$Res>
    implements $ActivityScheduleModelCopyWith<$Res> {
  factory _$$ActivityScheduleModelImplCopyWith(
    _$ActivityScheduleModelImpl value,
    $Res Function(_$ActivityScheduleModelImpl) then,
  ) = __$$ActivityScheduleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'dia_semana') int diaSemana,
    @JsonKey(name: 'hora_inicio') String horaInicio,
    @JsonKey(name: 'hora_fin') String horaFin,
    String? lugar,
    @JsonKey(name: 'cupo_disponible') int? cupoDisponible,
    @JsonKey(name: 'tiene_cupo') bool tieneCupo,
  });
}

/// @nodoc
class __$$ActivityScheduleModelImplCopyWithImpl<$Res>
    extends
        _$ActivityScheduleModelCopyWithImpl<$Res, _$ActivityScheduleModelImpl>
    implements _$$ActivityScheduleModelImplCopyWith<$Res> {
  __$$ActivityScheduleModelImplCopyWithImpl(
    _$ActivityScheduleModelImpl _value,
    $Res Function(_$ActivityScheduleModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? diaSemana = null,
    Object? horaInicio = null,
    Object? horaFin = null,
    Object? lugar = freezed,
    Object? cupoDisponible = freezed,
    Object? tieneCupo = null,
  }) {
    return _then(
      _$ActivityScheduleModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        diaSemana: null == diaSemana
            ? _value.diaSemana
            : diaSemana // ignore: cast_nullable_to_non_nullable
                  as int,
        horaInicio: null == horaInicio
            ? _value.horaInicio
            : horaInicio // ignore: cast_nullable_to_non_nullable
                  as String,
        horaFin: null == horaFin
            ? _value.horaFin
            : horaFin // ignore: cast_nullable_to_non_nullable
                  as String,
        lugar: freezed == lugar
            ? _value.lugar
            : lugar // ignore: cast_nullable_to_non_nullable
                  as String?,
        cupoDisponible: freezed == cupoDisponible
            ? _value.cupoDisponible
            : cupoDisponible // ignore: cast_nullable_to_non_nullable
                  as int?,
        tieneCupo: null == tieneCupo
            ? _value.tieneCupo
            : tieneCupo // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityScheduleModelImpl implements _ActivityScheduleModel {
  const _$ActivityScheduleModelImpl({
    required this.id,
    @JsonKey(name: 'dia_semana') required this.diaSemana,
    @JsonKey(name: 'hora_inicio') required this.horaInicio,
    @JsonKey(name: 'hora_fin') required this.horaFin,
    this.lugar,
    @JsonKey(name: 'cupo_disponible') this.cupoDisponible,
    @JsonKey(name: 'tiene_cupo') this.tieneCupo = false,
  });

  factory _$ActivityScheduleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityScheduleModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'dia_semana')
  final int diaSemana;
  @override
  @JsonKey(name: 'hora_inicio')
  final String horaInicio;
  @override
  @JsonKey(name: 'hora_fin')
  final String horaFin;
  @override
  final String? lugar;
  @override
  @JsonKey(name: 'cupo_disponible')
  final int? cupoDisponible;
  @override
  @JsonKey(name: 'tiene_cupo')
  final bool tieneCupo;

  @override
  String toString() {
    return 'ActivityScheduleModel(id: $id, diaSemana: $diaSemana, horaInicio: $horaInicio, horaFin: $horaFin, lugar: $lugar, cupoDisponible: $cupoDisponible, tieneCupo: $tieneCupo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityScheduleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.diaSemana, diaSemana) ||
                other.diaSemana == diaSemana) &&
            (identical(other.horaInicio, horaInicio) ||
                other.horaInicio == horaInicio) &&
            (identical(other.horaFin, horaFin) || other.horaFin == horaFin) &&
            (identical(other.lugar, lugar) || other.lugar == lugar) &&
            (identical(other.cupoDisponible, cupoDisponible) ||
                other.cupoDisponible == cupoDisponible) &&
            (identical(other.tieneCupo, tieneCupo) ||
                other.tieneCupo == tieneCupo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    diaSemana,
    horaInicio,
    horaFin,
    lugar,
    cupoDisponible,
    tieneCupo,
  );

  /// Create a copy of ActivityScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityScheduleModelImplCopyWith<_$ActivityScheduleModelImpl>
  get copyWith =>
      __$$ActivityScheduleModelImplCopyWithImpl<_$ActivityScheduleModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityScheduleModelImplToJson(this);
  }
}

abstract class _ActivityScheduleModel implements ActivityScheduleModel {
  const factory _ActivityScheduleModel({
    required final int id,
    @JsonKey(name: 'dia_semana') required final int diaSemana,
    @JsonKey(name: 'hora_inicio') required final String horaInicio,
    @JsonKey(name: 'hora_fin') required final String horaFin,
    final String? lugar,
    @JsonKey(name: 'cupo_disponible') final int? cupoDisponible,
    @JsonKey(name: 'tiene_cupo') final bool tieneCupo,
  }) = _$ActivityScheduleModelImpl;

  factory _ActivityScheduleModel.fromJson(Map<String, dynamic> json) =
      _$ActivityScheduleModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'dia_semana')
  int get diaSemana;
  @override
  @JsonKey(name: 'hora_inicio')
  String get horaInicio;
  @override
  @JsonKey(name: 'hora_fin')
  String get horaFin;
  @override
  String? get lugar;
  @override
  @JsonKey(name: 'cupo_disponible')
  int? get cupoDisponible;
  @override
  @JsonKey(name: 'tiene_cupo')
  bool get tieneCupo;

  /// Create a copy of ActivityScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityScheduleModelImplCopyWith<_$ActivityScheduleModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
