import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/datasource/remote/visit_plans_api_service.dart';
import '../../data/models/my_geographies_response.dart';
import '../../data/models/visit_plan_customers_response.dart';
import '../../data/models/visit_plan_models.dart';
import '../widgets/api_error_dialog.dart';

/// Zone Info Mapping matching the HTML Prototype
const Map<String, List<String>> Z = {
  'L1': ['Arera Colony', 'Bhopal', 'Local'],
  'L2': ['MP Nagar', 'Bhopal', 'Local'],
  'L3': ['Kolar Road', 'Bhopal', 'Local'],
  'U1': ['Indore Territory', 'Indore', 'Upcountry'],
  'U2': ['Jabalpur Territory', 'Jabalpur', 'Upcountry'],
  'U3': ['Sagar Territory', 'Sagar', 'Upcountry'],
};

/// Customer Type Labels
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
  final currentZone = ''.obs; // Geography UUID
  final d1 = ''.obs; // Visit date / From date
  final d2 = ''.obs; // To date (Upcountry)
  final currentTypeFilter = 'All'.obs; // 'All', 'D', 'R', 'M'
  final searchQuery = ''.obs;
  final selectedCustomerIds = <int>{}.obs;

  // Dynamic Geographies State
  final geographies = <GeographyItem>[].obs;
  final selectedGeography = Rxn<GeographyItem>();
  final isGeographiesLoading = false.obs;

  // Dynamic Customers State
  final apiCustomers = <VisitPlanCustomer>[].obs;
  final selectedCustomerUuids = <String>{}.obs;
  final isCustomersLoading = true.obs; // Starts as true so loader displays from first frame
  final customersError = ''.obs;

  // Reactive Plan List & Prototype Lists
  final plans = <PrototypePlan>[].obs;
  final customers = <PrototypeCustomer>[].obs;
  final apiVisitPlans = <VisitPlanModel>[].obs;
  final selectedApiPlan = Rxn<VisitPlanModel>();

  // Loading & Error States for API integration
  final isLoading = false.obs;
  final isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    d1.value = today;
    d2.value = today;

    debounce(searchQuery, (_) {
      if (currentScreen.value == 'create') {
        fetchCustomers();
      }
    }, time: const Duration(milliseconds: 300));

    fetchVisitPlansFromApi();
    fetchGeographies();
  }

  Future<void> fetchGeographies() async {
    isGeographiesLoading.value = true;
    try {
      final res = await _apiService.getMyGeographies();
      if (res.data.isNotEmpty) {
        geographies.assignAll(res.data);
        _autoSelectGeographyForCurrentMode();
      }
    } catch (e) {
      if (kDebugMode) {
        print("API fetchGeographies notice: $e");
      }
    } finally {
      isGeographiesLoading.value = false;
      fetchCustomers();
    }
  }

  void _autoSelectGeographyForCurrentMode() {
    if (geographies.isEmpty) return;

    if (currentMode.value == 'Upcountry') {
      // Entry with isPrimary = false represents OUTSTATION destination territory
      final outstationItem = geographies.firstWhereOrNull((g) => g.isPrimary == false) ??
          geographies.firstWhereOrNull((g) => g.isPrimary != true);

      if (outstationItem != null) {
        selectedGeography.value = outstationItem;
        currentZone.value = outstationItem.effectiveUuid;
      }
    } else {
      // Local mode: primary territory (isPrimary = true)
      final primaryItem = geographies.firstWhereOrNull((g) => g.isPrimary == true) ?? geographies.firstOrNull;
      if (primaryItem != null) {
        selectedGeography.value = primaryItem;
        currentZone.value = primaryItem.effectiveUuid;
      }
    }
  }

  Future<void> fetchCustomers() async {
    final mode = currentMode.value;
    final planType = mode == 'Local' ? 'LOCAL' : 'OUTSTATION';

    if (mode == 'Upcountry') {
      if (selectedGeography.value == null || selectedGeography.value?.isPrimary == true) {
        final outstationItem = geographies.firstWhereOrNull((g) => g.isPrimary == false) ??
            geographies.firstWhereOrNull((g) => g.isPrimary != true);
        if (outstationItem != null) {
          selectedGeography.value = outstationItem;
          currentZone.value = outstationItem.effectiveUuid;
        }
      }
    } else {
      if (selectedGeography.value == null || selectedGeography.value?.isPrimary == false) {
        final primaryItem = geographies.firstWhereOrNull((g) => g.isPrimary == true) ?? geographies.firstOrNull;
        if (primaryItem != null) {
          selectedGeography.value = primaryItem;
          currentZone.value = primaryItem.effectiveUuid;
        }
      }
    }

    final geoUuid = selectedGeography.value?.effectiveUuid ?? currentZone.value;

    if (mode == 'Upcountry' && geoUuid.trim().isEmpty) {
      apiCustomers.clear();
      isCustomersLoading.value = false;
      return;
    }

    isCustomersLoading.value = true;
    customersError.value = '';

    try {
      final res = await _apiService.getCustomers(
        planType: planType,
        date: d1.value,
        destinationGeographyUuid: mode == 'Upcountry' ? geoUuid : null,
        search: searchQuery.value.trim().isNotEmpty ? searchQuery.value.trim() : null,
        sort: 'NAME_ASC',
        page: 0,
        size: 100,
      );

      final list = res.data?.content ?? [];
      apiCustomers.assignAll(list);
    } catch (e) {
      customersError.value = e.toString().replaceAll('Exception: ', '');
      if (kDebugMode) {
        print("API fetchCustomers notice: $e");
      }
    } finally {
      isCustomersLoading.value = false;
    }
  }

  void onGeographySelected(GeographyItem? geo) {
    selectedGeography.value = geo;
    if (geo != null) {
      currentZone.value = geo.effectiveUuid;
    } else {
      currentZone.value = '';
    }
    selectedCustomerUuids.clear();
    fetchCustomers();
  }

  void onModeChanged(String mode) {
    currentMode.value = mode;
    selectedCustomerUuids.clear();
    _autoSelectGeographyForCurrentMode();
    fetchCustomers();
  }

  void onDate1Changed(String dateVal) {
    try {
      final parsed = DateTime.parse(dateVal.trim());
      final formatted = DateFormat('yyyy-MM-dd').format(parsed);
      d1.value = formatted;
      if (currentMode.value == 'Local' || d2.value.compareTo(formatted) < 0) {
        d2.value = formatted;
      }
    } catch (_) {
      d1.value = dateVal.trim();
    }
    fetchCustomers();
  }

  void onDate2Changed(String dateVal) {
    try {
      final parsed = DateTime.parse(dateVal.trim());
      final formatted = DateFormat('yyyy-MM-dd').format(parsed);
      d2.value = formatted;
    } catch (_) {
      d2.value = dateVal.trim();
    }
    fetchCustomers();
  }

  bool _isDistributor(VisitPlanCustomer c) {
    final type = (c.customerType ?? '').trim().toUpperCase();
    final shop = (c.shopName ?? '').toLowerCase();
    if (type == 'D' || type == 'DISTRIBUTOR' || type.contains('DISTRIB')) return true;
    return shop.contains('distributor') || shop.contains('traders') || shop.contains('agencies') || shop.contains('suppliers');
  }

  bool _isRetailer(VisitPlanCustomer c) {
    final type = (c.customerType ?? '').trim().toUpperCase();
    final shop = (c.shopName ?? '').toLowerCase();
    if (type == 'R' || type == 'RETAILER' || type.contains('RETAIL')) return true;
    return shop.contains('retail') || shop.contains('store') || shop.contains('mart') || shop.contains('spares') || shop.contains('hardware') || shop.contains('autos') || shop.contains('hub');
  }

  bool _isMechanic(VisitPlanCustomer c) {
    final type = (c.customerType ?? '').trim().toUpperCase();
    final shop = (c.shopName ?? '').toLowerCase();
    if (type == 'M' || type == 'MECHANIC' || type.contains('MECHANIC')) return true;
    return shop.contains('mechanic') || shop.contains('garage') || shop.contains('works') || shop.contains('workshop') || shop.contains('service');
  }

  int getApiCustomerCountForType(String typeKey) {
    if (typeKey == 'All') return apiCustomers.length;
    if (typeKey == 'D') return apiCustomers.where((c) => _isDistributor(c)).length;
    if (typeKey == 'R') return apiCustomers.where((c) => _isRetailer(c)).length;
    if (typeKey == 'M') return apiCustomers.where((c) => _isMechanic(c)).length;
    return 0;
  }

  int getPrototypeCustomerCountForType(String typeKey) {
    if (apiCustomers.isNotEmpty || isCustomersLoading.value) {
      return getApiCustomerCountForType(typeKey);
    }
    return 0;
  }

  List<VisitPlanCustomer> get filteredApiCustomers {
    final tf = currentTypeFilter.value;
    final q = searchQuery.value.trim().toLowerCase();

    return apiCustomers.where((c) {
      bool matchesType = true;
      if (tf == 'D') {
        matchesType = _isDistributor(c);
      } else if (tf == 'R') {
        matchesType = _isRetailer(c);
      } else if (tf == 'M') {
        matchesType = _isMechanic(c);
      }

      bool matchesSearch = true;
      if (q.isNotEmpty) {
        final name = (c.shopName ?? '').toLowerCase();
        final code = (c.customerCode ?? '').toLowerCase();
        final area = (c.area ?? '').toLowerCase();
        final city = (c.city ?? '').toLowerCase();
        matchesSearch = name.contains(q) || code.contains(q) || area.contains(q) || city.contains(q);
      }

      return matchesType && matchesSearch;
    }).toList();
  }

  void toggleApiCustomerSelection(String uuid) {
    if (selectedCustomerUuids.contains(uuid)) {
      selectedCustomerUuids.remove(uuid);
    } else {
      selectedCustomerUuids.add(uuid);
    }
    selectedCustomerUuids.refresh();
  }

  bool get isAllApiCustomersSelected {
    final visible = filteredApiCustomers;
    if (visible.isEmpty) return false;
    return visible.every((c) => selectedCustomerUuids.contains(c.uuid));
  }

  void toggleAllApiCustomers(bool selectAll) {
    final visible = filteredApiCustomers;
    if (selectAll) {
      for (final c in visible) {
        if (c.uuid.isNotEmpty) {
          selectedCustomerUuids.add(c.uuid);
        }
      }
    } else {
      for (final c in visible) {
        selectedCustomerUuids.remove(c.uuid);
      }
    }
    selectedCustomerUuids.refresh();
  }

  // Helper getters for prototype compatibility
  List<PrototypeCustomer> get zoneAvailableCustomers => [];
  List<PrototypeCustomer> get filteredCustomers => [];
  bool get isAllVisibleSelected => isAllApiCustomersSelected;
  void toggleCustomerSelection(int id) {}
  void toggleAllVisibleCustomers(bool selectAll) => toggleAllApiCustomers(selectAll);

  Future<void> fetchVisitPlansFromApi() async {
    isLoading.value = true;
    try {
      final response = await _apiService.getVisitPlans();
      if (response.content.isNotEmpty) {
        apiVisitPlans.assignAll(response.content);
      }
    } catch (e) {
      if (kDebugMode) {
        print("API getVisitPlans notice: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }

  void go(String screen, {String? openRef}) {
    currentScreen.value = screen;
    if (openRef != null) {
      openPlanRef.value = openRef;
    }
  }

  void newPlan([String mode = 'Local']) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    currentMode.value = mode;
    currentZone.value = '';
    selectedGeography.value = null;
    d1.value = today;
    d2.value = today;
    currentTypeFilter.value = 'All';
    searchQuery.value = '';
    selectedCustomerUuids.clear();
    apiCustomers.clear();
    isCustomersLoading.value = true;

    fetchGeographies();
    go('create');
  }

  bool get isFormValid {
    if (currentMode.value == 'Upcountry' &&
        (selectedGeography.value == null && currentZone.value.isEmpty)) {
      return false;
    }
    if (selectedCustomerUuids.isEmpty) return false;
    if (currentMode.value == 'Local') return d1.value.trim().isNotEmpty;
    return d1.value.trim().isNotEmpty &&
        d2.value.trim().isNotEmpty &&
        d2.value.compareTo(d1.value) >= 0;
  }

  Future<void> savePlan() async {
    if (!isFormValid || isSubmitting.value) return;

    isSubmitting.value = true;
    try {
      final isOutstation = currentMode.value == 'Upcountry';

      String geoUuid = '';
      if (isOutstation) {
        if (selectedGeography.value != null && selectedGeography.value!.isPrimary == false) {
          geoUuid = selectedGeography.value!.effectiveUuid;
        } else {
          final outstationItem = geographies.firstWhereOrNull((g) => g.isPrimary == false) ??
              geographies.firstWhereOrNull((g) => g.isPrimary != true);
          if (outstationItem != null) {
            geoUuid = outstationItem.effectiveUuid;
          }
        }
      } else {
        geoUuid = selectedGeography.value?.effectiveUuid ?? currentZone.value;
      }

      final parsedFrom = DateTime.tryParse(d1.value.trim()) ?? DateTime.now();
      final validFromDate = DateFormat('yyyy-MM-dd').format(parsedFrom);

      final parsedTo = isOutstation
          ? (DateTime.tryParse(d2.value.trim()) ?? parsedFrom)
          : parsedFrom;
      final validToDate = DateFormat('yyyy-MM-dd').format(parsedTo);

      final selectedUuidsList = selectedCustomerUuids.toList();

      final Map<String, dynamic> body;
      if (isOutstation) {
        int daysCount = parsedTo.difference(parsedFrom).inDays + 1;
        if (daysCount < 1) daysCount = 1;

        final List<Map<String, dynamic>> daysList = [];
        for (int i = 0; i < daysCount; i++) {
          final dayDate = parsedFrom.add(Duration(days: i));
          final formattedDay = DateFormat('yyyy-MM-dd').format(dayDate);
          daysList.add({
            "date": formattedDay,
            "customerUuids": selectedUuidsList,
          });
        }

        body = <String, dynamic>{
          "planType": "OUTSTATION",
          "fromDate": validFromDate,
          "toDate": validToDate,
          if (geoUuid.isNotEmpty) "destinationGeographyUuid": geoUuid,
          "days": daysList,
          "remark": "Upcountry trip plan",
        };
      } else {
        body = <String, dynamic>{
          "planType": "LOCAL",
          "date": validFromDate,
          "customerUuids": selectedUuidsList,
        };
      }

      if (kDebugMode) {
        print("POST /api/v1/sfa/visit-plans [${isOutstation ? 'OUTSTATION' : 'LOCAL'}] Payload: ${jsonEncode(body)}");
      }

      await _apiService.createVisitPlan(body);

      currentFilter.value = 'All';
      selectedCustomerUuids.clear();
      await fetchVisitPlansFromApi();
      go('list');

      Get.snackbar(
        'Success',
        'Visit plan created successfully',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      showApiErrorDialog(
        title: 'Unable to Create Plan',
        error: e,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  List<PrototypePlan> get filteredPlans => [];

  int getPlanCountByStatus(String status) {
    if (status == 'All') return apiVisitPlans.length;
    return apiVisitPlans.where((p) => p.displayStatus == status).length;
  }

  List<VisitPlanModel> get filteredApiPlans {
    final f = currentFilter.value;
    if (f == 'All') return apiVisitPlans;
    return apiVisitPlans.where((p) => p.displayStatus == f).toList();
  }

  String formatDate(String dateStr) {
    try {
      final d = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(d);
    } catch (_) {
      return dateStr;
    }
  }

  String formatPlanDateRange(PrototypePlan plan) {
    if (plan.from == plan.to) {
      return formatDate(plan.from);
    }
    return '${formatDate(plan.from)} → ${formatDate(plan.to)}';
  }

  String getCustomerMixString(List<PrototypeCustomer> custs) => '';
}
