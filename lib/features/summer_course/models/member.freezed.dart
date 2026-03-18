// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Member _$MemberFromJson(Map<String, dynamic> json) {
  return _Member.fromJson(json);
}

/// @nodoc
mixin _$Member {
  String get id =>
      throw _privateConstructorUsedError; // NetSuite ID or local ID
  String get membershipNumber =>
      throw _privateConstructorUsedError; // e.g. 2270600
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get secondLastName => throw _privateConstructorUsedError;
  String get memberType =>
      throw _privateConstructorUsedError; // '1' for Titular, others for Beneficiaries
  bool get isTitular => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;

  /// Serializes this Member to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Member
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberCopyWith<Member> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberCopyWith<$Res> {
  factory $MemberCopyWith(Member value, $Res Function(Member) then) =
      _$MemberCopyWithImpl<$Res, Member>;
  @useResult
  $Res call({
    String id,
    String membershipNumber,
    String firstName,
    String lastName,
    String? secondLastName,
    String memberType,
    bool isTitular,
    String? photoUrl,
    String? email,
    String? phone,
  });
}

/// @nodoc
class _$MemberCopyWithImpl<$Res, $Val extends Member>
    implements $MemberCopyWith<$Res> {
  _$MemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Member
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? membershipNumber = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? secondLastName = freezed,
    Object? memberType = null,
    Object? isTitular = null,
    Object? photoUrl = freezed,
    Object? email = freezed,
    Object? phone = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            membershipNumber: null == membershipNumber
                ? _value.membershipNumber
                : membershipNumber // ignore: cast_nullable_to_non_nullable
                      as String,
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
            memberType: null == memberType
                ? _value.memberType
                : memberType // ignore: cast_nullable_to_non_nullable
                      as String,
            isTitular: null == isTitular
                ? _value.isTitular
                : isTitular // ignore: cast_nullable_to_non_nullable
                      as bool,
            photoUrl: freezed == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MemberImplCopyWith<$Res> implements $MemberCopyWith<$Res> {
  factory _$$MemberImplCopyWith(
    _$MemberImpl value,
    $Res Function(_$MemberImpl) then,
  ) = __$$MemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String membershipNumber,
    String firstName,
    String lastName,
    String? secondLastName,
    String memberType,
    bool isTitular,
    String? photoUrl,
    String? email,
    String? phone,
  });
}

/// @nodoc
class __$$MemberImplCopyWithImpl<$Res>
    extends _$MemberCopyWithImpl<$Res, _$MemberImpl>
    implements _$$MemberImplCopyWith<$Res> {
  __$$MemberImplCopyWithImpl(
    _$MemberImpl _value,
    $Res Function(_$MemberImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Member
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? membershipNumber = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? secondLastName = freezed,
    Object? memberType = null,
    Object? isTitular = null,
    Object? photoUrl = freezed,
    Object? email = freezed,
    Object? phone = freezed,
  }) {
    return _then(
      _$MemberImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        membershipNumber: null == membershipNumber
            ? _value.membershipNumber
            : membershipNumber // ignore: cast_nullable_to_non_nullable
                  as String,
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
        memberType: null == memberType
            ? _value.memberType
            : memberType // ignore: cast_nullable_to_non_nullable
                  as String,
        isTitular: null == isTitular
            ? _value.isTitular
            : isTitular // ignore: cast_nullable_to_non_nullable
                  as bool,
        photoUrl: freezed == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberImpl extends _Member {
  const _$MemberImpl({
    required this.id,
    required this.membershipNumber,
    required this.firstName,
    required this.lastName,
    required this.secondLastName,
    required this.memberType,
    this.isTitular = false,
    this.photoUrl,
    this.email,
    this.phone,
  }) : super._();

  factory _$MemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberImplFromJson(json);

  @override
  final String id;
  // NetSuite ID or local ID
  @override
  final String membershipNumber;
  // e.g. 2270600
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? secondLastName;
  @override
  final String memberType;
  // '1' for Titular, others for Beneficiaries
  @override
  @JsonKey()
  final bool isTitular;
  @override
  final String? photoUrl;
  @override
  final String? email;
  @override
  final String? phone;

  @override
  String toString() {
    return 'Member(id: $id, membershipNumber: $membershipNumber, firstName: $firstName, lastName: $lastName, secondLastName: $secondLastName, memberType: $memberType, isTitular: $isTitular, photoUrl: $photoUrl, email: $email, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.membershipNumber, membershipNumber) ||
                other.membershipNumber == membershipNumber) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.secondLastName, secondLastName) ||
                other.secondLastName == secondLastName) &&
            (identical(other.memberType, memberType) ||
                other.memberType == memberType) &&
            (identical(other.isTitular, isTitular) ||
                other.isTitular == isTitular) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    membershipNumber,
    firstName,
    lastName,
    secondLastName,
    memberType,
    isTitular,
    photoUrl,
    email,
    phone,
  );

  /// Create a copy of Member
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberImplCopyWith<_$MemberImpl> get copyWith =>
      __$$MemberImplCopyWithImpl<_$MemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberImplToJson(this);
  }
}

abstract class _Member extends Member {
  const factory _Member({
    required final String id,
    required final String membershipNumber,
    required final String firstName,
    required final String lastName,
    required final String? secondLastName,
    required final String memberType,
    final bool isTitular,
    final String? photoUrl,
    final String? email,
    final String? phone,
  }) = _$MemberImpl;
  const _Member._() : super._();

  factory _Member.fromJson(Map<String, dynamic> json) = _$MemberImpl.fromJson;

  @override
  String get id; // NetSuite ID or local ID
  @override
  String get membershipNumber; // e.g. 2270600
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get secondLastName;
  @override
  String get memberType; // '1' for Titular, others for Beneficiaries
  @override
  bool get isTitular;
  @override
  String? get photoUrl;
  @override
  String? get email;
  @override
  String? get phone;

  /// Create a copy of Member
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberImplCopyWith<_$MemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
