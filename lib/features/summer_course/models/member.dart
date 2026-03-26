import 'package:freezed_annotation/freezed_annotation.dart';

part 'member.freezed.dart';
part 'member.g.dart';

@freezed
class Member with _$Member {
  const factory Member({
    required String id, // NetSuite ID or local ID
    required String membershipNumber, // e.g. 2270600
    required String firstName,
    required String lastName,
    required String? secondLastName,
    required String memberType, // '1' for Titular, others for Beneficiaries
    @Default(false) bool isTitular,
    String? photoUrl,
    String? email,
    String? phone,
    String? token,
    int? age,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

  const Member._();

  String get fullName => '$firstName $lastName ${secondLastName ?? ''}'.trim();
  
  String get memberIdBase => membershipNumber.length >= 2 
      ? membershipNumber.substring(0, membershipNumber.length - 2) 
      : membershipNumber;
}
