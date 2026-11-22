import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/datasource/remote/visit_plans_api_service.dart';

/// Zone Info Mapping matching the HTML Prototype
const Map<String, List<String>> Z = {
  'L1': ['Arera Colony', 'Bhopal', 'Local'],
  'L2': ['MP Nagar', 'Bhopal', 'Local'],
  'L3': ['Kolar Road', 'Bhopal', 'Local'],
  'U1': ['Indore Territory', 'Indore', 'Upcountry'],
  'U2': ['Jabalpur Territory', 'Jabalpur', 'Upcountry'],
  'U3': ['Sagar Territory', 'Sagar', 'Upcountry'],
};

/// Customer Type Labels matching the HTML Prototype
const Map<String, String> TN = {
  'D': 'Distributor',
  'R': 'Retailer',
  'M': 'Mechanic',
};

/// Prototype Customer Model
class PrototypeCustomer {
  final int id;
  final String zone;
  final String type; // 'D', 'R', 'M'
  final String name;
  final String owner;
  final String phone;
  final String addr;

  PrototypeCustomer({
    required this.id,
    required this.zone,
    required this.type,
    required this.name,
    required this.owner,
    required this.phone,
    required this.addr,
  });
}

/// Prototype Plan Model
class PrototypePlan {
  final String ref;
  final String mode; // 'Local' or 'Upcountry'
  final String zone;
  final String from;
  final String to;
  final List<int> cust;
  final String status; // 'Approved', 'Pending', 'Rejected'
  final String? remark;

  PrototypePlan({
    required this.ref,
    required this.mode,
    required this.zone,
    required this.from,
    required this.to,
    required this.cust,
    required this.status,
    this.remark,
  });
}

class CreatePlanViewModel extends GetxController {
  final VisitPlansApiService _apiService = Get.isRegistered<VisitPlansApiService>()
      ? Get.find<VisitPlansApiService>()
      : VisitPlansApiService();

  // Screen View State: 'list', 'create', 'detail'
  final currentScreen = 'list'.obs;

  // My Plan Tab Filter State: 'All', 'Pending', 'Approved', 'Rejected'
  final currentFilter = 'All'.obs;

  // Active Plan Detail Reference ID
  final openPlanRef = ''.obs;

  // Create Plan Form State
  final currentMode = 'Local'.obs; // 'Local' or 'Upcountry'
  final currentZone = ''.obs;
  final d1 = ''.obs; // Visit date / From date
  final d2 = ''.obs; // To date (Upcountry)
  final currentTypeFilter = 'All'.obs; // 'All', 'D', 'R', 'M'
  final searchQuery = ''.obs;
  final selectedCustomerIds = <int>{}.obs;

  // Reactive Plan List & Customer List
  final plans = <PrototypePlan>[].obs;
  final customers = <PrototypeCustomer>[].obs;

  // Loading & Error States for API integration
  final isLoading = false.obs;
  final isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    d1.value = today;
    d2.value = today;

