import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/datasource/remote/visit_plans_api_service.dart';
import '../../data/models/my_geographies_response.dart';
import '../../data/models/visit_plan_customers_response.dart';
import '../../data/models/my_visits_response.dart';

class CreatePlanViewModel extends GetxController {
  final VisitPlansApiService _apiService = Get.isRegistered<VisitPlansApiService>()
      ? Get.find<VisitPlansApiService>()
      : VisitPlansApiService();

  // Screens: 'list', 'planType', 'geography', 'retailers', 'details', 'done'
  final currentScreen = 'list'.obs;

  // Master Data Options
  final remarksList = ["Supervisor visit", "New outlet drive", "Stock audit", "Collection follow-up"];

  // Step 1: Plan Type Selection State
  final planType = 'Local'.obs; // 'Local' or 'Outstation'
  final selectedDate = ''.obs; // 'YYYY-MM-DD'

  // Outstation Geography Selection State
  final geographies = <GeographyItem>[].obs;
  final selectedGeographyUuid = ''.obs;
  final isGeographyLoading = false.obs;
  final geographyHasError = false.obs;
  final geographyErrorMessage = ''.obs;

  // Step 2: Customers API State (Unified /visit-plans/customers)
  final unplannedCustomers = <VisitPlanCustomer>[].obs;
  final selectedCustomerUuids = <String>{}.obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final currentPage = 0.obs;
  final totalPages = 0.obs;
  final totalElements = 0.obs;
  final int pageSize = 20;

  // My Plans API State (GET /api/v1/sfa/visits)
  final myVisits = <GroupedPlan>[].obs;
  final isVisitsLoading = false.obs;
  final isVisitsLoadingMore = false.obs;
  final visitsHasError = false.obs;
  final visitsErrorMessage = ''.obs;
  final visitsCurrentPage = 0.obs;
  final visitsTotalPages = 0.obs;
  final visitsTotalElements = 0.obs;
  final visitsSelectedDate = ''.obs;

  // Step 3: Details Form State
  final fromDate = ''.obs;
  final toDate = ''.obs;
  final remark = ''.obs;
  final isSubmitting = false.obs;

  // Date-wise customer mapping for Outstation plans: date YYYY-MM-DD -> RxSet<uuid>
  final dateCustomerMap = <String, RxSet<String>>{}.obs;
  final activeDateTab = ''.obs;

