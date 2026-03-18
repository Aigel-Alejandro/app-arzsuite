// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Guest _$GuestFromJson(Map<String, dynamic> json) {
  return _Guest.fromJson(json);
}

/// @nodoc
mixin _$Guest {
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get secondLastName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get relationship =>
      throw _privateConstructorUsedError; // Hijo(a), Sobrino(a), etc.
  String get titularMembershipNumber => throw _privateConstructorUsedError;

  /// Serializes this Guest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Guest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GuestCopyWith<Guest> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuestCopyWith<$Res> {
  factory $GuestCopyWith(Guest value, $Res Function(Guest) then) =
      _$GuestCopyWithImpl<$Res, Guest>;
  @useResult
  $Res call({
    String firstName,
    String lastName,
    String? secondLastName,
    String email,
    String phone,
    String relationship,
    String titularMembershipNumber,
  });
}

/// @nodoc
class _$GuestCopyWithImpl<$Res, $Val extends Guest>
    implements $GuestCopyWith<$Res> {
  _$GuestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Guest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? secondLastName = freezed,
    Object? email = null,
    Object? phone = null,
    Object? relationship = null,
    Object? titularMembershipNumber = null,
  }) {
    return _then(
      _value.copyWith(
            firstName: null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String,
            lastName: null == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String,
            secondLastName: freezed == secondLastName
                ? _value.secondLastName
                : secondLastName // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            relationship: null == relationship
                ? _value.relationship
                : relationship // ignore: cast_nullable_to_non_nullable
                      as String,
            titularMembershipNumber: null == titularMembershipNumber
                ? _value.titularMembershipNumber
                : titularMembershipNumber // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GuestImplCopyWith<$Res> implements $GuestCopyWith<$Res> {
  factory _$$GuestImplCopyWith(
    _$GuestImpl value,
    $Res Function(_$GuestImpl) then,
  ) = __$$GuestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String firstName,
    String lastName,
    String? secondLastName,
    String email,
    String phone,
    String relationship,
    String titularMembershipNumber,
  });
}

/// @nodoc
class __$$GuestImplCopyWithImpl<$Res>
    extends _$GuestCopyWithImpl<$Res, _$GuestImpl>
    implements _$$GuestImplCopyWith<$Res> {
  __$$GuestImplCopyWithImpl(
    _$GuestImpl _value,
    $Res Function(_$GuestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Guest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? secondLastName = freezed,
    Object? email = null,
    Object? phone = null,
    Object? relationship = null,
    Object? titularMembershipNumber = null,
  }) {
    return _then(
      _$GuestImpl(
        firstName: null == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String,
        lastName: null == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String,
        secondLastName: freezed == secondLastName
            ? _value.secondLastName
            : secondLastName // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        relationship: null == relationship
            ? _value.relationship
            : relationship // ignore: cast_nullable_to_non_nullable
                  as String,
        titularMembershipNumber: null == titularMembershipNumber
            ? _value.titularMembershipNumber
            : titularMembershipNumber // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GuestImpl extends _Guest {
  const _$GuestImpl({
    required this.firstName,
    required this.lastName,
    required this.secondLastName,
    required this.email,
    required this.phone,
    required this.relationship,
    required this.titularMembershipNumber,
  }) : super._();

  factory _$GuestImpl.fromJson(Map<String, dynamic> json) =>
      _$$GuestImplFromJson(json);

  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? secondLastName;
  @override
  final String email;
  @override
  final String phone;
  @override
  final String relationship;
  // Hijo(a), Sobrino(a), etc.
  @override
  final String titularMembershipNumber;

  @override
  String toString() {
    return 'Guest(firstName: $firstName, lastName: $lastName, secondLastName: $secondLastName, email: $email, phone: $phone, relationship: $relationship, titularMembershipNumber: $titularMembershipNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GuestImpl &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.secondLastName, secondLastName) ||
                other.secondLastName == secondLastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.relationship, relationship) ||
                other.relationship == relationship) &&
            (identical(
                  other.titularMembershipNumber,
                  titularMembershipNumber,
                ) ||
                other.titularMembershipNumber == titularMembershipNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    firstName,
    lastName,
    secondLastName,
    email,
    phone,
    relationship,
    titularMembershipNumber,
  );

  /// Create a copy of Guest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GuestImplCopyWith<_$GuestImpl> get copyWith =>
      __$$GuestImplCopyWithImpl<_$GuestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GuestImplToJson(this);
  }
}

abstract class _Guest extends Guest {
  const factory _Guest({
    required final String firstName,
    required final String lastName,
    required final String? secondLastName,
    required final String email,
    required final String phone,
    required final String relationship,
    required final String titularMembershipNumber,
  }) = _$GuestImpl;
  const _Guest._() : super._();

  factory _Guest.fromJson(Map<String, dynamic> json) = _$GuestImpl.fromJson;

  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get secondLastName;
  @override
  String get email;
  @override
  String get phone;
  @override
  String get relationship; // Hijo(a), Sobrino(a), etc.
  @override
  String get titularMembershipNumber;

  /// Create a copy of Guest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GuestImplCopyWith<_$GuestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
