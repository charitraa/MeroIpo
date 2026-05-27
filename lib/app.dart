import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'core/di/providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/presentation/providers/settings_provider.dart';

class IpoApp extends ConsumerStatefulWidget {
  const IpoApp({super.key});

  @override
  ConsumerState<IpoApp> createState() => _IpoAppState();
}

class _IpoAppState extends ConsumerState<IpoApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initNotifications());
  }

  Future<void> _initNotifications() async {
    final firebaseReady = Firebase.apps.isNotEmpty;
    final service = ref.read(notificationServiceProvider);
    await service.init(initFirebase: firebaseReady);
    if (firebaseReady) {
      final token = await service.fcmToken();
      if (token != null) {
        await ref.read(preferencesStorageProvider).setFcmToken(token);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(settingsProvider).themeMode;

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
