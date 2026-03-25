// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_participant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RegistrationParticipant _$RegistrationParticipantFromJson(
  Map<String, dynamic> json,
) {
  return _RegistrationParticipant.fromJson(json);
}

/// @nodoc
mixin _$RegistrationParticipant {
  Member? get member => throw _privateConstructorUsedError;
  Guest? get guest => throw _privateConstructorUsedError;
  ParticipantType get type => throw _privateConstructorUsedError;
  List<int> get selectedWeekIds =>
      throw _privateConstructorUsedError; // IDs 1 to 5
  double get calculatedCost => throw _privateConstructorUsedError;

  /// Serializes this RegistrationParticipant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegistrationParticipant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegistrationParticipantCopyWith<RegistrationParticipant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationParticipantCopyWith<$Res> {
  factory $RegistrationParticipantCopyWith(
    RegistrationParticipant value,
    $Res Function(RegistrationParticipant) then,
  ) = _$RegistrationParticipantCopyWithImpl<$Res, RegistrationParticipant>;
  @useResult
  $Res call({
    Member? member,
    Guest? guest,
    ParticipantType type,
    List<int> selectedWeekIds,
    double calculatedCost,
  });

  $MemberCopyWith<$Res>? get member;
  $GuestCopyWith<$Res>? get guest;
}

/// @nodoc
class _$RegistrationParticipantCopyWithImpl<
  $Res,
  $Val extends RegistrationParticipant
>
    implements $RegistrationParticipantCopyWith<$Res> {
  _$RegistrationParticipantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegistrationParticipant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? member = freezed,
    Object? guest = freezed,
    Object? type = null,
    Object? selectedWeekIds = null,
    Object? calculatedCost = null,
  }) {
    return _then(
      _value.copyWith(
            member: freezed == member
                ? _value.member
                : member // ignore: cast_nullable_to_non_nullable
                      as Member?,
            guest: freezed == guest
                ? _value.guest
                : guest // ignore: cast_nullable_to_non_nullable
                      as Guest?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as ParticipantType,
            selectedWeekIds: null == selectedWeekIds
                ? _value.selectedWeekIds
                : selectedWeekIds // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            calculatedCost: null == calculatedCost
                ? _value.calculatedCost
                : calculatedCost // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }

  /// Create a copy of RegistrationParticipant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MemberCopyWith<$Res>? get member {
    if (_value.member == null) {
      return null;
    }

    return $MemberCopyWith<$Res>(_value.member!, (value) {
      return _then(_value.copyWith(member: value) as $Val);
    });
  }

  /// Create a copy of RegistrationParticipant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GuestCopyWith<$Res>? get guest {
    if (_value.guest == null) {
      return null;
    }

    return $GuestCopyWith<$Res>(_value.guest!, (value) {
      return _then(_value.copyWith(guest: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RegistrationParticipantImplCopyWith<$Res>
    implements $RegistrationParticipantCopyWith<$Res> {
  factory _$$RegistrationParticipantImplCopyWith(
    _$RegistrationParticipantImpl value,
    $Res Function(_$RegistrationParticipantImpl) then,
  ) = __$$RegistrationParticipantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Member? member,
    Guest? guest,
    ParticipantType type,
    List<int> selectedWeekIds,
    double calculatedCost,
  });

  @override
  $MemberCopyWith<$Res>? get member;
  @override
  $GuestCopyWith<$Res>? get guest;
}

/// @nodoc
class __$$RegistrationParticipantImplCopyWithImpl<$Res>
    extends
        _$RegistrationParticipantCopyWithImpl<
          $Res,
          _$RegistrationParticipantImpl
        >
    implements _$$RegistrationParticipantImplCopyWith<$Res> {
  __$$RegistrationParticipantImplCopyWithImpl(
    _$RegistrationParticipantImpl _value,
    $Res Function(_$RegistrationParticipantImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegistrationParticipant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? member = freezed,
    Object? guest = freezed,
    Object? type = null,
    Object? selectedWeekIds = null,
    Object? calculatedCost = null,
  }) {
    return _then(
      _$RegistrationParticipantImpl(
        member: freezed == member
            ? _value.member
            : member // ignore: cast_nullable_to_non_nullable
                  as Member?,
        guest: freezed == guest
            ? _value.guest
            : guest // ignore: cast_nullable_to_non_nullable
                  as Guest?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ParticipantType,
        selectedWeekIds: null == selectedWeekIds
            ? _value._selectedWeekIds
            : selectedWeekIds // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        calculatedCost: null == calculatedCost
            ? _value.calculatedCost
            : calculatedCost // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RegistrationParticipantImpl extends _RegistrationParticipant {
  const _$RegistrationParticipantImpl({
    this.member,
    this.guest,
    required this.type,
    final List<int> selectedWeekIds = const [],
    this.calculatedCost = 0.0,
  }) : _selectedWeekIds = selectedWeekIds,
       super._();

  factory _$RegistrationParticipantImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegistrationParticipantImplFromJson(json);

  @override
  final Member? member;
  @override
  final Guest? guest;
  @override
  final ParticipantType type;
  final List<int> _selectedWeekIds;
  @override
  @JsonKey()
  List<int> get selectedWeekIds {
    if (_selectedWeekIds is EqualUnmodifiableListView) return _selectedWeekIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedWeekIds);
  }

  // IDs 1 to 5
  @override
  @JsonKey()
  final double calculatedCost;

  @override
  String toString() {
    return 'RegistrationParticipant(member: $member, guest: $guest, type: $type, selectedWeekIds: $selectedWeekIds, calculatedCost: $calculatedCost)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationParticipantImpl &&
            (identical(other.member, member) || other.member == member) &&
            (identical(other.guest, guest) || other.guest == guest) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(
              other._selectedWeekIds,
              _selectedWeekIds,
            ) &&
            (identical(other.calculatedCost, calculatedCost) ||
                other.calculatedCost == calculatedCost));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    member,
    guest,
    type,
    const DeepCollectionEquality().hash(_selectedWeekIds),
    calculatedCost,
  );

  /// Create a copy of RegistrationParticipant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationParticipantImplCopyWith<_$RegistrationParticipantImpl>
  get copyWith =>
      __$$RegistrationParticipantImplCopyWithImpl<
        _$RegistrationParticipantImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegistrationParticipantImplToJson(this);
  }
}

abstract class _RegistrationParticipant extends RegistrationParticipant {
  const factory _RegistrationParticipant({
    final Member? member,
    final Guest? guest,
    required final ParticipantType type,
    final List<int> selectedWeekIds,
    final double calculatedCost,
  }) = _$RegistrationParticipantImpl;
  const _RegistrationParticipant._() : super._();

  factory _RegistrationParticipant.fromJson(Map<String, dynamic> json) =
      _$RegistrationParticipantImpl.fromJson;

  @override
  Member? get member;
  @override
  Guest? get guest;
  @override
  ParticipantType get type;
  @override
  List<int> get selectedWeekIds; // IDs 1 to 5
  @override
  double get calculatedCost;

  /// Create a copy of RegistrationParticipant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegistrationParticipantImplCopyWith<_$RegistrationParticipantImpl>
  get copyWith => throw _privateConstructorUsedError;
}
