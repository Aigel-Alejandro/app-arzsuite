import 'package:freezed_annotation/freezed_annotation.dart';

part 'guest.freezed.dart';
part 'guest.g.dart';

@freezed
class Guest with _$Guest {
  const factory Guest({
    required String firstName,
    required String lastName,
    required String? secondLastName,
    required String email,
    required String phone,
    required String relationship, // Hijo(a), Sobrino(a), etc.
    required String titularMembershipNumber, // Reference to the titular
  }) = _Guest;

  factory Guest.fromJson(Map<String, dynamic> json) => _$GuestFromJson(json);

  const Guest._();

  String get fullName => '$firstName $lastName ${secondLastName ?? ''}'.trim();
}
