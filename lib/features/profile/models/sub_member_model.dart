import 'package:freezed_annotation/freezed_annotation.dart';

part 'sub_member_model.freezed.dart';
part 'sub_member_model.g.dart';

@freezed
class SubMemberModel with _$SubMemberModel {
  const factory SubMemberModel({
    required String id,
    @Default('') String fullname,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'membership_number') @Default('') String membershipNumber,
    @JsonKey(name: 'member_type') @Default('') String memberType,
    @JsonKey(name: 'birth_date') String? birthDate,
    int? age,
    String? genero,
    @JsonKey(name: 'permissions') @Default([]) List<String> permissions,
  }) = _SubMemberModel;

  factory SubMemberModel.fromJson(Map<String, dynamic> json) =>
      _$SubMemberModelFromJson(json);
}
