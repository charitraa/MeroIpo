import 'package:local_auth/local_auth.dart';

import '../utils/logger.dart';

/// Wraps local_auth for the app-level biometric / device-credential lock.
class BiometricService {
  BiometricService([LocalAuthentication? auth])
      : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;
  final AppLogger _log = AppLogger('Biometric');

  Future<bool> get isAvailable async {
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      return supported && canCheck;
    } catch (e) {
      _log.w('availability check failed: $e');
      return false;
    }
  }

  /// Prompts the user. Returns true only on a successful authentication.
  Future<bool> authenticate({
    String reason = 'Unlock Nepal IPO Auto-Apply',
  }) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (e) {
      _log.w('authentication failed: $e');
      return false;
    }
  }
}
