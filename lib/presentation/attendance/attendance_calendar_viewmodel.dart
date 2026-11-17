import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../../data/models/attendance_response.dart';

class AttendanceCalendarViewModel extends GetxController {
  final AttendanceRepository _repository;

  AttendanceCalendarViewModel(this._repository);

  final isLoading = false.obs;
  final currentMonth = DateTime.now().obs;
  final selectedDate = DateTime.now().obs;
  
  final Map<String, AttendanceData> attendanceRecords = {};
  final recentHistoryList = <AttendanceData>[].obs;
  final recentHistoryCount = 0.obs;
  
  // Status summary for top cards
  final int presentCount = 16;
  final int absentCount = 1;
  final int leaveCount = 1;
  final int lateCount = 2;
  final int halfCount = 1;
  final String attendancePercentage = '78%';

  @override
  void onInit() {
    super.onInit();
    fetchMonthlyAttendance();
  }

  void previousMonth() {
    currentMonth.value = DateTime(currentMonth.value.year, currentMonth.value.month - 1);
    fetchMonthlyAttendance();
  }

  void nextMonth() {
    currentMonth.value = DateTime(currentMonth.value.year, currentMonth.value.month + 1);
    fetchMonthlyAttendance();
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  Future<void> fetchMonthlyAttendance() async {
    isLoading.value = true;
    try {
      final response = await _repository.getHistory(0, 100); // Fetch recent 100 days
      if (response.success && response.data != null) {
        attendanceRecords.clear();
        recentHistoryList.assignAll(response.data!.content);
        recentHistoryCount.value = response.data!.totalElements;

        for (var record in response.data!.content) {
          try {
            // businessDate format assumes "dd/MM/yyyy" or "yyyy-MM-dd"
            final format = DateFormat('dd/MM/yyyy'); // Try one
            DateTime date;
            try {
               date = format.parse(record.businessDate);
            } catch (e) {
               date = DateTime.parse(record.businessDate); // fallback
            }
            final dateKey = DateFormat('yyyy-MM-dd').format(date);
            attendanceRecords[dateKey] = record;
          } catch (e) {
            // Ignore parse errors for individual records
          }
        }
      }
    } catch (e) {
      // Handle error or just ignore for mock functionality
    } finally {
      isLoading.value = false;
    }
  }

  AttendanceData? getRecordForDate(DateTime date) {
    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    return attendanceRecords[dateKey];
  }
}
