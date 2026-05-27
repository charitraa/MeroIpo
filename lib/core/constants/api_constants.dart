import 'package:flutter_dotenv/flutter_dotenv.dart';

/// MeroShare (CDSC) API endpoints. Base URL comes from `.env` so it can be
/// overridden without a rebuild; falls back to the public production host.
class ApiConstants {
  ApiConstants._();

  static String get baseUrl =>
      dotenv.maybeGet('MEROSHARE_BASE_URL') ??
      'https://meroshare.cdsc.com.np/api/v2';

  /// Optional FCM relay backend. Empty when unused.
  static String get backendBaseUrl => dotenv.maybeGet('BACKEND_BASE_URL') ?? '';

  // --- Endpoints ---

  /// POST — login. `{dpId}` is the Depository Participant id.
  /// Body: `clientId`, `username`, `password`. Returns `{ "token": "..." }`.
  static String loginWithClientId(String dpId) =>
      '/auth/loginWithClientId/$dpId';

  /// GET — IPOs currently open for application.
  static const String applicableIpos = '/meroShare/applicable/';

  /// POST — apply for an IPO. Body: companyShareId, crnNumber, customerId,
  /// demat, quantity.
  static const String applyShare = '/share/apply/';

  /// GET — shares the account has already applied for.
  static const String myShare = '/myPurchase/myShare/';

  /// GET — allotment report for a given company share.
  static String report(String companyShareId) => '/report/$companyShareId/';

  /// GET — Depository Participant (capital) list.
  static const String capitalList = '/meroShare/capital/';

  /// GET — bank accounts linked for ASBA.
  static const String bankRequest = '/bankRequest/';

  // --- Headers ---
  static const String authHeader = 'Authorization';
  static String bearer(String token) => 'Bearer $token';
}
