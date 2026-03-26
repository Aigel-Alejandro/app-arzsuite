import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/summer_course/models/member.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global_providers.dart';

// Este provider almacenará temporalmente al "Socio" logueado
// para poder usar sus datos en el resto de la aplicación (como Summer Course)
class AuthNotifier extends StateNotifier<Member?> {
  final SharedPreferences _prefs;

  AuthNotifier(this._prefs) : super(_loadFromPrefs(_prefs));

  static Member? _loadFromPrefs(SharedPreferences prefs) {
    final token = prefs.getString('saved_token');
    final username = prefs.getString('saved_username');
    final fullName = prefs.getString('saved_fullname') ?? 'Socio';
    final socioId = prefs.getString('saved_id') ?? '0';

    if (token != null && token.isNotEmpty && username != null) {
      return Member(
        id: socioId,
        membershipNumber: username,
        firstName: fullName,
        lastName: '',
        secondLastName: '',
        memberType: 'Titular',
        isTitular: true,
        token: token,
      );
    }
    return null;
  }

  void setLoggedInMember(Member member) {
    state = member;
    _prefs.setString('saved_token', member.token ?? '');
    _prefs.setString('saved_username', member.membershipNumber);
    _prefs.setString('saved_fullname', member.firstName);
    _prefs.setString('saved_id', member.id);
  }

  void logout() {
    state = null;
    _prefs.remove('saved_token');
    _prefs.remove('saved_username');
    _prefs.remove('saved_fullname');
    _prefs.remove('saved_id');
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, Member?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthNotifier(prefs);
});
