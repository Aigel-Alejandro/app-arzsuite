// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'profile_settings_model.dart';
import 'sub_member_model.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    required String entityid,
    required String fullname,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    String? email,
    String? phone,
    String? rfc,
    String? curp,
    String? address,
    @JsonKey(name: 'profile_picture') String? profilePicture,
    @JsonKey(name: 'patrimonial_condition_id') int? patrimonialConditionId,
    @JsonKey(name: 'can_edit_sensitive_data') @Default(false) bool canEditSensitiveData,
    @JsonKey(name: 'personal_address') Map<String, dynamic>? personalAddress,
    @JsonKey(name: 'fiscal_data') Map<String, dynamic>? fiscalData,
    required ProfileSettingsModel settings,
    @JsonKey(name: 'associated_members') @Default([]) List<SubMemberModel> associatedMembers,
    @JsonKey(name: 'legal_beneficiaries') @Default([]) List<Map<String, dynamic>> legalBeneficiaries,
    @JsonKey(name: 'vehicles') @Default([]) List<Map<String, dynamic>> vehicles,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}