  // Validation Errors
  final errors = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    selectedDate.value = DateFormat('yyyy-MM-dd').format(tomorrow);
    fetchMyVisits(refresh: true);
  }

  // Fetch My Visits/Plans API & Group by planUuid
  Future<void> fetchMyVisits({bool refresh = false}) async {
    if (refresh) {
      visitsCurrentPage.value = 0;
      myVisits.clear();
      isVisitsLoading.value = true;
    } else {
      isVisitsLoadingMore.value = true;
    }
    visitsHasError.value = false;
    visitsErrorMessage.value = '';

    try {
      final response = await _apiService.getMyVisits(
        scope: 'MINE',
        date: visitsSelectedDate.value.trim().isNotEmpty ? visitsSelectedDate.value.trim() : null,
        page: visitsCurrentPage.value,
        size: 20,
      );

      if (response.data != null) {
        final visitItems = response.data!.content;

        // Group visits sharing the same planUuid into a single GroupedPlan
        final Map<String, List<MyVisitItem>> groupedMap = {};
        for (final item in visitItems) {
          final pUuid = (item.planUuid != null && item.planUuid!.trim().isNotEmpty)
              ? item.planUuid!.trim()
              : (item.uuid != null && item.uuid!.trim().isNotEmpty ? item.uuid!.trim() : 'UNPLANNED');

          groupedMap.putIfAbsent(pUuid, () => []).add(item);
        }

        final List<GroupedPlan> newPlans = groupedMap.entries
            .map((e) => GroupedPlan.fromVisits(e.key, e.value))
            .toList();

        if (refresh) {
          myVisits.assignAll(newPlans);
        } else {
          myVisits.addAll(newPlans);
        }

        visitsCurrentPage.value = response.data!.page;
        visitsTotalPages.value = response.data!.totalPages;
        visitsTotalElements.value = response.data!.totalElements;
      } else {
        if (refresh) myVisits.clear();
        visitsTotalPages.value = 0;
        visitsTotalElements.value = 0;
      }
    } catch (e) {
      visitsHasError.value = true;
      visitsErrorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isVisitsLoading.value = false;
      isVisitsLoadingMore.value = false;
    }
  }

  void loadNextVisitsPage() {
    if (!isVisitsLoading.value &&
        !isVisitsLoadingMore.value &&
        visitsCurrentPage.value < visitsTotalPages.value - 1) {
      visitsCurrentPage.value++;
      fetchMyVisits(refresh: false);
    }
  }

  void setVisitsFilterDate(String dateStr) {
    visitsSelectedDate.value = dateStr;
    fetchMyVisits(refresh: true);
  }

  void clearVisitsFilterDate() {
    visitsSelectedDate.value = '';
    fetchMyVisits(refresh: true);
  }

  // Navigation
  void go(String screen) {
    currentScreen.value = screen;
    errors.clear();
  }

  // Start Create Plan Flow -> Step 1: Select Plan Type
  void startAddPlan() {
    errors.clear();
    planType.value = 'Local';
    selectedCustomerUuids.clear();
    selectedGeographyUuid.value = '';
    searchQuery.value = '';
    dateCustomerMap.clear();
    activeDateTab.value = '';
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    selectedDate.value = DateFormat('yyyy-MM-dd').format(tomorrow);
    go('planType');
  }

  // Setters
  void setPlanType(String type) {
    planType.value = type;
  }

  void setSelectedDate(String dateStr) {
    try {
      final picked = DateTime.parse(dateStr);
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      if (!picked.isAfter(todayDate)) {
        final tomorrow = todayDate.add(const Duration(days: 1));
        selectedDate.value = DateFormat('yyyy-MM-dd').format(tomorrow);
        return;
      }
    } catch (_) {}
    selectedDate.value = dateStr;
  }

  String get apiPlanType {
    final t = planType.value.toUpperCase();
    if (t == 'OUTSTATION' || t == 'UPCOUNTRY') {
      return 'OUTSTATION';
    }
    return 'LOCAL';
  }

  // Transition from Step 1 (Plan Type)
  void continueFromPlanType() {
    if (planType.value.isEmpty) return;

    // Strict Validation: ensure selectedDate is starting from tomorrow
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final tomorrowDate = todayDate.add(const Duration(days: 1));
    try {
      final current = DateTime.parse(selectedDate.value);
      if (!current.isAfter(todayDate)) {
        selectedDate.value = DateFormat('yyyy-MM-dd').format(tomorrowDate);
      }
    } catch (_) {
      selectedDate.value = DateFormat('yyyy-MM-dd').format(tomorrowDate);
    }

    if (apiPlanType == 'OUTSTATION') {
      selectedGeographyUuid.value = '';
      go('geography');
      fetchMyGeographies();
    } else {
      selectedGeographyUuid.value = '';
      go('retailers');
      fetchUnplannedCustomers(refresh: true);
    }
  }

  // Fetch My Geographies for Outstation Plan (Filtered by isPrimary == false)
  Future<void> fetchMyGeographies() async {
    isGeographyLoading.value = true;
    geographyHasError.value = false;
    geographyErrorMessage.value = '';
    geographies.clear();

    try {
      final response = await _apiService.getMyGeographies();
      final outstationGeographies = response.data.where((item) {
        return item.isPrimary == false;
      }).toList();

      geographies.assignAll(
        outstationGeographies.isNotEmpty ? outstationGeographies : response.data,
      );
    } catch (e) {
      geographyHasError.value = true;
      geographyErrorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isGeographyLoading.value = false;
    }
  }

  void selectGeography(GeographyItem item) {
    selectedGeographyUuid.value = item.effectiveUuid;
  }

  // Transition from Geography Selection -> Select Retailers
  void continueFromGeography() {
    if (selectedGeographyUuid.value.isEmpty) return;
    go('retailers');
    fetchUnplannedCustomers(refresh: true);
  }

  // Fetch Customers via Unified API (GET /api/v1/sfa/visit-plans/customers)
  Future<void> fetchUnplannedCustomers({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 0;
      unplannedCustomers.clear();
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }
    hasError.value = false;
    errorMessage.value = '';

    try {
      final response = await _apiService.getVisitPlanCustomers(
        planType: apiPlanType,
        type: 'ALL',
        date: selectedDate.value,
        destinationGeographyUuid: apiPlanType == 'OUTSTATION' ? selectedGeographyUuid.value : null,
        search: searchQuery.value.trim().isNotEmpty ? searchQuery.value.trim() : null,
        sort: 'NAME_ASC',
        page: currentPage.value,
        size: pageSize,
      );

      if (response.data != null) {
        final newCustomers = response.data!.content;
        if (refresh) {
          unplannedCustomers.assignAll(newCustomers);
        } else {
          unplannedCustomers.addAll(newCustomers);
        }
        currentPage.value = response.data!.page;
        totalPages.value = response.data!.totalPages;
        totalElements.value = response.data!.totalElements;
      } else {
        if (refresh) unplannedCustomers.clear();
        totalPages.value = 0;
        totalElements.value = 0;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  // Load Next Page for Pagination
  void loadNextPage() {
    if (!isLoading.value &&
        !isLoadingMore.value &&
        currentPage.value < totalPages.value - 1) {
      currentPage.value++;
      fetchUnplannedCustomers(refresh: false);
    }
  }

  // Customer Selection Actions (using uuid)
  void toggleCustomerUuid(String uuid) {
    if (selectedCustomerUuids.contains(uuid)) {
      selectedCustomerUuids.remove(uuid);
    } else {
      selectedCustomerUuids.add(uuid);
    }
    selectedCustomerUuids.refresh();
  }

  void selectAllVisible(bool on) {
    final visible = filteredCustomers;
    if (on) {
      for (final c in visible) {
        selectedCustomerUuids.add(c.uuid);
      }
    } else {
      for (final c in visible) {
        selectedCustomerUuids.remove(c.uuid);
      }
    }
    selectedCustomerUuids.refresh();
  }

  List<VisitPlanCustomer> get filteredCustomers {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      return unplannedCustomers;
    }
    return unplannedCustomers.where((c) {
      final name = (c.shopName ?? '').toLowerCase();
      final code = (c.customerCode ?? '').toLowerCase();
      final area = (c.area ?? '').toLowerCase();
      final city = (c.city ?? '').toLowerCase();
      return name.contains(query) || code.contains(query) || area.contains(query) || city.contains(query);
    }).toList();
  }

  bool get isAllVisibleSelected {
    final visible = filteredCustomers;
    if (visible.isEmpty) return false;
    return visible.every((c) => selectedCustomerUuids.contains(c.uuid));
  }

  // Transition from Step 2 (Select Retailers) -> Step 3 (Details)
  void continueFromRetailers() {
    if (selectedCustomerUuids.isEmpty) return;
    fromDate.value = selectedDate.value;
    toDate.value = selectedDate.value;
    remark.value = '';
    initDateCustomerMap();
    go('details');
  }

  // Date Range List for Outstation
  List<String> get outstationDateList {
    if (fromDate.value.isEmpty || toDate.value.isEmpty) return [];
    try {
      final start = DateTime.parse(fromDate.value);
      final end = DateTime.parse(toDate.value);
      if (end.isBefore(start)) return [fromDate.value];

      List<String> result = [];
      DateTime current = start;
      while (!current.isAfter(end)) {
        result.add(DateFormat('yyyy-MM-dd').format(current));
        current = current.add(const Duration(days: 1));
      }
      return result;
    } catch (_) {
      return [fromDate.value];
    }
  }

  void initDateCustomerMap() {
    dateCustomerMap.clear();
    final dates = outstationDateList;
    if (dates.isEmpty) return;
    activeDateTab.value = dates.first;

    for (final d in dates) {
      dateCustomerMap[d] = <String>{}.obs;
    }

    final allUuids = selectedCustomerUuids.toList();
    if (dates.length == 1) {
      dateCustomerMap[dates.first]!.addAll(allUuids);
    } else {
      for (int i = 0; i < allUuids.length; i++) {
        final dateKey = dates[i % dates.length];
        dateCustomerMap[dateKey]!.add(allUuids[i]);
      }
    }
  }

  void toggleCustomerForDate(String date, String customerUuid) {
    if (!dateCustomerMap.containsKey(date)) {
      dateCustomerMap[date] = <String>{}.obs;
    }
    final set = dateCustomerMap[date]!;
    if (set.contains(customerUuid)) {
      set.remove(customerUuid);
    } else {
      set.add(customerUuid);
    }
    dateCustomerMap.refresh();
  }

  // Build `days` array for OUTSTATION payload
  List<Map<String, dynamic>> buildOutstationDaysPayload() {
    final dates = outstationDateList;
    final allSelected = selectedCustomerUuids.toList();
    if (dates.isEmpty) {
      final d = fromDate.value.isNotEmpty ? fromDate.value : selectedDate.value;
      return [
        {
          "date": d,
          "customerUuids": allSelected,
        }
      ];
    }

    final daysPayload = <Map<String, dynamic>>[];
    for (final d in dates) {
      final assigned = dateCustomerMap[d]?.toList() ?? [];
      daysPayload.add({
        "date": d,
        "customerUuids": assigned.isNotEmpty ? assigned : allSelected,
      });
    }
    return daysPayload;
  }

  // Submit for Approval Action (POST /api/v1/sfa/visit-plans)
  Future<void> submit() async {
    if (isSubmitting.value) return;

    final newErrors = <String, String>{};
    final isOutstation = apiPlanType == 'OUTSTATION';

    if (selectedCustomerUuids.isEmpty) {
      Get.snackbar('Selection Required', 'Please select at least one retailer.');
      return;
    }

    if (isOutstation) {
      if (fromDate.value.isEmpty) {
        newErrors['from'] = 'Pick a start date.';
      }
      if (toDate.value.isEmpty) {
        newErrors['to'] = 'Pick an end date.';
      }
      if (selectedGeographyUuid.value.isEmpty) {
        Get.snackbar('Geography Required', 'Please select a destination geography.');
        return;
      }
    } else {
      fromDate.value = selectedDate.value;
      toDate.value = selectedDate.value;
      if (selectedDate.value.isEmpty) {
        newErrors['from'] = 'Select a plan date.';
      }
    }

    if (remark.value.trim().isEmpty) {
      newErrors['remark'] = 'Add a remark.';
    }

    errors.value = newErrors;
    if (newErrors.isNotEmpty) return;

    isSubmitting.value = true;

    try {
      Map<String, dynamic> body;
      if (!isOutstation) {
        body = {
          "employeeUuid": null,
          "date": selectedDate.value,
          "planType": "LOCAL",
          "customerUuids": selectedCustomerUuids.toList(),
        };
      } else {
        body = {
          "planType": "OUTSTATION",
          "fromDate": fromDate.value,
          "toDate": toDate.value,
          "destinationGeographyUuid": selectedGeographyUuid.value,
          "days": buildOutstationDaysPayload(),
          "remark": remark.value.trim(),
        };
      }

      await _apiService.createVisitPlan(body);

      // Re-fetch my visits list to display real data from API
      await fetchMyVisits(refresh: true);

      go('done');
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'Submission Failed',
        msg,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  void reset() {
    selectedCustomerUuids.clear();
    selectedGeographyUuid.value = '';
    searchQuery.value = '';
    planType.value = 'Local';
    fromDate.value = '';
    toDate.value = '';
    remark.value = '';
    dateCustomerMap.clear();
    activeDateTab.value = '';
    fetchMyVisits(refresh: true);
    go('list');
  }

  String _formatDisplayDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
