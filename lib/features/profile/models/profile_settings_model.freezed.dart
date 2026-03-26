// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProfileSettingsModel _$ProfileSettingsModelFromJson(Map<String, dynamic> json) {
  return _ProfileSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$ProfileSettingsModel {
  String get theme => throw _privateConstructorUsedError;
  bool get emailNotifications => throw _privateConstructorUsedError;
  bool get pushNotifications => throw _privateConstructorUsedError;
  bool get classReminders => throw _privateConstructorUsedError;

  /// Serializes this ProfileSettingsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfileSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileSettingsModelCopyWith<ProfileSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileSettingsModelCopyWith<$Res> {
  factory $ProfileSettingsModelCopyWith(
    ProfileSettingsModel value,
    $Res Function(ProfileSettingsModel) then,
  ) = _$ProfileSettingsModelCopyWithImpl<$Res, ProfileSettingsModel>;
  @useResult
  $Res call({
    String theme,
    bool emailNotifications,
    bool pushNotifications,
    bool classReminders,
  });
}

/// @nodoc
class _$ProfileSettingsModelCopyWithImpl<
  $Res,
  $Val extends ProfileSettingsModel
>
    implements $ProfileSettingsModelCopyWith<$Res> {
  _$ProfileSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? theme = null,
    Object? emailNotifications = null,
    Object? pushNotifications = null,
    Object? classReminders = null,
  }) {
    return _then(
      _value.copyWith(
            theme: null == theme
                ? _value.theme
                : theme // ignore: cast_nullable_to_non_nullable
                      as String,
            emailNotifications: null == emailNotifications
                ? _value.emailNotifications
                : emailNotifications // ignore: cast_nullable_to_non_nullable
                      as bool,
            pushNotifications: null == pushNotifications
                ? _value.pushNotifications
                : pushNotifications // ignore: cast_nullable_to_non_nullable
                      as bool,
            classReminders: null == classReminders
                ? _value.classReminders
                : classReminders // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProfileSettingsModelImplCopyWith<$Res>
    implements $ProfileSettingsModelCopyWith<$Res> {
  factory _$$ProfileSettingsModelImplCopyWith(
    _$ProfileSettingsModelImpl value,
    $Res Function(_$ProfileSettingsModelImpl) then,
  ) = __$$ProfileSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String theme,
    bool emailNotifications,
    bool pushNotifications,
    bool classReminders,
  });
}

/// @nodoc
class __$$ProfileSettingsModelImplCopyWithImpl<$Res>
    extends _$ProfileSettingsModelCopyWithImpl<$Res, _$ProfileSettingsModelImpl>
    implements _$$ProfileSettingsModelImplCopyWith<$Res> {
  __$$ProfileSettingsModelImplCopyWithImpl(
    _$ProfileSettingsModelImpl _value,
    $Res Function(_$ProfileSettingsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfileSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? theme = null,
    Object? emailNotifications = null,
    Object? pushNotifications = null,
    Object? classReminders = null,
  }) {
    return _then(
      _$ProfileSettingsModelImpl(
        theme: null == theme
            ? _value.theme
            : theme // ignore: cast_nullable_to_non_nullable
                  as String,
        emailNotifications: null == emailNotifications
            ? _value.emailNotifications
            : emailNotifications // ignore: cast_nullable_to_non_nullable
                  as bool,
        pushNotifications: null == pushNotifications
            ? _value.pushNotifications
            : pushNotifications // ignore: cast_nullable_to_non_nullable
                  as bool,
        classReminders: null == classReminders
            ? _value.classReminders
            : classReminders // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileSettingsModelImpl implements _ProfileSettingsModel {
  const _$ProfileSettingsModelImpl({
    this.theme = 'system',
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.classReminders = true,
  });

  factory _$ProfileSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileSettingsModelImplFromJson(json);

  @override
  @JsonKey()
  final String theme;
  @override
  @JsonKey()
  final bool emailNotifications;
  @override
  @JsonKey()
  final bool pushNotifications;
  @override
  @JsonKey()
  final bool classReminders;

  @override
  String toString() {
    return 'ProfileSettingsModel(theme: $theme, emailNotifications: $emailNotifications, pushNotifications: $pushNotifications, classReminders: $classReminders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileSettingsModelImpl &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.emailNotifications, emailNotifications) ||
                other.emailNotifications == emailNotifications) &&
            (identical(other.pushNotifications, pushNotifications) ||
                other.pushNotifications == pushNotifications) &&
            (identical(other.classReminders, classReminders) ||
                other.classReminders == classReminders));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    theme,
    emailNotifications,
    pushNotifications,
    classReminders,
  );

  /// Create a copy of ProfileSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileSettingsModelImplCopyWith<_$ProfileSettingsModelImpl>
  get copyWith =>
      __$$ProfileSettingsModelImplCopyWithImpl<_$ProfileSettingsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileSettingsModelImplToJson(this);
  }
}

abstract class _ProfileSettingsModel implements ProfileSettingsModel {
  const factory _ProfileSettingsModel({
    final String theme,
    final bool emailNotifications,
    final bool pushNotifications,
    final bool classReminders,
  }) = _$ProfileSettingsModelImpl;

  factory _ProfileSettingsModel.fromJson(Map<String, dynamic> json) =
      _$ProfileSettingsModelImpl.fromJson;

  @override
  String get theme;
  @override
  bool get emailNotifications;
  @override
  bool get pushNotifications;
  @override
  bool get classReminders;

  /// Create a copy of ProfileSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileSettingsModelImplCopyWith<_$ProfileSettingsModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
