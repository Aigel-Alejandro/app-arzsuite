import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_settings_model.freezed.dart';
part 'profile_settings_model.g.dart';

@freezed
class ProfileSettingsModel with _$ProfileSettingsModel {
  const factory ProfileSettingsModel({
    @Default('system') String theme,
    @Default(true) bool emailNotifications,
    @Default(true) bool pushNotifications,
    @Default(true) bool classReminders,
  }) = _ProfileSettingsModel;

  factory ProfileSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileSettingsModelFromJson(json);
}
