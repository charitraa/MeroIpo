import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/di/providers.dart';
import 'core/services/background_service.dart';
import 'core/storage/hive_storage.dart';
import 'core/utils/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final log = AppLogger('Bootstrap');

  // Config (falls back to defaults if the asset is missing).
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    log.w('.env not loaded: $e');
  }

  // Firebase is optional — app runs without it (FCM stays inert).
  try {
    await Firebase.initializeApp();
  } catch (e) {
    log.w('Firebase not initialised (config missing?): $e');
  }

  await HiveStorage.init();
  final prefs = await SharedPreferences.getInstance();

  // Background auto-apply (mobile only).
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    try {
      await BackgroundService.initialize();
      await BackgroundService.registerPeriodicAutoApply();
    } catch (e) {
      log.w('Workmanager unavailable: $e');
    }
  }

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const IpoApp(),
    ),
  );
}
