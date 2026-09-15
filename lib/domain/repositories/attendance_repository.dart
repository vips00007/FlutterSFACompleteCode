import '../../data/models/attendance_request.dart';
import '../../data/models/attendance_response.dart';
import '../../data/models/attendance_history_response.dart';
import '../../data/models/today_attendance_response.dart';

abstract class AttendanceRepository {
  Future<AttendanceResponse> checkIn(AttendanceRequest request);
  Future<AttendanceResponse> checkOut(AttendanceRequest request);
  Future<AttendanceHistoryResponse> getHistory(int page, int size);
  Future<TodayAttendanceResponse> getTodayAttendance();
}
