// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sub_member_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SubMemberModel _$SubMemberModelFromJson(Map<String, dynamic> json) {
  return _SubMemberModel.fromJson(json);
}

/// @nodoc
mixin _$SubMemberModel {
  String get id => throw _privateConstructorUsedError;
  String get fullname => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String? get lastName => throw _privateConstructorUsedError;
  String get membershipNumber => throw _privateConstructorUsedError;
  String get memberType => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_date')
  String? get birthDate => throw _privateConstructorUsedError;
  int? get age => throw _privateConstructorUsedError;
  String? get genero => throw _privateConstructorUsedError;

  /// Serializes this SubMemberModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubMemberModelCopyWith<SubMemberModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubMemberModelCopyWith<$Res> {
  factory $SubMemberModelCopyWith(
    SubMemberModel value,
    $Res Function(SubMemberModel) then,
  ) = _$SubMemberModelCopyWithImpl<$Res, SubMemberModel>;
  @useResult
  $Res call({
    String id,
    String fullname,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    String membershipNumber,
    String memberType,
    @JsonKey(name: 'birth_date') String? birthDate,
    int? age,
    String? genero,
  });
}

/// @nodoc
class _$SubMemberModelCopyWithImpl<$Res, $Val extends SubMemberModel>
    implements $SubMemberModelCopyWith<$Res> {
  _$SubMemberModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullname = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? membershipNumber = null,
    Object? memberType = null,
    Object? birthDate = freezed,
    Object? age = freezed,
    Object? genero = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            fullname: null == fullname
                ? _value.fullname
                : fullname // ignore: cast_nullable_to_non_nullable
                      as String,
            firstName: freezed == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastName: freezed == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String?,
            membershipNumber: null == membershipNumber
                ? _value.membershipNumber
                : membershipNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            memberType: null == memberType
                ? _value.memberType
                : memberType // ignore: cast_nullable_to_non_nullable
                      as String,
            birthDate: freezed == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            age: freezed == age
                ? _value.age
                : age // ignore: cast_nullable_to_non_nullable
                      as int?,
            genero: freezed == genero
                ? _value.genero
                : genero // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SubMemberModelImplCopyWith<$Res>
    implements $SubMemberModelCopyWith<$Res> {
  factory _$$SubMemberModelImplCopyWith(
    _$SubMemberModelImpl value,
    $Res Function(_$SubMemberModelImpl) then,
  ) = __$$SubMemberModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String fullname,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    String membershipNumber,
    String memberType,
    @JsonKey(name: 'birth_date') String? birthDate,
    int? age,
    String? genero,
  });
}

/// @nodoc
class __$$SubMemberModelImplCopyWithImpl<$Res>
    extends _$SubMemberModelCopyWithImpl<$Res, _$SubMemberModelImpl>
    implements _$$SubMemberModelImplCopyWith<$Res> {
  __$$SubMemberModelImplCopyWithImpl(
    _$SubMemberModelImpl _value,
    $Res Function(_$SubMemberModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullname = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? membershipNumber = null,
    Object? memberType = null,
    Object? birthDate = freezed,
    Object? age = freezed,
    Object? genero = freezed,
  }) {
    return _then(
      _$SubMemberModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fullname: null == fullname
            ? _value.fullname
            : fullname // ignore: cast_nullable_to_non_nullable
                  as String,
        firstName: freezed == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastName: freezed == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String?,
        membershipNumber: null == membershipNumber
            ? _value.membershipNumber
            : membershipNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        memberType: null == memberType
            ? _value.memberType
            : memberType // ignore: cast_nullable_to_non_nullable
                  as String,
        birthDate: freezed == birthDate
            ? _value.birthDate
            : birthDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        age: freezed == age
            ? _value.age
            : age // ignore: cast_nullable_to_non_nullable
                  as int?,
        genero: freezed == genero
            ? _value.genero
            : genero // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SubMemberModelImpl implements _SubMemberModel {
  const _$SubMemberModelImpl({
    required this.id,
    required this.fullname,
    @JsonKey(name: 'first_name') this.firstName,
    @JsonKey(name: 'last_name') this.lastName,
    required this.membershipNumber,
    required this.memberType,
    @JsonKey(name: 'birth_date') this.birthDate,
    this.age,
    this.genero,
  });

  factory _$SubMemberModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubMemberModelImplFromJson(json);

  @override
  final String id;
  @override
  final String fullname;
  @override
  @JsonKey(name: 'first_name')
  final String? firstName;
  @override
  @JsonKey(name: 'last_name')
  final String? lastName;
  @override
  final String membershipNumber;
  @override
  final String memberType;
  @override
  @JsonKey(name: 'birth_date')
  final String? birthDate;
  @override
  final int? age;
  @override
  final String? genero;

  @override
  String toString() {
    return 'SubMemberModel(id: $id, fullname: $fullname, firstName: $firstName, lastName: $lastName, membershipNumber: $membershipNumber, memberType: $memberType, birthDate: $birthDate, age: $age, genero: $genero)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubMemberModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullname, fullname) ||
                other.fullname == fullname) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.membershipNumber, membershipNumber) ||
                other.membershipNumber == membershipNumber) &&
            (identical(other.memberType, memberType) ||
                other.memberType == memberType) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.genero, genero) || other.genero == genero));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    fullname,
    firstName,
    lastName,
    membershipNumber,
    memberType,
    birthDate,
    age,
    genero,
  );

  /// Create a copy of SubMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubMemberModelImplCopyWith<_$SubMemberModelImpl> get copyWith =>
      __$$SubMemberModelImplCopyWithImpl<_$SubMemberModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SubMemberModelImplToJson(this);
  }
}

abstract class _SubMemberModel implements SubMemberModel {
  const factory _SubMemberModel({
    required final String id,
    required final String fullname,
    @JsonKey(name: 'first_name') final String? firstName,
    @JsonKey(name: 'last_name') final String? lastName,
    required final String membershipNumber,
    required final String memberType,
    @JsonKey(name: 'birth_date') final String? birthDate,
    final int? age,
    final String? genero,
  }) = _$SubMemberModelImpl;

  factory _SubMemberModel.fromJson(Map<String, dynamic> json) =
      _$SubMemberModelImpl.fromJson;

  @override
  String get id;
  @override
  String get fullname;
  @override
  @JsonKey(name: 'first_name')
  String? get firstName;
  @override
  @JsonKey(name: 'last_name')
  String? get lastName;
  @override
  String get membershipNumber;
  @override
  String get memberType;
  @override
  @JsonKey(name: 'birth_date')
  String? get birthDate;
  @override
  int? get age;
  @override
  String? get genero;

  /// Create a copy of SubMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubMemberModelImplCopyWith<_$SubMemberModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
