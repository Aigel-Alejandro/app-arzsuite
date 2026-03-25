// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileSettingsModelImpl _$$ProfileSettingsModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProfileSettingsModelImpl(
  theme: json['theme'] as String? ?? 'system',
  emailNotifications: json['emailNotifications'] as bool? ?? true,
  pushNotifications: json['pushNotifications'] as bool? ?? true,
  classReminders: json['classReminders'] as bool? ?? true,
);

Map<String, dynamic> _$$ProfileSettingsModelImplToJson(
  _$ProfileSettingsModelImpl instance,
) => <String, dynamic>{
  'theme': instance.theme,
  'emailNotifications': instance.emailNotifications,
  'pushNotifications': instance.pushNotifications,
  'classReminders': instance.classReminders,
};
