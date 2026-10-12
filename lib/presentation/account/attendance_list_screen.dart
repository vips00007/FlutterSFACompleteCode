import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/colors/app_colors.dart';
import 'attendance_viewmodel.dart';
import '../../data/repositories/attendance_repository_impl.dart';
import '../../data/datasource/remote/attendance_api_service.dart';

class AttendanceListScreen extends StatefulWidget {
  const AttendanceListScreen({super.key});

  @override
  State<AttendanceListScreen> createState() => _AttendanceListScreenState();
}

class _AttendanceListScreenState extends State<AttendanceListScreen> {
  late final AttendanceViewModel viewModel;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Ensure dependencies are injected, or instantiate manually for now
    if (Get.isRegistered<AttendanceViewModel>()) {
      viewModel = Get.find<AttendanceViewModel>();
    } else {
      // Setup minimal DI
      final apiService = AttendanceApiService();
      final repository = AttendanceRepositoryImpl(apiService);
      viewModel = Get.put(AttendanceViewModel(repository));
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      viewModel.fetchHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            const Text(
              'Attendance',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 8),
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${viewModel.totalElements}',
                  style: TextStyle(
                    color: Colors.teal.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(color: AppColors.sfaBlue, height: 2),
        ),
      ),
      body: Obx(() {
        if (viewModel.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  viewModel.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => viewModel.fetchHistory(isRefresh: true),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (viewModel.attendanceRecords.isEmpty) {
          return const Center(
            child: Text(
              'No attendance records found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => viewModel.fetchHistory(isRefresh: true),
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount:
                viewModel.attendanceRecords.length +
                (viewModel.hasMoreData ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == viewModel.attendanceRecords.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final record = viewModel.attendanceRecords[index];
              return _buildAttendanceCard(record);
            },
          ),
        );
      }),
    );
  }

  Widget _buildAttendanceCard(AttendanceRecord record) {
    final statusColor = record.isPresent ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          record.date,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            record.status,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => _buildLogItem(
                        icon: Icons.login_rounded,
                        iconColor: Colors.green,
                        time: record.checkInTime,
                        location: record.checkInLocation.value,
                        photoUrl: record.photoUrl,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => _buildLogItem(
                        icon: Icons.logout_rounded,
                        iconColor: Colors.red,
                        time: record.checkOutTime,
                        location: record.checkOutLocation.value,
                      ),
                    ),
                    if (record.duration.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Colors.grey,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            record.duration,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogItem({
    required IconData icon,
    required Color iconColor,
    required String time,
    required String location,
    String? photoUrl,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 8),
        Text(
          time,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            location,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (photoUrl != null) ...[
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade200,
            ),
            child: const Icon(Icons.image, color: Colors.grey, size: 20),
          ),
        ],
      ],
    );
  }
}
