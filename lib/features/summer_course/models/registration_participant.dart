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
  }) = _RegistrationParticipant;

  factory RegistrationParticipant.fromJson(Map<String, dynamic> json) => 
      _$RegistrationParticipantFromJson(json);

  const RegistrationParticipant._();

  String get fullName => member?.fullName ?? guest?.fullName ?? 'Unknown';
  
  String get identifier => member?.membershipNumber ?? guest?.email ?? 'N/A';

  bool get isSocio => member != null;
  bool get isGuest => guest != null;

  double get totalCost {
    final weeksCount = selectedWeekIds.length;
    if (weeksCount == 0) return 0.0;

    // Prices according to logic
    // | Tipo | 1 sem | 2 sem | 3 sem | 4 sem | 5 sem |
    // |------|-------|-------|-------|-------|-------|
    // | Socio | 2495 | 4790 | 6890 | 8800 | 9570 |
    // | Invitado | 3130 | 6000 | 8635 | 11020 | 11985 |
    // | Colab | 1245 | 2400 | 3450 | 4395 | 4790 |
    // | Inv Colab | 1720 | 3305 | 4755 | 6075 | 6605 |

    switch (type) {
      case ParticipantType.socio:
        return [2495, 4790, 6890, 8800, 9570][weeksCount - 1].toDouble();
      case ParticipantType.invitado:
        return [3130, 6000, 8635, 11020, 11985][weeksCount - 1].toDouble();
      case ParticipantType.colaborador:
        return [1245, 2400, 3450, 4395, 4790][weeksCount - 1].toDouble();
      case ParticipantType.invColaborador:
        return [1720, 3305, 4755, 6075, 6605][weeksCount - 1].toDouble();
    }
  }
}
