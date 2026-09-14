import '../../data/models/attendance_request.dart';
import '../../data/models/attendance_response.dart';

abstract class AttendanceRepository {
  Future<AttendanceResponse> checkIn(AttendanceRequest request);
  Future<AttendanceResponse> checkOut(AttendanceRequest request);
}
