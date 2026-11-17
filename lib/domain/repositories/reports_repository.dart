import '../../data/models/reports_models.dart';

abstract class ReportsRepository {
  Future<ReportsData> getReportsData(String timeRange);
}
