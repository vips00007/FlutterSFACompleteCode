import '../../domain/repositories/attendance_repository.dart';
import '../datasource/remote/attendance_api_service.dart';
import '../models/attendance_request.dart';
import '../models/attendance_response.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceApiService _apiService;

  AttendanceRepositoryImpl(this._apiService);

  @override
  Future<AttendanceResponse> checkIn(AttendanceRequest request) {
    return _apiService.checkIn(request);
  }

  @override
  Future<AttendanceResponse> checkOut(AttendanceRequest request) {
    return _apiService.checkOut(request);
  }
}
