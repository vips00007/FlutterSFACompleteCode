import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreatePlanViewModel extends GetxController {
  // Screens: 'list', 'retailers', 'details', 'done'
  final currentScreen = 'list'.obs;
  
  // Data mocks
  final List<List<String>> retailersList = [
    ["Sharma General Store", "Arera Colony", "Bhopal"],
    ["Gupta Kirana", "MP Nagar", "Bhopal"],
    ["Raj Medical & Provision", "Kolar Road", "Bhopal"],
    ["Jain Super Mart", "Habibganj", "Bhopal"],
    ["Annapurna Traders", "Itwara", "Bhopal"],
    ["Mehta Departmental", "Vijay Nagar", "Indore"],
    ["Shree Balaji Stores", "Sarafa", "Indore"],
    ["Khan Wholesale", "Old City", "Bhopal"],
  ];
  
  final territoryList = ["Bhopal North", "Bhopal South", "Bhopal Central", "Indore East"];
  final cityList = ["Bhopal", "Indore", "Jabalpur", "Gwalior", "Ujjain", "Sagar"];
  final remarksList = ["Supervisor visit", "New outlet drive", "Stock audit", "Collection follow-up"];

  // Form State
  final searchQuery = ''.obs;
  final selectedRetailers = <int>{}.obs;
  final planType = ''.obs; // 'Local' or 'Upcountry'
  
  final mode = 'Territory'.obs; // 'Territory' or 'City'
  final fromDate = ''.obs;
  final toDate = ''.obs;
  final selectedPlace = ''.obs;
  final remark = ''.obs;
  
  // Validation Errors
  final errors = <String, String>{}.obs;
  
  // Plans State
  final plans = <Map<String, dynamic>>[
    {
      "id": "PLN-1042",
      "type": "Local",
      "n": 3,
      "when": "20 Oct 2026",
      "status": "Approved"
    }
  ].obs;
  
  // Navigation
  void go(String screen) {
    currentScreen.value = screen;
    errors.clear();
  }

  // List Screen actions
  void toggleRetailer(int index) {
    if (selectedRetailers.contains(index)) {
      selectedRetailers.remove(index);
    } else {
      selectedRetailers.add(index);
    }
  }

  void selectAll(bool on) {
    if (on) {
      for (int i = 0; i < retailersList.length; i++) {
        final r = retailersList[i];
        final combined = "${r[0]} ${r[1]} ${r[2]}".toLowerCase();
        if (combined.contains(searchQuery.value.toLowerCase())) {
          selectedRetailers.add(i);
        }
      }
    } else {
      for (int i = 0; i < retailersList.length; i++) {
        final r = retailersList[i];
        final combined = "${r[0]} ${r[1]} ${r[2]}".toLowerCase();
        if (combined.contains(searchQuery.value.toLowerCase())) {
          selectedRetailers.remove(i);
        }
      }
    }
  }

  List<int> get filteredIndices {
    List<int> result = [];
    for (int i = 0; i < retailersList.length; i++) {
      final r = retailersList[i];
      final combined = "${r[0]} ${r[1]} ${r[2]}".toLowerCase();
      if (combined.contains(searchQuery.value.toLowerCase())) {
        result.add(i);
      }
    }
    return result;
  }

  bool get isAllSelected {
    final filtered = filteredIndices;
    if (filtered.isEmpty) return false;
    return filtered.every((i) => selectedRetailers.contains(i));
  }

  // Type Sheet Actions
  void setPlanType(String type) {
    planType.value = type;
  }
  
  void continueFromTypeSheet() {
    mode.value = planType.value == 'Upcountry' ? 'City' : 'Territory';
    selectedPlace.value = '';
    Get.back(); // close bottom sheet
    go('details');
  }

  // Details Actions
  void setMode(String newMode) {
    mode.value = newMode;
    selectedPlace.value = '';
  }

  void submit() {
    final newErrors = <String, String>{};
    
    if (fromDate.value.isEmpty) {
      newErrors['from'] = 'Pick a start date.';
    }
    if (toDate.value.isEmpty) {
      newErrors['to'] = 'Pick an end date.';
    }
    if (selectedPlace.value.isEmpty) {
      newErrors['place'] = 'Select a ${mode.value.toLowerCase()}.';
    }
    if (remark.value.trim().isEmpty) {
      newErrors['remark'] = 'Add a remark.';
    }

    errors.value = newErrors;

    if (newErrors.isEmpty) {
      final when = fromDate.value == toDate.value 
        ? _formatDate(fromDate.value) 
        : '${_formatDate(fromDate.value)} – ${_formatDate(toDate.value)}';

      plans.insert(0, {
        "id": "PLN-${1043 + plans.length - 1}",
        "type": planType.value,
        "n": selectedRetailers.length,
        "when": when,
        "status": "Pending approval",
        "place": "${mode.value}: ${selectedPlace.value}",
        "remark": remark.value,
      });
      
      go('done');
    }
  }

  void reset() {
    selectedRetailers.clear();
    searchQuery.value = '';
    planType.value = '';
    fromDate.value = '';
    toDate.value = '';
    selectedPlace.value = '';
    remark.value = '';
    go('list');
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
