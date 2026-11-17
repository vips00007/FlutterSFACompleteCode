import '../../domain/repositories/reports_repository.dart';
import '../datasource/remote/reports_api_service.dart';
import '../models/reports_models.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsApiService _apiService;

  ReportsRepositoryImpl(this._apiService);

  @override
  Future<ReportsData> getReportsData(String timeRange) async {
    return await _apiService.getReportsData(timeRange);
  }
}
