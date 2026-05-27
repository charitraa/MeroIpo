import 'package:hive_flutter/hive_flutter.dart';

import '../../features/accounts/data/models/account_model.dart';
import '../../features/ipo/data/models/ipo_application_model.dart';
import '../../features/ipo/data/models/ipo_listing_model.dart';
import '../constants/storage_keys.dart';

/// Initialises Hive, registers adapters, and opens the typed boxes.
///
/// Type ids are fixed: accounts = 0, ipoApplications = 1, ipoListings = 2.
/// Safe to call from both the UI isolate and the background isolate.
class HiveStorage {
  HiveStorage._();

  static bool _initialised = false;

  static Future<void> init() async {
    if (_initialised) return;
    await Hive.initFlutter();
    _registerAdapters();
    await Future.wait([
      Hive.openBox<AccountModel>(StorageKeys.accountsBox),
      Hive.openBox<IpoApplicationModel>(StorageKeys.applicationsBox),
      Hive.openBox<IpoListingModel>(StorageKeys.ipoListingsBox),
    ]);
    _initialised = true;
  }

  static void _registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(AccountModelAdapter());
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(IpoApplicationModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(IpoListingModelAdapter());
    }
  }

  static Box<AccountModel> get accounts =>
      Hive.box<AccountModel>(StorageKeys.accountsBox);

  static Box<IpoApplicationModel> get applications =>
      Hive.box<IpoApplicationModel>(StorageKeys.applicationsBox);

  static Box<IpoListingModel> get ipoListings =>
      Hive.box<IpoListingModel>(StorageKeys.ipoListingsBox);
}
