import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'attendance_calendar_viewmodel.dart';
import '../../routes/route_names.dart';

class AttendanceCalendarScreen extends StatelessWidget {
  const AttendanceCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<AttendanceCalendarViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Attendance',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Obx(() => Text(
              DateFormat('MMMM yyyy').format(viewModel.currentMonth.value),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            )),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E8FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.group_outlined, color: Color(0xFF8A2BE2), size: 24),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Top Cards
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildStatCard('16', 'Present', Colors.green),
                  const SizedBox(width: 8),
                  _buildStatCard('1', 'Absent', Colors.red),
                  const SizedBox(width: 8),
                  _buildStatCard('1', 'Leave', Colors.blue),
                  const SizedBox(width: 8),
                  _buildStatCard('2', 'Late', Colors.orange),
                  const SizedBox(width: 8),
                  _buildStatCard('1', 'Half', Colors.orangeAccent),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Calendar Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  // Calendar Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                        DateFormat('MMMM yyyy').format(viewModel.currentMonth.value),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${viewModel.attendancePercentage} attendance',
                          style: const TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Days of week
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                        .map((day) => Expanded(
                              child: Center(
                                child: Text(day, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  
                  // Calendar Grid
                  Obx(() {
                    return _buildCalendarGrid(viewModel);
                  }),
                  
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFF0F0F0)),
                  const SizedBox(height: 8),
                  
                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLegendItem(Colors.green.shade100, 'Present'),
                      _buildLegendItem(Colors.red.shade100, 'Absent'),
                      _buildLegendItem(Colors.blue.shade100, 'Leave'),
                      _buildLegendItem(Colors.grey.shade100, 'Holiday'),
                      _buildLegendItem(Colors.orange.shade50, 'Half Day'),
                      _buildLegendItem(Colors.orange.shade100, 'Late'),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Recent History Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                    'Recent history (${viewModel.recentHistoryCount.value})',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(RoutesName.attendance_regularization_view);
                    },
                    child: const Text('Regularize', style: TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Recent History List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                if (viewModel.isLoading.value && viewModel.recentHistoryList.isEmpty) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ));
                }

                if (viewModel.recentHistoryList.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No recent history found', style: TextStyle(color: Colors.grey)),
                    ),
                  );
                }

                // Limiting to display a few recent items to maintain UI layout
                final displayList = viewModel.recentHistoryList.take(5).toList();

                return ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayList.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final record = displayList[index];
                    
                    DateTime dateObj = DateTime.now();
                    try {
                      dateObj = DateFormat('dd/MM/yyyy').parse(record.businessDate);
                    } catch (e) {
                      try {
                        dateObj = DateTime.parse(record.businessDate);
                      } catch (_) {}
                    }
                    
                    final dateStr = DateFormat('dd').format(dateObj);
                    final monthStr = DateFormat('MMM').format(dateObj).toUpperCase();
                    
                    String timeStr = '';
                    if (record.checkInAt != null && record.checkInAt!.isNotEmpty) {
                      timeStr += record.checkInAt!;
                    }
                    if (record.checkOutAt != null && record.checkOutAt!.isNotEmpty) {
                      timeStr += ' - ${record.checkOutAt!}';
                    }
                    
                    Color statusColor = Colors.green;
                    final statusLower = record.status.toLowerCase();
                    if (statusLower == 'absent') {
                      statusColor = Colors.red;
                    } else if (statusLower == 'late') {
                      statusColor = Colors.orange;
                    } else if (statusLower == 'leave') {
                      statusColor = Colors.blue;
                    } else if (statusLower == 'half day') {
                      statusColor = Colors.orangeAccent;
                    }

                    return _buildHistoryItem(
                      date: dateStr,
                      month: monthStr,
                      status: record.status.isNotEmpty 
                          ? '${record.status[0].toUpperCase()}${record.status.substring(1).toLowerCase()}'
                          : 'Unknown',
                      statusColor: statusColor,
                      time: timeStr,
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String count, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(count, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }

  Widget _buildHistoryItem({
    required String date,
    required String month,
    required String status,
    required Color statusColor,
    required String time,
  }) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RoutesName.attendance_regularization_view);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(month, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(status, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  if (time.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(AttendanceCalendarViewModel viewModel) {
    final now = viewModel.currentMonth.value;
    final firstDay = DateTime(now.year, now.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    
    // 1 = Monday, 7 = Sunday in DateTime.weekday
    final firstWeekday = firstDay.weekday; 
    
    List<Widget> gridItems = [];
    
    // Empty slots for previous month
    for (int i = 1; i < firstWeekday; i++) {
      gridItems.add(const SizedBox());
    }
    
    // Days of month
    for (int i = 1; i <= daysInMonth; i++) {
      final date = DateTime(now.year, now.month, i);
      final isSelected = viewModel.selectedDate.value.year == date.year &&
                         viewModel.selectedDate.value.month == date.month &&
                         viewModel.selectedDate.value.day == date.day;
                         
      // Mocking some colors for the visual based on the date
      Color bgColor = Colors.transparent;
      Color dotColor = Colors.transparent;
      
      if (i % 7 == 0 || i % 7 == 6) { // Weekend
        bgColor = const Color(0xFFF3F4F6); // Greyish
        dotColor = Colors.grey;
      } else if (i == 1 || i == 17) { // Absent/Leave
        bgColor = const Color(0xFFFEF2F2);
        dotColor = Colors.red;
      } else if (i == 3 || i == 9 || i == 19) { // Late/Half
        bgColor = const Color(0xFFFFF7ED);
        dotColor = Colors.orange;
      } else if (i == 11) { // Leave
        bgColor = const Color(0xFFEFF6FF);
        dotColor = Colors.blue;
      } else { // Present
        bgColor = const Color(0xFFF0FDF4);
        dotColor = Colors.green;
      }

      gridItems.add(
        GestureDetector(
          onTap: () {
            viewModel.selectDate(date);
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: isSelected ? Border.all(color: const Color(0xFF6366F1), width: 2) : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$i',
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: (i % 7 == 0 || i % 7 == 6) ? Colors.grey : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: gridItems,
    );
  }
}
