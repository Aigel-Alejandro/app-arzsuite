/// Stub para Web: la biometría no está disponible en el navegador.
class BiometricAuth {
  Future<bool> canCheckBiometrics() async => false;
  Future<bool> isDeviceSupported() async => false;
  Future<bool> authenticate({required String localizedReason}) async => false;
}
