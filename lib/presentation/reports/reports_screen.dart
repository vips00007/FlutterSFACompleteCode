import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'reports_viewmodel.dart';
import '../../data/models/reports_models.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  static const Color primaryPurple = Color(0xFF8A2BE2);
  static const Color primaryGreen = Color(0xFF00A86B);

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<ReportsViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: SafeArea(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Get.back(),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reports',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Record payment against outstanding',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // 1. Time Range Selector
          _buildTimeRangeSelector(viewModel),

          // 2. Tab Bar Selector
          _buildTabBarSelector(viewModel),

          // 3. Tab Content View
          Expanded(
            child: Obx(() {
              if (viewModel.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: primaryPurple),
                );
              }

              if (viewModel.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        viewModel.errorMessage.value,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: viewModel.fetchReportsData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final data = viewModel.reportsData.value;
              if (data == null) {
                return const Center(child: Text('No reports data available'));
              }

              switch (viewModel.selectedTabIndex.value) {
                case 0:
                  return _buildSalesTabContent(data.salesData);
                case 1:
                  return _buildVisitsTabContent(data.visitsData);
                case 2:
                  return _buildCollectionsTabContent(data.collectionsData);
                default:
                  return _buildSalesTabContent(data.salesData);
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector(ReportsViewModel viewModel) {
    final ranges = ['Today', 'This Week', 'This Month'];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Obx(
          () => Row(
            children: ranges.map((range) {
              final isSelected = viewModel.selectedTimeRange.value == range;
              return Expanded(
                child: GestureDetector(
                  onTap: () => viewModel.selectTimeRange(range),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      range,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.black87 : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBarSelector(ReportsViewModel viewModel) {
    final tabs = [
      {'label': 'Sales', 'icon': Icons.trending_up},
      {'label': 'Visits', 'icon': Icons.location_on_outlined},
      {'label': 'Collections', 'icon': Icons.attach_money},
    ];

    return Container(
      color: const Color(0xFFF6F3FB),
      child: Obx(
        () => Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = viewModel.selectedTabIndex.value == index;
            final item = tabs[index];
            return Expanded(
              child: GestureDetector(
                onTap: () => viewModel.selectTab(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isSelected ? primaryPurple : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        size: 16,
                        color: isSelected ? primaryPurple : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          item['label'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? primaryPurple : Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // --- SALES TAB CONTENT ---
  Widget _buildSalesTabContent(SalesData salesData) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 1. Stat Cards Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Sales',
                  value: '₹${_formatAmount(salesData.salesAmount)}',
                  subtitle: 'vs ₹${_formatAmount(salesData.targetAmount)} target',
                  icon: Icons.trending_up,
                  iconColor: primaryPurple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: 'Orders',
                  value: '${salesData.ordersCount}',
                  subtitle: 'vs ${salesData.lastMonthOrders} last month',
                  icon: Icons.bar_chart,
                  iconColor: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 2. Target Achievement Card
          _buildCardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Target Achievement',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${salesData.targetAchievementPct}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD97706),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (salesData.targetAchievementPct / 100).clamp(0.0, 1.0),
                    backgroundColor: const Color(0xFFF3F4F6),
                    valueColor: const AlwaysStoppedAnimation<Color>(primaryPurple),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${_formatAmount(salesData.achievedAmount)} achieved',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                    Text(
                      '₹${_formatAmount(salesData.remainingAmount)} remaining',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. Daily Sales Chart (This Week)
          _buildDailySalesChartCard(
            title: 'Daily Sales (This Week)',
            metrics: salesData.dailySales,
            activeColor: primaryPurple,
          ),
          const SizedBox(height: 16),

          // 4. Top Products Card
          _buildCardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Top Products',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                ...salesData.topProducts.map(
                  (product) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '₹${_formatAmount(product.amount)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: product.percentage.clamp(0.0, 1.0),
                            backgroundColor: const Color(0xFFF3F4F6),
                            valueColor: const AlwaysStoppedAnimation<Color>(primaryPurple),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- VISITS TAB CONTENT ---
  Widget _buildVisitsTabContent(VisitsData visitsData) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 1. Stat Cards Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Sales',
                  value: '₹${_formatAmount(visitsData.salesAmount)}',
                  subtitle: 'vs ₹${_formatAmount(visitsData.targetAmount)} target',
                  icon: Icons.trending_up,
                  iconColor: primaryPurple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: 'Orders',
                  value: '${visitsData.ordersCount}',
                  subtitle: 'vs ${visitsData.lastMonthOrders} last month',
                  icon: Icons.bar_chart,
                  iconColor: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 2. Visit Completion Card
          _buildCardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Visit Completion',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${visitsData.visitCompletionPct}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD97706),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (visitsData.visitCompletionPct / 100).clamp(0.0, 1.0),
                    backgroundColor: const Color(0xFFF3F4F6),
                    valueColor: const AlwaysStoppedAnimation<Color>(primaryGreen),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. Daily Sales Chart (Green style for Visits tab)
          _buildDailySalesChartCard(
            title: 'Daily Sales (This Week)',
            metrics: visitsData.dailyVisits,
            activeColor: primaryGreen,
          ),
          const SizedBox(height: 16),

          // 4. Breakdown Card
          _buildCardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Breakdown',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                ...visitsData.breakdowns.map((item) {
                  Color pctColor;
                  if (item.percentage >= 80) {
                    pctColor = const Color(0xFF00A86B);
                  } else if (item.percentage >= 60) {
                    pctColor = const Color(0xFF4F46E5);
                  } else if (item.percentage >= 30) {
                    pctColor = const Color(0xFFD97706);
                  } else {
                    pctColor = const Color(0xFFDC2626);
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${item.percentage.toInt()}%',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: pctColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${item.count}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- COLLECTIONS TAB CONTENT ---
  Widget _buildCollectionsTabContent(CollectionsData collectionsData) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 1. Stat Cards Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Outstanding',
                  value: '₹${_formatAmount(collectionsData.outstandingAmount)}',
                  subtitle: '',
                  icon: Icons.trending_up,
                  iconColor: primaryPurple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: 'Collections pending',
                  value: '₹${_formatAmount(collectionsData.collectionsPending)}',
                  subtitle: '',
                  icon: Icons.bar_chart,
                  iconColor: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 2. Collection Rate Card
          _buildCardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Collection Rate',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '${collectionsData.collectionRatePct.toInt()}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${_formatAmount(collectionsData.collectedAmount)} of ₹${_formatAmount(collectionsData.totalToCollect)}',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (collectionsData.collectionRatePct / 100).clamp(0.0, 1.0),
                    backgroundColor: const Color(0xFFF3F4F6),
                    valueColor: const AlwaysStoppedAnimation<Color>(primaryGreen),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. Avg. Collections Days Card
          _buildCardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Avg.Collections Days',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                ...collectionsData.collectionBuckets.map((bucket) {
                  Color bucketColor;
                  if (bucket.durationLabel.contains('0–7')) {
                    bucketColor = const Color(0xFF00A86B);
                  } else if (bucket.durationLabel.contains('8–15')) {
                    bucketColor = const Color(0xFFD97706);
                  } else if (bucket.durationLabel.contains('16–30')) {
                    bucketColor = const Color(0xFFEA580C);
                  } else {
                    bucketColor = const Color(0xFFDC2626);
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              bucket.durationLabel,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              '₹${_formatAmount(bucket.amount)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: bucketColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: bucket.percentage.clamp(0.0, 1.0),
                            backgroundColor: const Color(0xFFF3F4F6),
                            valueColor: AlwaysStoppedAnimation<Color>(bucketColor),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- REUSABLE UI WIDGETS ---
  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDailySalesChartCard({
    required String title,
    required List<DailyMetric> metrics,
    required Color activeColor,
  }) {
    final maxVal = metrics.fold<double>(1.0, (max, e) => e.value > max ? e.value : max);

    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 130,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: metrics.map((item) {
                final heightRatio = (item.value / maxVal).clamp(0.2, 1.0);
                final barHeight = 80 * heightRatio;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 11,
                        color: item.isHighlight ? activeColor : Colors.grey.shade500,
                        fontWeight: item.isHighlight ? FontWeight.bold : FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 36,
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: item.isHighlight ? activeColor : const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.dayName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: item.isHighlight ? FontWeight.bold : FontWeight.w500,
                        color: item.isHighlight ? activeColor : Colors.grey.shade600,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  String _formatAmount(double amount) {
    final intVal = amount.toInt();
    final str = intVal.toString();
    if (str.length <= 3) return str;

    final lastThree = str.substring(str.length - 3);
    final otherNumbers = str.substring(0, str.length - 3);
    final formattedOther = otherNumbers.replaceAllRegExp(RegExp(r'\B(?=(\d{2})+(?!\d))'), ',');
    return '$formattedOther,$lastThree';
  }
}

extension RegExpReplace on String {
  String replaceAllRegExp(RegExp regExp, String replacement) {
    return replaceAllMapped(regExp, (match) => replacement);
  }
}
