import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/colors/app_colors.dart';
import '../../domain/entities/outlet.dart';
import '../../routes/route_names.dart';

class InvoiceItem {
  final String id;
  final String date;
  final String amount;
  final double numericAmount;
  final String status;
  final IconData icon;
  final Color statusColor;
  final bool isPaid;
  bool isSelected;

  InvoiceItem({
    required this.id,
    required this.date,
    required this.amount,
    required this.numericAmount,
    required this.status,
    required this.icon,
    required this.statusColor,
    this.isPaid = false,
    this.isSelected = false,
  });
}

class VisitDetailsScreen extends StatefulWidget {
  const VisitDetailsScreen({super.key});

  @override
  State<VisitDetailsScreen> createState() => _VisitDetailsScreenState();
}

class _VisitDetailsScreenState extends State<VisitDetailsScreen> {
  int _selectedTabIndex = 0;
  bool _isSubmittingReceipt = false;

  final List<InvoiceItem> _invoices = [
    InvoiceItem(
      id: 'INV-5521',
      date: '02 Oct',
      amount: '₹11,00,000',
      numericAmount: 1100000,
      status: 'Overdue 12 days',
      icon: Icons.error_outline,
      statusColor: Colors.red,
      isSelected: true,
    ),
    InvoiceItem(
      id: 'INV-5522',
      date: '24 Oct',
      amount: '₹8,750',
      numericAmount: 8750,
      status: 'Due in 5 days',
      icon: Icons.receipt_long,
      statusColor: Colors.orange,
      isSelected: false,
    ),
    InvoiceItem(
      id: 'INV-5523',
      date: '28 Aug',
      amount: '₹15,200',
      numericAmount: 15200,
      status: 'Paid',
      icon: Icons.check,
      statusColor: Colors.green,
      isPaid: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final Outlet? outlet = Get.arguments as Outlet?;
    final String name = outlet?.firmName.isNotEmpty == true
        ? outlet!.firmName
        : (outlet != null
              ? '${outlet.firstName} ${outlet.lastName}'
              : 'ABC Distributors');
    final String location = outlet?.city.isNotEmpty == true
        ? outlet!.city
        : 'Vijay Nagar';
    final String owner = outlet != null
        ? '${outlet.firstName} ${outlet.lastName}'
        : 'Anil Bansal';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getAppBarTitle(),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              _getAppBarSubtitle(),
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: (_selectedTabIndex == 3 || _selectedTabIndex == 0)
                  ? 20
                  : 100, // Less bottom padding on Focus and Summary tabs
            ),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Profile Header Card
                _buildProfileCard(name, owner, location),
                const SizedBox(height: 16),

                // 2. Tabs Row
                _buildTabsRow(),
                const SizedBox(height: 16),

                // 3. Tab Content
                _buildTabContent(),
              ],
            ),
          ),

          // 4. Sticky Bottom Actions (Hide on Focus and Summary tabs)
          if (_selectedTabIndex != 3 && _selectedTabIndex != 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomActions(),
            ),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_selectedTabIndex) {
      case 1:
        return 'Orders';
      case 2:
        return 'Invoices';
      case 3:
        return 'Focus products';
      default:
        return 'Visit';
    }
  }

  String _getAppBarSubtitle() {
    switch (_selectedTabIndex) {
      case 1:
        return 'Track every order for this distributor';
      case 2:
        return 'Select invoices and record receipt';
      case 3:
        return 'Cases sold vs monthly target';
      default:
        return 'Checked in 02:12 PM · 01:59 p 1 of 3';
    }
  }

  Widget _buildProfileCard(String name, String owner, String location) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.domain,
              color: AppColors.primaryPurple,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$owner · $location',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9), // Light green bg
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.circle, color: Color(0xFF2E7D32), size: 6),
                      SizedBox(width: 4),
                      Text(
                        'Active',
                        style: TextStyle(
                          color: Color(0xFF2E7D32),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Actions
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  Get.toNamed(
                    RoutesName.edit_profile_view,
                    arguments: Get.arguments,
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: const Size(0, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  side: const BorderSide(color: AppColors.primaryPurple),
                  foregroundColor: AppColors.textPrimary,
                ),
                child: const Text(
                  'Edit profile',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryPurple),
                ),
                child: const Icon(
                  Icons.phone_outlined,
                  color: AppColors.primaryPurple,
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabsRow() {
    final tabs = ['Summary', 'Orders', 'Invoices', 'Focus'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final tab = tabs[index];
          final isSelected = _selectedTabIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryPurple : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryPurple, width: 1),
              ),
              child: Text(
                tab,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.primaryPurple,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildSummaryTab();
      case 1:
        return _buildOrdersTab();
      case 2:
        return _buildInvoicesTab();
      case 3:
        return _buildFocusTab();
      default:
        return const SizedBox.shrink();
    }
  }

  // ==========================================
  // TAB 0: SUMMARY TAB
  // ==========================================
  Widget _buildSummaryTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _buildOutstandingCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildTargetCard()),
          ],
        ),
        const SizedBox(height: 16),
        _buildOutstandingAgeingCard(),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildLastOrderCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildStockCoverCard()),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionBox(
                'Collect',
                Icons.account_balance_wallet_outlined,
                'Payment',
                'Record receipt',
                onTap: () => Get.toNamed(RoutesName.collect_payment_view),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionBox(
                'Return',
                Icons.keyboard_return,
                'Products',
                'Manage returns',
                onTap: () => Get.toNamed(RoutesName.sales_return_view),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionBox(
                'Survey',
                Icons.assignment_outlined,
                'Feedback',
                'Take survey',
                onTap: () => Get.toNamed(RoutesName.market_survey_view),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionBox(
                'More',
                Icons.more_horiz,
                'Options',
                'View more actions',
                onTap: () => Get.toNamed(RoutesName.visit_more_menu_view),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Suggested Next Step',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        _buildSuggestedSteps(),
      ],
    );
  }

  // ==========================================
  // TAB 1: ORDERS TAB
  // ==========================================
  Widget _buildOrdersTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Total order value banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryPurple,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total order value',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '₹26,52,400',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'orders',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '1 awaiting approval',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Filters
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildFilterChip('All', isSelected: true),
              _buildFilterChip('Awaiting', isSelected: false),
              _buildFilterChip('In transit', isSelected: false),
              _buildFilterChip('Delivered', isSelected: false),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Order List
        _buildOrderListItem(
          'ORD-2241',
          '18 Sep',
          '₹12,400',
          'Awaiting approval',
          Icons.access_time,
          Colors.orange,
        ),
        _buildOrderListItem(
          'ORD-2198',
          '10 Sep',
          '₹14,00,000',
          'Delivered',
          Icons.check,
          Colors.green,
        ),
        _buildOrderListItem(
          'ORD-2156',
          '2 Sep',
          '₹12,40,000',
          'In transit',
          Icons.local_shipping_outlined,
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, {required bool isSelected}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryPurple : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.primaryPurple : Colors.grey.shade300,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildOrderListItem(
    String orderId,
    String date,
    String amount,
    String status,
    IconData icon,
    Color statusColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: statusColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderId,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 2: INVOICES TAB
  // ==========================================
  Widget _buildInvoicesTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Outstanding',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '₹11,08,750',
                      style: TextStyle(
                        color: Color(0xFFD32F2F),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '2 invoices',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Paid',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '₹15,200',
                      style: TextStyle(
                        color: Color(0xFF2E7D32),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '1 invoice',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        ..._invoices.map((invoice) => _buildInvoiceListItem(invoice)),
      ],
    );
  }

  Widget _buildInvoiceListItem(InvoiceItem invoice) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          if (!invoice.isPaid)
            Checkbox(
              value: invoice.isSelected,
              onChanged: (val) {
                setState(() {
                  invoice.isSelected = val ?? false;
                });
              },
              activeColor: AppColors.primaryPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: SizedBox(width: 24), // Spacer to align
            ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: invoice.statusColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(invoice.icon, color: invoice.statusColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice.id,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  invoice.date,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                invoice.amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: invoice.statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (invoice.isPaid)
                      const Icon(Icons.check, size: 10, color: Colors.green),
                    if (invoice.isPaid) const SizedBox(width: 2),
                    Text(
                      invoice.status,
                      style: TextStyle(
                        color: invoice.statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 3: FOCUS TAB
  // ==========================================
  Widget _buildFocusTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryPurple,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: 0.74,
                      strokeWidth: 6,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                    const Center(
                      child: Text(
                        '74%',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Focus products this month',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '1110 / 1510 cases',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '1 of 4 targets achieved',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Product targets',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFocusProductCard(
                'Engine oil 20W40',
                '420 / 600',
                0.7,
                'Needs push',
                Colors.orange,
                '180 to go',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFocusProductCard(
                'Brake pad set',
                '310 / 300',
                1.03,
                'Achieved',
                Colors.green,
                '+10 over',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFocusProductCard(
                'Air filter',
                '150 / 350',
                0.43,
                'Behind',
                Colors.red,
                '200 to go',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFocusProductCard(
                'Coolant 5L',
                '230 / 260',
                0.88,
                'On track',
                AppColors.primaryPurple,
                '30 to go',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFocusProductCard(
    String name,
    String cases,
    double progress,
    String status,
    Color color,
    String remaining,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.star_border,
                      color: AppColors.primaryPurple,
                      size: 10,
                    ),
                    SizedBox(width: 2),
                    Text(
                      'FOCUS',
                      style: TextStyle(
                        color: AppColors.primaryPurple,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Icon(
                  Icons.inventory_2_outlined,
                  color: AppColors.primaryPurple,
                  size: 28,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress > 1.0 ? 1.0 : progress,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$cases cases',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                remaining,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SHARED & BOTTOM ACTIONS
  // ==========================================

  Widget _buildOutstandingCard() {
    return _buildBaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: AppColors.primaryPurple,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Outstanding',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Overdue ₹11,00,000',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '₹48,00,000',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Container(
                height: 4,
                width: 100, // Roughly 80% visually in a smaller card
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            '80% of ₹60,00,000 limit',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetCard() {
    return _buildBaseCard(
      child: Column(
        children: [
          const Text(
            'Target vs achieved',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: 0.86,
                  strokeWidth: 8,
                  backgroundColor: AppColors.primaryPurple.withValues(
                    alpha: 0.2,
                  ),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primaryPurple,
                  ),
                ),
              ),
              const Text(
                '86%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '₹19.2 Cr / ₹24 Cr',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildOutstandingAgeingCard() {
    return _buildBaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Outstanding ageing',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildAgeingRow('0-7 days', '₹45,000', 0.4, const Color(0xFF00B050)),
          const SizedBox(height: 12),
          _buildAgeingRow('8-15 days', '₹21,150', 0.2, Colors.orange),
          const SizedBox(height: 12),
          _buildAgeingRow('16-30 days', '₹14,100', 0.15, Colors.orange),
          const SizedBox(height: 12),
          _buildAgeingRow('30+ days', '₹8,000', 0.1, Colors.red),
        ],
      ),
    );
  }

  Widget _buildAgeingRow(
    String label,
    String amount,
    double percent,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Stack(
          children: [
            Container(
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: 6,
                  width: constraints.maxWidth * percent,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLastOrderCard() {
    return _buildBaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(
                child: Text(
                  'Last order',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.trending_up, color: AppColors.primaryPurple, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '₹12,40,000',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '28 Sep · In transit',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStockCoverCard() {
    return _buildBaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(
                child: Text(
                  'Stock cover',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.bar_chart, color: Colors.green, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '9 days',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Norm 12 to 18',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBox(
    String title,
    IconData icon,
    String mainText,
    String subText, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: _buildBaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: AppColors.primaryPurple, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            mainText,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            subText,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ));
  }

  Widget _buildSuggestedSteps() {
    final steps = [
      'Collect ₹11,00,000 Overdue Before New Order',
      'Air Filter And Engine Oil Are Low, Push Focus Order',
      'Run Survey On Competitor Schemes',
    ];

    return Column(
      children: steps.map((step) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '• ',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Text(
                  step,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(child: _getBottomContent()),
    );
  }

  Widget _getBottomContent() {
    if (_selectedTabIndex == 1) {
      // Orders
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            Get.toNamed(RoutesName.order_view);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Add Order',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (_selectedTabIndex == 2) {
      // Invoices
      final selectedInvoices = _invoices
          .where((i) => i.isSelected && !i.isPaid)
          .toList();
      final selectedCount = selectedInvoices.length;
      final totalAmount = selectedInvoices.fold<double>(
        0,
        (sum, i) => sum + i.numericAmount,
      );

      final currencyFormatter = NumberFormat.currency(
        locale: 'en_IN',
        symbol: '₹',
        decimalDigits: 0,
      );

      return Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$selectedCount invoice${selectedCount == 1 ? '' : 's'} selected',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                Text(
                  currencyFormatter.format(totalAmount),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _isSubmittingReceipt
                  ? null
                  : () async {
                      if (selectedCount == 0) {
                        Get.snackbar(
                          'Validation',
                          'Please select at least one invoice to record a receipt.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red.shade50,
                          colorText: Colors.red.shade900,
                          margin: const EdgeInsets.all(16),
                        );
                        return;
                      }

                      setState(() => _isSubmittingReceipt = true);

                      // Simulate API call processing
                      await Future.delayed(const Duration(seconds: 2));

                      if (mounted) {
                        setState(() {
                          _isSubmittingReceipt = false;
                          for (var invoice in selectedInvoices) {
                            invoice.isSelected = false;
                          }
                        });
                        Get.snackbar(
                          'Success',
                          'Receipt recorded successfully for $selectedCount invoice${selectedCount == 1 ? '' : 's'}.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green.shade50,
                          colorText: Colors.green.shade900,
                          margin: const EdgeInsets.all(16),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isSubmittingReceipt
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      children: const [
                        Icon(Icons.receipt_long, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Record receipt',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      );
    } else {
      // Summary
      return const SizedBox.shrink();
    }
  }

  Widget _buildBaseCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }
}
