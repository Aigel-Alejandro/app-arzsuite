import 'package:local_auth/local_auth.dart';

/// Implementación nativa (Android / iOS) usando el paquete local_auth.
class BiometricAuth {
  final _auth = LocalAuthentication();

  Future<bool> canCheckBiometrics() => _auth.canCheckBiometrics;

  Future<bool> isDeviceSupported() => _auth.isDeviceSupported();

  Future<bool> authenticate({required String localizedReason}) =>
      _auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
}
