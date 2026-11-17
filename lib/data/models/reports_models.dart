class ReportsData {
  final SalesData salesData;
  final VisitsData visitsData;
  final CollectionsData collectionsData;

  ReportsData({
    required this.salesData,
    required this.visitsData,
    required this.collectionsData,
  });
}

class SalesData {
  final double salesAmount;
  final double targetAmount;
  final int ordersCount;
  final int lastMonthOrders;
  final double targetAchievementPct;
  final double achievedAmount;
  final double remainingAmount;
  final List<DailyMetric> dailySales;
  final List<TopProduct> topProducts;

  SalesData({
    required this.salesAmount,
    required this.targetAmount,
    required this.ordersCount,
    required this.lastMonthOrders,
    required this.targetAchievementPct,
    required this.achievedAmount,
    required this.remainingAmount,
    required this.dailySales,
    required this.topProducts,
  });
}

class VisitsData {
  final double salesAmount;
  final double targetAmount;
  final int ordersCount;
  final int lastMonthOrders;
  final double visitCompletionPct;
  final List<DailyMetric> dailyVisits;
  final List<VisitBreakdown> breakdowns;

  VisitsData({
    required this.salesAmount,
    required this.targetAmount,
    required this.ordersCount,
    required this.lastMonthOrders,
    required this.visitCompletionPct,
    required this.dailyVisits,
    required this.breakdowns,
  });
}

class CollectionsData {
  final double outstandingAmount;
  final double collectionsPending;
  final double collectionRatePct;
  final double collectedAmount;
  final double totalToCollect;
  final List<CollectionBucket> collectionBuckets;

  CollectionsData({
    required this.outstandingAmount,
    required this.collectionsPending,
    required this.collectionRatePct,
    required this.collectedAmount,
    required this.totalToCollect,
    required this.collectionBuckets,
  });
}

class DailyMetric {
  final String dayName;
  final String label;
  final double value;
  final bool isHighlight;

  DailyMetric({
    required this.dayName,
    required this.label,
    required this.value,
    required this.isHighlight,
  });
}

class TopProduct {
  final String name;
  final double amount;
  final double percentage; // for the bar width

  TopProduct({
    required this.name,
    required this.amount,
    required this.percentage,
  });
}

class VisitBreakdown {
  final String title;
  final double percentage;
  final int count;

  VisitBreakdown({
    required this.title,
    required this.percentage,
    required this.count,
  });
}

class CollectionBucket {
  final String durationLabel;
  final double amount;
  final double percentage;

  CollectionBucket({
    required this.durationLabel,
    required this.amount,
    required this.percentage,
  });
}
