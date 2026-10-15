import 'package:get/get.dart';
import '../../domain/entities/outlet.dart';
import '../../routes/route_names.dart';

enum CheckInState {
  initial,
  fetchingLocation,
  ready,
  loading,
  success,
  errorPermissionDenied,
  errorWeakGps,
}

class VisitCheckInController extends GetxController {
  final outlet = Rxn<Outlet>();
  final state = CheckInState.initial.obs;
  final isPhotoTaken = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Outlet) {
      outlet.value = Get.arguments as Outlet;
    }
  }

  void capturePhoto() {
    isPhotoTaken.value = true;
    if (state.value == CheckInState.initial) {
      _fetchLocation();
    }
  }

  void retakePhoto() {
    isPhotoTaken.value = false;
    state.value = CheckInState.initial;
  }

  Future<void> _fetchLocation() async {
    state.value = CheckInState.fetchingLocation;
    await Future.delayed(const Duration(seconds: 1));
    state.value = CheckInState.ready;
  }

  void simulatePermissionDenied() {
    state.value = CheckInState.errorPermissionDenied;
  }

  void simulateWeakGps() {
    state.value = CheckInState.errorWeakGps;
  }

  void retryLocation() {
    _fetchLocation();
  }

  Future<void> markVisit() async {
    if (state.value != CheckInState.ready) return;
    
    state.value = CheckInState.loading;
    await Future.delayed(const Duration(seconds: 2));
    state.value = CheckInState.success;
  }

  void finishCheckIn() {
    if (outlet.value != null) {
      Get.offNamed(RoutesName.visit_details_view, arguments: outlet.value);
    } else {
      Get.back();
    }
  }
}
