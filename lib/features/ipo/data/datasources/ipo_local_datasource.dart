import 'package:hive/hive.dart';

import '../../../../core/errors/app_exception.dart';
import '../models/ipo_application_model.dart';
import '../models/ipo_listing_model.dart';

/// Local cache for IPO listings and the application history (Hive).
class IpoLocalDataSource {
  IpoLocalDataSource({
    required Box<IpoApplicationModel> applicationsBox,
    required Box<IpoListingModel> listingsBox,
  })  : _applications = applicationsBox,
        _listings = listingsBox;

  final Box<IpoApplicationModel> _applications;
  final Box<IpoListingModel> _listings;

  List<IpoApplicationModel> getApplications() =>
      _applications.values.toList(growable: false);

  Future<void> saveApplication(IpoApplicationModel model) async {
    try {
      await _applications.put(model.id, model);
    } catch (e) {
      throw CacheException('Failed to save application: $e');
    }
  }

  List<IpoListingModel> getCachedIpos() =>
      _listings.values.toList(growable: false);

  Future<void> cacheIpos(List<IpoListingModel> models) async {
    try {
      await _listings.clear();
      await _listings.putAll({for (final m in models) m.companyShareId: m});
    } catch (e) {
      throw CacheException('Failed to cache IPOs: $e');
    }
  }
}
