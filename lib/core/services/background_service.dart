import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../constants/app_constants.dart';
import '../di/providers.dart';
import '../storage/hive_storage.dart';
import '../utils/logger.dart';

/// Workmanager entry point. Runs in a SEPARATE ISOLATE, so every dependency is
/// re-initialised here from scratch (Hive, dotenv, SharedPreferences) and a
/// fresh [ProviderContainer] is created — nothing from the UI isolate is shared.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    final log = AppLogger('BgTask');

    try {
      try {
        await dotenv.load(fileName: '.env');
      } catch (_) {
        // Falls back to default config in ApiConstants.
      }
      await HiveStorage.init();
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      try {
        // Respect the global toggle.
        if (!container.read(preferencesStorageProvider).autoApplyGlobalEnabled) {
          log.i('global auto-apply disabled; skipping');
          return true;
        }
        await container.read(notificationServiceProvider).init(initFirebase: false);
        final report = await container.read(autoApplyServiceProvider).run();
        await container
            .read(preferencesStorageProvider)
            .setLastPollAt(DateTime.now());
        log.i('applied=${report.applied} errors=${report.errors}');
        return true;
      } finally {
        container.dispose();
      }
    } catch (e, st) {
      log.e('background task failed', e, st);
      return false; // let Workmanager retry
    }
  });
}

/// Registers the periodic auto-apply task. Call once after `Workmanager().initialize`.
class BackgroundService {
  BackgroundService._();

  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  static Future<void> registerPeriodicAutoApply() async {
    await Workmanager().registerPeriodicTask(
      AppConstants.autoApplyTaskName,
      AppConstants.autoApplyTaskName,
      tag: AppConstants.autoApplyTaskTag,
      frequency: AppConstants.backgroundPollInterval,
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingWorkPolicy.keep,
    );
  }

  static Future<void> cancelAutoApply() =>
      Workmanager().cancelByTag(AppConstants.autoApplyTaskTag);
}
