import 'package:freezed_annotation/freezed_annotation.dart';

part 'sub_member_model.freezed.dart';
part 'sub_member_model.g.dart';

@freezed
class SubMemberModel with _$SubMemberModel {
  const factory SubMemberModel({
    required String id,
    required String fullname,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    required String membershipNumber,
    required String memberType,
    @JsonKey(name: 'birth_date') String? birthDate,
    int? age,
    String? genero,
  }) = _SubMemberModel;

  factory SubMemberModel.fromJson(Map<String, dynamic> json) =>
      _$SubMemberModelFromJson(json);
}
