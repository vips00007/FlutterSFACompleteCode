import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/colors/app_colors.dart';
import 'my_performance_viewmodel.dart';

class MyPerformanceScreen extends StatelessWidget {
  const MyPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<MyPerformanceViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'My Performance',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: AppColors.sfaBlue.withValues(alpha: 0.2),
            height: 1,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text(
              'Your performance summary',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: viewModel.performanceMetrics.length,
                itemBuilder: (context, index) {
                  final metric = viewModel.performanceMetrics[index];
                  return _buildPerformanceCard(metric);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(PerformanceMetric metric) {
    Color iconBgColor;
    Color iconColor;
    IconData iconData;

    switch (metric.type) {
      case MetricType.visits:
      case MetricType.adherence:
      case MetricType.visitsWeek:
        iconBgColor = const Color(0xFFFFF7E6);
        iconColor = const Color(0xFFFAAD14);
        iconData = metric.type == MetricType.visits
            ? Icons.storefront
            : (metric.type == MetricType.adherence
                  ? Icons.calendar_today_outlined
                  : Icons.speed);
        break;
      case MetricType.conversion:
      case MetricType.orderValue:
      case MetricType.topCustomer:
        iconBgColor = const Color(0xFFF6FFED);
        iconColor = const Color(0xFF52C41A);
        iconData = metric.type == MetricType.conversion
            ? Icons.trending_up
            : (metric.type == MetricType.orderValue
                  ? Icons.currency_rupee
                  : Icons.star_border);
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(iconData, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      metric.title,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      metric.value,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (metric.trend.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: metric.isPositiveTrend
                        ? const Color(0xFFF6FFED)
                        : const Color(0xFFFFF1F0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        metric.isPositiveTrend
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: metric.isPositiveTrend
                            ? const Color(0xFF52C41A)
                            : const Color(0xFFFF4D4F),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        metric.trend.replaceAll('-', '').replaceAll('+', ''),
                        style: TextStyle(
                          color: metric.isPositiveTrend
                              ? const Color(0xFF52C41A)
                              : const Color(0xFFFF4D4F),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            metric.comparisonText,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
