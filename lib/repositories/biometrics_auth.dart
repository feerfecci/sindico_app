import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await auth.isDeviceSupported();
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    final isAvaliable = await hasBiometrics();
    if (!isAvaliable) return false;
    try {
      return await auth.authenticate(
          options: AuthenticationOptions(
              stickyAuth: true, sensitiveTransaction: false),
          localizedReason: 'Desbloqueie seu celular');
    } on PlatformException catch (e) {
      return false;
    }
  }
}
