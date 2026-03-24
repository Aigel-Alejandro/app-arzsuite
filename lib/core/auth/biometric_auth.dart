/// Import condicional: en web usa el stub, en nativo usa local_auth real.
export 'biometric_auth_stub.dart'
    if (dart.library.io) 'biometric_auth_native.dart';
