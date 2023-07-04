import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    return await auth.isDeviceSupported();
  }

  static Future<bool> authenticate() async {
    final isAvaliable = await hasBiometrics();
    if (!isAvaliable) return false;

    return await auth.authenticate(
      options: AuthenticationOptions(
        sensitiveTransaction: true,
        biometricOnly: false,
        stickyAuth: true,
        useErrorDialogs: true,
      ),
      localizedReason: 'Desbloqueie seu celular',
    );
  }
}
