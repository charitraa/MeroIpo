import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/result_model.dart';

/// Fetches allotment reports from MeroShare. Requires the account's token to be
/// set on [_dio].
class ResultRemoteDataSource {
  ResultRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ResultModel> fetchReport(String companyShareId) async {
    final response = await _dio.get(ApiConstants.report(companyShareId));
    return ResultModel.fromApi(companyShareId, response.data);
  }
}
