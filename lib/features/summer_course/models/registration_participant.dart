import 'package:freezed_annotation/freezed_annotation.dart';
import 'member.dart';
import 'guest.dart';

part 'registration_participant.freezed.dart';
part 'registration_participant.g.dart';

enum ParticipantType {
  socio,
  invitado,
  colaborador,
  invColaborador,
}

@freezed
class RegistrationParticipant with _$RegistrationParticipant {
  const factory RegistrationParticipant({
    Member? member,
    Guest? guest,
    required ParticipantType type,
    @Default([]) List<int> selectedWeekIds, // IDs 1 to 5
    @Default(0.0) double calculatedCost,
  }) = _RegistrationParticipant;

  factory RegistrationParticipant.fromJson(Map<String, dynamic> json) => 
      _$RegistrationParticipantFromJson(json);

  const RegistrationParticipant._();

  String get fullName => member?.fullName ?? guest?.fullName ?? 'Unknown';
  
  String get identifier => member?.membershipNumber ?? guest?.email ?? 'N/A';

  bool get isSocio => member != null;
  bool get isGuest => guest != null;

  double get totalCost => calculatedCost;
}
