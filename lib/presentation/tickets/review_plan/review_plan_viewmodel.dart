import 'package:get/get.dart';
import '../../../domain/entities/outlet.dart';
import '../../../routes/route_names.dart';

class ReviewPlanViewModel extends GetxController {
  final customers = <Outlet>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is List<Outlet>) {
      customers.addAll(Get.arguments as List<Outlet>);
    }
  }

  // Reactive properties based on customer count to simulate the two states
  bool get isOverloaded => customers.length > 1;

  double get totalDistance => isOverloaded ? 1472.0 : 0.0;
  
  double get totalHours {
    if (isOverloaded) {
      return 59.9;
    } else {
      return customers.length * 0.5;
    }
  }

  double get travelHours => isOverloaded ? 58.9 : 0.0;
  double get visitHours => customers.length * 0.5;

  void removeCustomer(Outlet outlet) {
    customers.remove(outlet);
    if (customers.isEmpty) {
      Get.back(); // If all removed, go back
    }
  }

  void optimizePlan() {
    // Keep only the first customer to simulate optimization fixing the overload
    if (customers.length > 1) {
      final first = customers.first;
      customers.clear();
      customers.add(first);
    }
  }

  void addMoreCustomers() {
    Get.toNamed(RoutesName.select_customers_view)?.then((_) {
       // Ideally we would merge lists, but for now we just handle navigation.
    });
  }

  void createPlan() {
    // Complete the flow
    Get.snackbar('Success', 'Plan created successfully!', snackPosition: SnackPosition.BOTTOM);
    // Future expansion: Navigate to Dashboard or clear stack
  }
}
