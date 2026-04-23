import 'package:flutter/foundation.dart';
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
    final useBiometrics = prefs.getBool('use_biometrics') ?? false;
    
    // Si la biometría está activada (y no es web), forzamos el estado inicial a null 
    // para que la app inicie en LoginView y solicite la biometría.
    if (useBiometrics && !kIsWeb) {
      return null;
    }

    final token = prefs.getString('saved_token');
    final username = prefs.getString('saved_username');
    final fullName = prefs.getString('saved_fullname') ?? 'Socio';
    final socioId = prefs.getString('saved_id') ?? '0';
    final memberType = prefs.getString('saved_member_type') ?? 'Titular';
    final permissions = prefs.getStringList('saved_permissions') ?? [];

    if (token != null && token.isNotEmpty && username != null) {
      return Member(
        id: socioId,
        membershipNumber: username,
        firstName: fullName,
        lastName: '',
        secondLastName: '',
        memberType: memberType,
        isTitular: memberType.toLowerCase() == 'titular',
        token: token,
        permissions: permissions,
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
    _prefs.setString('saved_member_type', member.memberType);
    _prefs.setStringList('saved_permissions', member.permissions);
  }

  void logout() {
    state = null;
    _prefs.remove('saved_token');
    _prefs.remove('saved_refresh_token');
    _prefs.remove('use_biometrics');
    _prefs.remove('saved_username');
    _prefs.remove('saved_fullname');
    _prefs.remove('saved_id');
    _prefs.remove('saved_member_type');
    _prefs.remove('saved_permissions');
  }

  void lockSession() {
    // Solo ponemos el estado en null para forzar el LoginView (y la pantalla de biometría)
    // No borramos las preferencias para que pueda reingresar con huella/FaceID.
    state = null;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, Member?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthNotifier(prefs);
});
