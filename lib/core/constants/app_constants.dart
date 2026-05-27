import 'package:flutter_dotenv/flutter_dotenv.dart';

/// App-wide tunables and limits. Values that may change per environment are
/// read from `.env`; the rest are compile-time constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'Nepal IPO Auto-Apply';

  /// Maximum MeroShare accounts a user may register.
  static const int maxAccounts = 20;

  /// Default number of shares applied per IPO.
  static int get defaultApplyQuantity =>
      int.tryParse(dotenv.maybeGet('DEFAULT_APPLY_QUANTITY') ?? '') ?? 10;

  /// How often the background task polls for open IPOs.
  static Duration get backgroundPollInterval => Duration(
        minutes:
            int.tryParse(dotenv.maybeGet('BACKGROUND_POLL_INTERVAL_MINUTES') ??
                    '') ??
                120,
      );

  // Network timeouts.
  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Workmanager unique task identifiers.
  static const String autoApplyTaskName = 'ipo_auto_apply_task';
  static const String autoApplyTaskTag = 'ipo.auto_apply';

  // Validation.
  static const int boidLength = 16;
}