    _loadPrototypeMasterData();
    fetchMyVisitsFromApi();
  }

  void _loadPrototypeMasterData() {
    // Populate prototype customer list
    final List<PrototypeCustomer> initialCustList = [
      ['L1', 'D', 'Shree Balaji Distributors', 'Rakesh Jain'],
      ['L1', 'R', 'Arera Hardware Mart', 'Sunil Verma'],
      ['L1', 'M', 'Imran Auto Works', 'Imran Khan'],
      ['L1', 'R', 'Ganesh General Store', 'Ganesh Patel'],
      ['L2', 'D', 'Narmada Traders', 'Anil Sharma'],
      ['L2', 'R', 'MP Nagar Motors', 'Deepak Rao'],
      ['L2', 'M', 'Raju Garage', 'Raju Yadav'],
      ['L2', 'R', 'City Spares Point', 'Vikas Mehta'],
      ['L3', 'D', 'Kolar Agencies', 'Manoj Gupta'],
      ['L3', 'R', 'Singh Tyre House', 'Harpal Singh'],
      ['L3', 'M', 'Salim Mechanic Shop', 'Salim Ansari'],
      ['L3', 'R', 'Om Auto Parts', 'Ravi Tiwari'],
      ['U1', 'D', 'Malwa Distribution Co.', 'Pankaj Joshi'],
      ['U1', 'R', 'Rajwada Retail', 'Nitin Soni'],
      ['U1', 'M', 'Vijay Nagar Garage', 'Vijay Chouhan'],
      ['U1', 'R', 'Palasia Auto Hub', 'Kamal Bhatia'],
      ['U2', 'D', 'Mahakoshal Traders', 'Sanjay Dubey'],
      ['U2', 'R', 'Napier Town Motors', 'Alok Mishra'],
      ['U2', 'M', 'Gorakhpur Workshop', 'Pappu Kewat'],
      ['U2', 'R', 'Wright Town Spares', 'Neeraj Jain'],
      ['U3', 'D', 'Bundelkhand Suppliers', 'Rohit Rathore'],
      ['U3', 'R', 'Civil Lines Autos', 'Arun Lodhi'],
      ['U3', 'M', 'Makronia Garage', 'Shyam Ahirwar'],
      ['U3', 'R', 'Sagar Wheel Centre', 'Yogesh Patel'],
    ].asMap().entries.map((entry) {
      final i = entry.key;
      final c = entry.value;
      final zoneKey = c[0];
      final zoneInfo = Z[zoneKey]!;
      return PrototypeCustomer(
        id: i + 1,
        zone: c[0],
        type: c[1],
        name: c[2],
        owner: c[3],
        phone: '+91 9${(8100000000 + i * 7391337).toString().substring(0, 9)}',
        addr: 'Shop ${10 + i * 3}, ${zoneInfo[0]}, ${zoneInfo[1]}, MP',
      );
    }).toList();

    customers.assignAll(initialCustList);

    // Populate initial prototype plans
    final List<PrototypePlan> initialPlansList = [
      PrototypePlan(
        ref: 'PLN-000001',
        mode: 'Local',
        zone: 'L1',
        from: '2026-11-21',
        to: '2026-11-21',
        cust: [1, 2],
        status: 'Approved',
      ),
      PrototypePlan(
        ref: 'PLN-000002',
        mode: 'Upcountry',
        zone: 'U1',
        from: '2026-11-24',
        to: '2026-11-26',
        cust: [13, 14],
        status: 'Pending',
      ),
      PrototypePlan(
        ref: 'PLN-000003',
        mode: 'Local',
        zone: 'L3',
        from: '2026-11-18',
        to: '2026-11-18',
        cust: [9, 10],
        status: 'Rejected',
        remark: 'Beat overlaps with another approved plan. Please re-plan.',
      ),
    ];

    plans.assignAll(initialPlansList);
  }

  // Fetch plans from backend API if available and merge into plans list
  Future<void> fetchMyVisitsFromApi() async {
    try {
      final response = await _apiService.getMyVisits(scope: 'MINE', page: 0, size: 20);
      if (response.data != null && response.data!.content.isNotEmpty) {
        final visitItems = response.data!.content;
        final Map<String, List<dynamic>> grouped = {};
        for (final item in visitItems) {
          final pUuid = (item.planUuid != null && item.planUuid!.isNotEmpty)
              ? item.planUuid!
              : (item.uuid != null && item.uuid!.isNotEmpty ? item.uuid! : 'UNPLANNED');
          grouped.putIfAbsent(pUuid, () => []).add(item);
        }

        final List<PrototypePlan> apiPlans = [];
        grouped.forEach((pUuid, visits) {
          final first = visits.first;
          final String rawStatus = (first.status ?? 'PENDING').toUpperCase();
          String mappedStatus = 'Pending';
          if (rawStatus == 'APPROVED' || rawStatus == 'COMPLETED') {
            mappedStatus = 'Approved';
          } else if (rawStatus == 'REJECTED' || rawStatus == 'MISSED') {
            mappedStatus = 'Rejected';
          }

          final String rawType = (first.planType ?? 'LOCAL').toUpperCase();
          final String mode = (rawType == 'OUTSTATION' || rawType == 'UPCOUNTRY') ? 'Upcountry' : 'Local';
          final String displayRef = pUuid.length > 8 ? 'PLN-${pUuid.substring(0, 6).toUpperCase()}' : 'PLN-$pUuid';

          // Pick zone or default to L1/U1
          final String defaultZone = mode == 'Local' ? 'L1' : 'U1';

          apiPlans.add(PrototypePlan(
            ref: displayRef,
            mode: mode,
            zone: defaultZone,
            from: first.planFromDate ?? first.date ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
            to: first.planToDate ?? first.date ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
            cust: [1, 2], // Default customer map reference
            status: mappedStatus,
          ));
        });

        if (apiPlans.isNotEmpty) {
          // Merge API plans without duplicating refs
          final existingRefs = plans.map((p) => p.ref).toSet();
          for (final ap in apiPlans) {
            if (!existingRefs.contains(ap.ref)) {
              plans.insert(0, ap);
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("API fetch MyVisits fallback to local prototype data: $e");
      }
    }
  }

  // Navigation controller
  void go(String screen, {String? openRef}) {
    currentScreen.value = screen;
    if (openRef != null) {
      openPlanRef.value = openRef;
    }
  }

  // Reset Create Plan Form state
  void newPlan() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    currentMode.value = 'Local';
    currentZone.value = '';
    d1.value = today;
    d2.value = today;
    currentTypeFilter.value = 'All';
    searchQuery.value = '';
    selectedCustomerIds.clear();
    go('create');
  }

  // Get set of customer IDs already used in non-rejected plans
  Set<int> get usedCustomerIds {
    final set = <int>{};
    for (final p in plans) {
      if (p.status != 'Rejected') {
        set.addAll(p.cust);
      }
    }
    return set;
  }

  // Customers for current zone excluding already used ones
  List<PrototypeCustomer> get zoneAvailableCustomers {
    if (currentZone.value.isEmpty) return [];
    final used = usedCustomerIds;
    return customers
        .where((c) => c.zone == currentZone.value && !used.contains(c.id))
        .toList();
  }

  // Filtered customer list for display (by type chip and search query)
  List<PrototypeCustomer> get filteredCustomers {
    final base = zoneAvailableCustomers;
    final tf = currentTypeFilter.value;
    final q = searchQuery.value.trim().toLowerCase();

    return base.where((c) {
      final matchesType = tf == 'All' || c.type == tf;
      final matchesSearch = q.isEmpty ||
          c.name.toLowerCase().contains(q) ||
          c.owner.toLowerCase().contains(q);
      return matchesType && matchesSearch;
    }).toList();
  }

  // Are all currently visible filtered customers selected?
  bool get isAllVisibleSelected {
    final visible = filteredCustomers;
    if (visible.isEmpty) return false;
    return visible.every((c) => selectedCustomerIds.contains(c.id));
  }

  // Toggle selection of individual customer
  void toggleCustomerSelection(int customerId) {
    if (selectedCustomerIds.contains(customerId)) {
      selectedCustomerIds.remove(customerId);
    } else {
      selectedCustomerIds.add(customerId);
    }
    selectedCustomerIds.refresh();
  }

  // Toggle "Select all" / "Clear all"
  void toggleAllVisibleCustomers(bool selectAll) {
    final visible = filteredCustomers;
    if (selectAll) {
      for (final c in visible) {
        selectedCustomerIds.add(c.id);
      }
    } else {
      for (final c in visible) {
        selectedCustomerIds.remove(c.id);
      }
    }
    selectedCustomerIds.refresh();
  }

  // Form Validity check for sticky footer button
  bool get isFormValid {
    if (currentZone.value.isEmpty || selectedCustomerIds.isEmpty) return false;
    if (currentMode.value == 'Local') {
      return d1.value.isNotEmpty;
    } else {
      return d1.value.isNotEmpty &&
          d2.value.isNotEmpty &&
          d2.value.compareTo(d1.value) >= 0;
    }
  }

  // Save / Submit Plan action
  Future<void> savePlan() async {
    if (!isFormValid || isSubmitting.value) return;

    isSubmitting.value = true;
    final newRefNum = plans.length + 1;
    final newRef = 'PLN-${newRefNum.toString().padLeft(6, '0')}';

    final newPlanItem = PrototypePlan(
      ref: newRef,
      mode: currentMode.value,
      zone: currentZone.value,
      from: d1.value,
      to: currentMode.value == 'Local' ? d1.value : d2.value,
      cust: selectedCustomerIds.toList(),
      status: 'Pending',
    );

    plans.insert(0, newPlanItem);

    // Attempt background API submission if service available
    try {
      final isOutstation = currentMode.value == 'Upcountry';
      final body = isOutstation
          ? {
              "planType": "OUTSTATION",
              "fromDate": d1.value,
              "toDate": d2.value,
              "remark": "New tour plan created",
            }
          : {
              "date": d1.value,
              "planType": "LOCAL",
            };
      await _apiService.createVisitPlan(body);
    } catch (e) {
      if (kDebugMode) {
        print("API createVisitPlan notice (saved locally in prototype mode): $e");
      }
    } finally {
      isSubmitting.value = false;
    }

    currentFilter.value = 'All';
    go('list');

    Get.snackbar(
      'Plan Created',
      '$newRef created · Pending approval',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  // Filtered plans list for My Plan view
  List<PrototypePlan> get filteredPlans {
    final f = currentFilter.value;
    if (f == 'All') return plans;
    return plans.where((p) => p.status == f).toList();
  }

  // Count helper for My Plan status tabs
  int getPlanCountByStatus(String status) {
    if (status == 'All') return plans.length;
    return plans.where((p) => p.status == status).length;
  }

  // Format date helper: YYYY-MM-DD -> 21 Nov 2026
  String formatDate(String dateStr) {
    try {
      final d = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(d);
    } catch (_) {
      return dateStr;
    }
  }

  // Date range helper for plan cards
  String formatPlanDateRange(PrototypePlan plan) {
    if (plan.from == plan.to) {
      return formatDate(plan.from);
    }
    return '${formatDate(plan.from)} → ${formatDate(plan.to)}';
  }

  // Customer Mix String e.g. "1 D · 1 R"
  String getCustomerMixString(List<PrototypeCustomer> custs) {
    final parts = <String>[];
    for (final type in ['D', 'R', 'M']) {
      final count = custs.where((c) => c.type == type).length;
      if (count > 0) {
        parts.add('$count ${TN[type]![0]}');
      }
    }
    return parts.join(' · ');
  }
}
