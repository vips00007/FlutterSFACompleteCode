import '../../models/reports_models.dart';

class ReportsApiService {
  Future<ReportsData> getReportsData(String timeRange) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Returning data exactly matching the screenshot to populate the UI correctly.
    return ReportsData(
      salesData: SalesData(
        salesAmount: 184000,
        targetAmount: 250000,
        ordersCount: 32,
        lastMonthOrders: 38,
        targetAchievementPct: 73.6,
        achievedAmount: 184000,
        remainingAmount: 66000,
        dailySales: [
          DailyMetric(dayName: 'M', label: '₹45K', value: 45, isHighlight: false),
          DailyMetric(dayName: 'T', label: '₹62K', value: 62, isHighlight: false),
          DailyMetric(dayName: 'W', label: '₹38K', value: 38, isHighlight: false),
          DailyMetric(dayName: 'T', label: '₹71K', value: 71, isHighlight: false),
          DailyMetric(dayName: 'F', label: '₹55K', value: 55, isHighlight: false),
          DailyMetric(dayName: 'S', label: '₹83K', value: 83, isHighlight: false),
          DailyMetric(dayName: 'S', label: '₹74K', value: 74, isHighlight: true),
        ],
        topProducts: [
          TopProduct(name: 'Fortune Atta 10kg', amount: 48400, percentage: 1.0),
          TopProduct(name: 'Saffola Oil 5L', amount: 36200, percentage: 0.75),
          TopProduct(name: 'India Gate Rice 5kg', amount: 29800, percentage: 0.60),
          TopProduct(name: 'Tata Tea 500g', amount: 22400, percentage: 0.45),
        ],
      ),
      visitsData: VisitsData(
        salesAmount: 184000,
        targetAmount: 250000,
        ordersCount: 32,
        lastMonthOrders: 38,
        visitCompletionPct: 73.6,
        dailyVisits: [
          DailyMetric(dayName: 'M', label: '₹45K', value: 45, isHighlight: false),
          DailyMetric(dayName: 'T', label: '₹62K', value: 62, isHighlight: false),
          DailyMetric(dayName: 'W', label: '₹38K', value: 38, isHighlight: false),
          DailyMetric(dayName: 'T', label: '₹71K', value: 71, isHighlight: false),
          DailyMetric(dayName: 'F', label: '₹55K', value: 55, isHighlight: false),
          DailyMetric(dayName: 'S', label: '₹83K', value: 83, isHighlight: false),
          DailyMetric(dayName: 'S', label: '₹74K', value: 74, isHighlight: true),
        ],
        breakdowns: [
          VisitBreakdown(title: 'Productive Visits', percentage: 83.0, count: 10),
          VisitBreakdown(title: 'Order Placed', percentage: 67.0, count: 8),
          VisitBreakdown(title: 'Payment Collected', percentage: 42.0, count: 5),
          VisitBreakdown(title: 'Skipped', percentage: 17.0, count: 2),
        ],
      ),
      collectionsData: CollectionsData(
        outstandingAmount: 69000,
        collectionsPending: 17000,
        collectionRatePct: 41.0,
        collectedAmount: 62400,
        totalToCollect: 150650,
        collectionBuckets: [
          CollectionBucket(durationLabel: '0–7 days', amount: 45000, percentage: 0.65),
          CollectionBucket(durationLabel: '8–15 days', amount: 21150, percentage: 0.30),
          CollectionBucket(durationLabel: '16–30 days', amount: 14100, percentage: 0.20),
          CollectionBucket(durationLabel: '30+ days', amount: 8000, percentage: 0.10),
        ],
      ),
    );
  }
}
