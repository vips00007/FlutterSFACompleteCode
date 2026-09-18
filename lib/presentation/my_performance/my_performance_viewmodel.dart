import 'package:get/get.dart';

class MyPerformanceViewModel extends GetxController {
  final performanceMetrics = <PerformanceMetric>[
    PerformanceMetric(
      title: 'Visits This Month',
      value: '1',
      trend: '-75%',
      isPositiveTrend: false,
      comparisonText: '-75% vs last month (4)',
      type: MetricType.visits,
    ),
    PerformanceMetric(
      title: 'Conversion Rate',
      value: '100%',
      trend: '',
      isPositiveTrend: true,
      comparisonText: '1 of 1 visits resulted in an order this month',
      type: MetricType.conversion,
    ),
    PerformanceMetric(
      title: 'Plan Adherence',
      value: '0%',
      trend: '',
      isPositiveTrend: false,
      comparisonText: '0 of 1 visits this month were planned',
      type: MetricType.adherence,
    ),
    PerformanceMetric(
      title: 'Visits This Week',
      value: '0',
      trend: '-100%',
      isPositiveTrend: false,
      comparisonText: '-100% vs last week (1)',
      type: MetricType.visitsWeek,
    ),
    PerformanceMetric(
      title: 'Avg Order Value',
      value: '₹7.4K',
      trend: '+27%',
      isPositiveTrend: true,
      comparisonText: '+27% vs last month',
      type: MetricType.orderValue,
    ),
    PerformanceMetric(
      title: 'Top Customer',
      value: 'N/A',
      trend: '',
      isPositiveTrend: true,
      comparisonText: 'Highest contributing customer',
      type: MetricType.topCustomer,
    ),
  ].obs;
}

enum MetricType {
  visits,
  conversion,
  adherence,
  visitsWeek,
  orderValue,
  topCustomer,
}

class PerformanceMetric {
  final String title;
  final String value;
  final String trend;
  final bool isPositiveTrend;
  final String comparisonText;
  final MetricType type;

  PerformanceMetric({
    required this.title,
    required this.value,
    required this.trend,
    required this.isPositiveTrend,
    required this.comparisonText,
    required this.type,
  });
}
