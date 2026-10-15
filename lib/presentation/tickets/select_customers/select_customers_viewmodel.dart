import 'package:get/get.dart';
import '../../../domain/entities/outlet.dart';
import '../../../routes/route_names.dart';

class SelectCustomersViewModel extends GetxController {
  final customers = <Outlet>[].obs;
  final selectedCustomers = <Outlet>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockCustomers();
  }

  void _loadMockCustomers() {
    // Generate some mock customers for the selection list
    customers.value = [
      Outlet(
        id: '101',
        firstName: 'Ashok Kumar kundu',
        lastName: '',
        firmName: '',
        customerType: 'Mechanic',
        mobileNumber: '9668477106',
        city: 'Jajpur',
        state: 'Orissa',
        email: '',
        address: '',
        district: '',
        pinCode: '',
        photos: [],
      ),
      Outlet(
        id: '102',
        firstName: 'Shubham Goyal',
        lastName: '',
        firmName: '',
        customerType: 'Retailer',
        mobileNumber: '9041801678',
        city: 'Mansa',
        state: 'Punjab',
        email: '',
        address: '',
        district: '',
        pinCode: '',
        photos: [],
      ),
      Outlet(
        id: '103',
        firstName: 'Bapanbai Mohammad imr...',
        lastName: '',
        firmName: '',
        customerType: 'Mechanic',
        mobileNumber: '8977139527',
        city: 'Anantapur',
        state: 'Andhra Pradesh',
        email: '',
        address: '',
        district: '',
        pinCode: '',
        photos: [],
      ),
      Outlet(
        id: '104',
        firstName: 'Ravi Kaliyan',
        lastName: '',
        firmName: '',
        customerType: 'Mechanic',
        mobileNumber: '9566534683',
        city: 'Namakkal Market',
        state: 'Tamilnadu',
        email: '',
        address: '',
        district: '',
        pinCode: '',
        photos: [],
      ),
      Outlet(
        id: '105',
        firstName: 'Jogdand Aditya dhondiram',
        lastName: '',
        firmName: '',
        customerType: 'Mechanic',
        mobileNumber: '9420067290',
        city: 'Huzurabad',
        state: 'Telangana',
        email: '',
        address: '',
        district: '',
        pinCode: '',
        photos: [],
      ),
    ];
  }

  void toggleSelection(Outlet outlet) {
    if (selectedCustomers.contains(outlet)) {
      selectedCustomers.remove(outlet);
    } else {
      selectedCustomers.add(outlet);
    }
  }

  bool isSelected(Outlet outlet) {
    return selectedCustomers.contains(outlet);
  }

  void proceedToReview() {
    if (selectedCustomers.isNotEmpty) {
      Get.toNamed(RoutesName.review_plan_view, arguments: selectedCustomers.toList());
    } else {
      Get.snackbar('Selection required', 'Please add at least one customer to proceed.', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
