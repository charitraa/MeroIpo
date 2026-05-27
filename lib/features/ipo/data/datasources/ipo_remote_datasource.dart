import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/ipo_listing_model.dart';

/// MeroShare IPO endpoints. Requires the active account's Bearer token to be
/// set on [_dio] (handled by the auth flow before these calls).
class IpoRemoteDataSource {
  IpoRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<IpoListingModel>> getOpenIpos() async {
    final response = await _dio.get(ApiConstants.applicableIpos);
    final list = _extractList(response.data);
    return list
        .whereType<Map>()
        .map((e) => IpoListingModel.fromApi(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// Returns the set of `companyShareId`s the account has already applied for.
  Future<Set<String>> getAppliedShareIds() async {
    final response = await _dio.get(ApiConstants.myShare);
    final list = _extractList(response.data);
    return list
        .whereType<Map>()
        .map((e) => e['companyShareId']?.toString())
        .whereType<String>()
        .toSet();
  }

  /// POST /share/apply/. Returns the server message on success.
  Future<String> apply({
    required String companyShareId,
    required String crn,
    required String customerId,
    required String demat,
    required int quantity,
  }) async {
    final response = await _dio.post(
      ApiConstants.applyShare,
      data: {
        'companyShareId': companyShareId,
        'crnNumber': crn,
        'customerId': customerId,
        'demat': demat,
        'quantity': quantity,
      },
    );
    final data = response.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return 'Applied';
  }

  /// MeroShare sometimes wraps lists in `{ "object": [...] }`.
  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      final obj = data['object'] ?? data['data'] ?? data['applicableIssues'];
      if (obj is List) return obj;
    }
    return const [];
  }
}
