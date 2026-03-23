import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/summer_course/models/member.dart';

// Este provider almacenará temporalmente al "Socio" logueado
// para poder usar sus datos en el resto de la aplicación (como Summer Course)
class AuthNotifier extends StateNotifier<Member?> {
  AuthNotifier() : super(null);

  void setLoggedInMember(Member member) {
    state = member;
  }

  void logout() {
    state = null;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, Member?>((ref) {
  return AuthNotifier();
});
