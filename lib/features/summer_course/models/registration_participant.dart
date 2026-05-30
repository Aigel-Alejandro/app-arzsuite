import 'member.dart';
import 'guest.dart';

enum ParticipantType {
  socio,
  invitado,
  colaborador,
  invColaborador,
}

class RegistrationParticipant {
  final Member? member;
  final Guest? guest;
  final ParticipantType type;
  final Map<String, int?> selectedWeeks; // week_number (String) -> intensive_activity_id
  final double calculatedCost;

  const RegistrationParticipant({
    this.member,
    this.guest,
    required this.type,
    this.selectedWeeks = const {},
    this.calculatedCost = 0.0,
  });

  RegistrationParticipant copyWith({
    Object? member = const Object(),
    Object? guest = const Object(),
    ParticipantType? type,
    Map<String, int?>? selectedWeeks,
    double? calculatedCost,
  }) {
    return RegistrationParticipant(
      member: member == const Object() ? this.member : member as Member?,
      guest: guest == const Object() ? this.guest : guest as Guest?,
      type: type ?? this.type,
      selectedWeeks: selectedWeeks ?? this.selectedWeeks,
      calculatedCost: calculatedCost ?? this.calculatedCost,
    );
  }

  factory RegistrationParticipant.fromJson(Map<String, dynamic> json) {
    return RegistrationParticipant(
      member: json['member'] != null ? Member.fromJson(json['member']) : null,
      guest: json['guest'] != null ? Guest.fromJson(json['guest']) : null,
      type: ParticipantType.values.firstWhere((e) => e.toString() == 'ParticipantType.${json['type']}'),
      selectedWeeks: Map<String, int?>.from(json['selectedWeeks'] ?? {}),
      calculatedCost: (json['calculatedCost'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'member': member?.toJson(),
      'guest': guest?.toJson(),
      'type': type.name,
      'selectedWeeks': selectedWeeks,
      'calculatedCost': calculatedCost,
    };
  }

  String get fullName => member?.fullName ?? guest?.fullName ?? 'Unknown';
  
  String get identifier {
    if (member != null) return 'member_${member!.membershipNumber}';
    if (guest != null) return 'guest_${guest!.email}_${guest!.firstName}_${guest!.lastName}';
    return 'N/A';
  }
  bool get isSocio => member != null;
  bool get isGuest => guest != null;

  double get totalCost => calculatedCost;
}
