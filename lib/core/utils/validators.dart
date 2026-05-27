import '../constants/app_constants.dart';

/// Form field validators. Return `null` when valid, else an error message.
class Validators {
  Validators._();

  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) return 'Username is required';
    if (value.trim().length < 3) return 'Username looks too short';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 4) return 'Password looks too short';
    return null;
  }

  /// Depository Participant id — numeric, typically 4–6 digits (e.g. 13200).
  static String? dpId(String? value) {
    if (value == null || value.trim().isEmpty) return 'DP id is required';
    if (!RegExp(r'^\d{3,7}$').hasMatch(value.trim())) {
      return 'DP id must be 3–7 digits';
    }
    return null;
  }

  /// 16-digit BOID / demat number.
  static String? boid(String? value) {
    if (value == null || value.trim().isEmpty) return 'BOID is required';
    final v = value.trim();
    if (!RegExp(r'^\d+$').hasMatch(v)) return 'BOID must be digits only';
    if (v.length != AppConstants.boidLength) {
      return 'BOID must be ${AppConstants.boidLength} digits';
    }
    return null;
  }

  /// C-ASBA Registration Number — alphanumeric.
  static String? crn(String? value) {
    if (value == null || value.trim().isEmpty) return 'CRN is required';
    if (!RegExp(r'^[A-Za-z0-9]+$').hasMatch(value.trim())) {
      return 'CRN must be alphanumeric';
    }
    return null;
  }

  static String? quantity(String? value, {int min = 10, int? max}) {
    final n = int.tryParse(value?.trim() ?? '');
    if (n == null) return 'Enter a number';
    if (n < min) return 'Minimum is $min';
    if (max != null && n > max) return 'Maximum is $max';
    return null;
  }
}
