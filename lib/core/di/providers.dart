import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/accounts/data/models/account_model.dart';
import '../../features/accounts/presentation/providers/accounts_provider.dart';
import '../../features/ipo/data/models/ipo_application_model.dart';
import '../../features/ipo/data/models/ipo_listing_model.dart';
import '../../features/ipo/presentation/providers/open_ipos_provider.dart';
import '../constants/storage_keys.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../services/auto_apply_service.dart';
import '../services/biometric_service.dart';
import '../services/notification_service.dart';
import '../storage/preferences_storage.dart';
import '../storage/secure_storage.dart';

/// Overridden in `main()` with the resolved instance.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider must be overridden'),
);

final preferencesStorageProvider = Provider<PreferencesStorage>(
  (ref) => PreferencesStorage(ref.watch(sharedPreferencesProvider)),
);

final secureStorageProvider = Provider<SecureStorage>((ref) => SecureStorage());

final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

final networkInfoProvider = Provider<NetworkInfo>(
  (ref) => NetworkInfo(ref.watch(connectivityProvider)),
);

/// Single mutable Bearer-token holder shared with the Dio interceptor.
final tokenStoreProvider = Provider<TokenStore>((ref) => TokenStore());

final dioProvider = Provider<Dio>((ref) {
  final store = ref.watch(tokenStoreProvider);
  return DioClient(tokenStore: store).build();
});

final notificationServiceProvider =
    Provider<NotificationService>((ref) => NotificationService());

final biometricServiceProvider =
    Provider<BiometricService>((ref) => BiometricService());

// --- Hive boxes (opened in HiveStorage.init before runApp) ---

final accountsBoxProvider = Provider<Box<AccountModel>>(
  (ref) => Hive.box<AccountModel>(StorageKeys.accountsBox),
);

final applicationsBoxProvider = Provider<Box<IpoApplicationModel>>(
  (ref) => Hive.box<IpoApplicationModel>(StorageKeys.applicationsBox),
);

final ipoListingsBoxProvider = Provider<Box<IpoListingModel>>(
  (ref) => Hive.box<IpoListingModel>(StorageKeys.ipoListingsBox),
);

/// Core orchestration service used by the background task and manual triggers.
final autoApplyServiceProvider = Provider<AutoApplyService>(
  (ref) => AutoApplyService(
    getOpenIpos: ref.watch(getOpenIposUsecaseProvider),
    getAccounts: ref.watch(getAccountsUsecaseProvider),
    bulkApply: ref.watch(bulkApplyIpoUsecaseProvider),
    notifications: ref.watch(notificationServiceProvider),
  ),
);
