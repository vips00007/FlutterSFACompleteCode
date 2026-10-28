import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';

class AddOutletViewModel extends GetxController {
  // Common states
  final currentStep = 0.obs; // 0-based to match arrays
  final maxStepReached = (-1).obs;
  final isLoading = false.obs;
  
  // Header / Global
  final avatarPath = RxnString();
  final avatarError = ''.obs;

  // --- STEP 1 ---
  final rtype = 'retailer'.obs;
  final shopController = TextEditingController();
  final personController = TextEditingController();
  final mobileController = TextEditingController();
  final wacb = false.obs;
  final waController = TextEditingController();
  final emailController = TextEditingController();
  
  // Address
  final capturedGeo = RxnString();
  final a1Controller = TextEditingController();
  final a2Controller = TextEditingController();
  final a3Controller = TextEditingController();
  final selectedState = RxnString();
  final cityController = TextEditingController();
  final pinController = TextEditingController();
  final isLocating = false.obs;

  final statesList = [
    "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh", "Goa", "Gujarat", 
    "Haryana", "Himachal Pradesh", "Jharkhand", "Karnataka", "Kerala", "Madhya Pradesh", 
    "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Odisha", "Punjab", "Rajasthan", 
    "Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh", "Uttarakhand", "West Bengal", 
    "Delhi", "Jammu and Kashmir", "Chandigarh", "Puducherry"
  ];

  // --- STEP 2 ---
  final subType = RxnString();
  final channel = RxnString();
  final segment = RxnString();
  final category = RxnString();
  final cls = RxnString();
  final beat = RxnString();
  
  final sizeController = TextEditingController();
  final potController = TextEditingController();
  final selectedBrands = <String>[].obs;
  final openTime = Rxn<TimeOfDay>();
  final closeTime = Rxn<TimeOfDay>();
  
  // Mechanic details
  final wtype = RxnString();
  final expController = TextEditingController();
  final eng = RxnString();
  final mechsController = TextEditingController();

  final subTypes = ['Retailer', 'Wholesaler'];
  final channels = ['General Trade', 'Modern Trade'];
  final segments = ['Two Wheeler', 'Three Wheeler', 'Four Wheeler', 'Commercial'];
  final categories = ['A', 'B', 'C'];
  final classes = ['Premium', 'Standard', 'Economy'];
  final beats = ['Vijay Nagar', 'MP Nagar', 'New Market', 'Hoshangabad Road', 'Kolar Road', 'Arera Colony'];
  final brands = ['Castrol', 'Servo', 'Motul', 'Gulf', 'Shell', 'Bosch', 'Exide', 'Genuine parts'];
  final wtypes = ['Two Wheeler', 'Three Wheeler', 'Four Wheeler', 'Multi-brand'];
  final engs = ['Electrical', 'Mechanical', 'Both'];

  // --- STEP 3 ---
  final doctype = 'Aadhaar'.obs;
  final fnController = TextEditingController();
  final lnController = TextEditingController();
  final docnoController = TextEditingController();
  
  // OTP logic
  final otpSent = false.obs;
  final otpVerified = false.obs;
  final demoOtp = RxnString();
  final otpInputs = List.generate(6, (_) => TextEditingController());
  final otpTimer = 0.obs;
  final otpError = ''.obs;
  final docnoError = ''.obs;
  Timer? _timer;

  final docfPath = RxnString();
  
  final bankController = TextEditingController();
  final holderController = TextEditingController();
  final accController = TextEditingController();
  final ifscController = TextEditingController();
  final bankfPath = RxnString();
  
  final gst = 'Registered'.obs;
  final gstcat = 'Regular'.obs;
  final gstnoController = TextEditingController();
  
  final fssaiController = TextEditingController();
  final fexpDate = Rxn<DateTime>();
  final ffPath = RxnString();
  
  final drugController = TextEditingController();
  final dfPath = RxnString();
  final shoplController = TextEditingController();
  final sfPath = RxnString();

  // Navigation
  void goStep(int step) {
    if (step == currentStep.value) return;
    if (step > currentStep.value) {
      for (int i = currentStep.value; i < step; i++) {
        if (!validateStep(i)) return;
        if (i > maxStepReached.value) {
          maxStepReached.value = i;
        }
      }
    }
    currentStep.value = step;
  }

  void nextStep() {
    if (validateStep(currentStep.value)) {
      if (currentStep.value > maxStepReached.value) {
        maxStepReached.value = currentStep.value;
      }
      if (currentStep.value < 2) {
        currentStep.value++;
      } else {
        submitForm();
      }
    }
  }
  
  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  // File Picking
  Future<void> pickFile(RxnString pathRef, {bool isImage = false}) async {
    try {
      PlatformFile? file = await FilePicker.pickFile(
        type: isImage ? FileType.image : FileType.custom,
        allowedExtensions: isImage ? null : ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (file != null && file.path != null) {
        pathRef.value = file.path!;
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not pick file');
    }
  }

  // Location
  Future<void> captureLocation() async {
    isLocating.value = true;
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high)
      );
      capturedGeo.value = '${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}';
      
      List<Placemark> placemarks = await Geocoding().placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        a1Controller.text = [p.street, p.subLocality].where((e) => e != null && e.isNotEmpty).join(', ');
        a2Controller.text = p.locality ?? '';
        a3Controller.text = p.subAdministrativeArea ?? '';
        cityController.text = p.locality ?? p.subAdministrativeArea ?? '';
        pinController.text = p.postalCode ?? '';
        if (p.administrativeArea != null && statesList.contains(p.administrativeArea)) {
          selectedState.value = p.administrativeArea;
        }
      }
    } catch (e) {
      Get.snackbar('Location', 'Could not fetch address details');
    } finally {
      isLocating.value = false;
    }
  }

  void toggleWacb(bool? val) {
    wacb.value = val ?? false;
    if (wacb.value) {
      waController.text = mobileController.text;
    }
  }

  // Validation
  final errors = <String, String>{}.obs;
  
  void setError(String key, String error) {
    if (error.isEmpty) {
      errors.remove(key);
    } else {
      errors[key] = error;
    }
  }
  
  bool hasError(String key) => errors.containsKey(key);
  String getError(String key) => errors[key] ?? '';
  
  bool validateStep(int step) {
    errors.clear();
    avatarError.value = '';
    
    if (step == 0) {
      if (avatarPath.value == null) {
        avatarError.value = 'Shop photo required';
      }

      
      if (shopController.text.trim().isEmpty) setError('shop', 'Required');
      if (personController.text.trim().isEmpty) setError('person', 'Required');
      
      final mobile = mobileController.text.trim();
      if (mobile.isEmpty) {
        setError('mobile', 'Required');
      } else if (!RegExp(r'^[6-9]\d{9}$').hasMatch(mobile)) {
        setError('mobile', 'Enter a valid 10-digit mobile number');
      }
      
      final wa = waController.text.trim();
      if (wa.isEmpty) {
        setError('wa', 'Required');
      } else if (!RegExp(r'^[6-9]\d{9}$').hasMatch(wa)) {
        setError('wa', 'Enter a valid 10-digit number');
      }
      
      final email = emailController.text.trim();
      if (email.isEmpty) {
        setError('email', 'Required');
      } else if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$').hasMatch(email)) {
        setError('email', 'Enter a valid email address');
      }
      
      if (a1Controller.text.trim().isEmpty) setError('a1', 'Required');
      if (a2Controller.text.trim().isEmpty) setError('a2', 'Required');
      if (a3Controller.text.trim().isEmpty) setError('a3', 'Required');
      if (selectedState.value == null) setError('state', 'Required');
      if (cityController.text.trim().isEmpty) setError('city', 'Required');
      
      final pin = pinController.text.trim();
      if (pin.isEmpty) {
        setError('pin', 'Required');
      } else if (!RegExp(r'^[1-9]\d{5}$').hasMatch(pin)) {
        setError('pin', 'Enter a 6-digit pin code');
      }
      
    } else if (step == 1) {
      if (subType.value == null) setError('sub', 'Required');
      if (channel.value == null) setError('chan', 'Required');
      if (segment.value == null) setError('seg', 'Required');
      if (category.value == null) setError('cat', 'Required');
      if (cls.value == null) setError('cls', 'Required');
      if (beat.value == null) setError('beat', 'Required');
      
      if (sizeController.text.trim().isEmpty) setError('size', 'Required');
      if (potController.text.trim().isEmpty) setError('pot', 'Required');
      if (selectedBrands.isEmpty) setError('brands', 'Required');
      
      if (openTime.value == null) setError('open', 'Required');
      if (closeTime.value == null) setError('close', 'Required');
      
      if (rtype.value == 'mechanic') {
        if (wtype.value == null) setError('wtype', 'Required');
        if (expController.text.trim().isEmpty) setError('exp', 'Required');
        if (eng.value == null) setError('eng', 'Required');
        if (mechsController.text.trim().isEmpty) setError('mechs', 'Required');
      }
    } else if (step == 2) {
      if (fnController.text.trim().isEmpty) setError('fn', 'Required');
      if (lnController.text.trim().isEmpty) setError('ln', 'Required');
      
      final docno = docnoController.text.trim();
      if (docno.isEmpty) {
        setError('docno', 'Required');
      } else {
        if (doctype.value == 'Aadhaar') {
          if (!RegExp(r'^\d{12}$').hasMatch(docno)) {
            setError('docno', 'Enter a valid document number (Aadhaar: 12 digits)');
          }
        } else {
          if (!RegExp(r'^[A-Z]{2}[0-9]{2}[ -]?[A-Z0-9]{11,13}$', caseSensitive: false).hasMatch(docno)) {
            setError('docno', 'Enter a valid document number');
          }
        }
      }
      
      if (doctype.value == 'Aadhaar' && !otpVerified.value) {
        setError('otp', 'Verify the Aadhaar number with OTP');
      }
      if (docfPath.value == null) setError('docf', 'Attachment required');
      
      if (bankController.text.trim().isEmpty) setError('bank', 'Required');
      if (holderController.text.trim().isEmpty) setError('holder', 'Required');
      
      final acc = accController.text.trim();
      if (acc.isEmpty) {
        setError('acc', 'Required');
      } else if (!RegExp(r'^\d{9,18}$').hasMatch(acc)) {
        setError('acc', 'Enter 9–18 digits');
      }
      
      final ifsc = ifscController.text.trim();
      if (ifsc.isEmpty) {
        setError('ifsc', 'Required');
      } else if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$', caseSensitive: false).hasMatch(ifsc)) {
        setError('ifsc', 'Format: SBIN0001234');
      }
      
      if (bankfPath.value == null) setError('bankf', 'Attachment required');
      
      if (gst.value == 'Registered') {
        final gstno = gstnoController.text.trim();
        if (gstno.isEmpty) {
          setError('gstno', 'Required');
        } else if (!RegExp(r'^\d{2}[A-Z]{5}\d{4}[A-Z][1-9A-Z]Z[0-9A-Z]$', caseSensitive: false).hasMatch(gstno)) {
          setError('gstno', 'Enter the 15-character GSTIN');
        }
      }
      
      final fssai = fssaiController.text.trim();
      if (fssai.isNotEmpty && !RegExp(r'^\d{14}$').hasMatch(fssai)) {
        setError('fssai', 'FSSAI number is 14 digits');
      }
    }
    
    return errors.isEmpty && avatarError.isEmpty;
  }

  // OTP functions
  void sendOtp() {
    final docno = docnoController.text.trim();
    if (!RegExp(r'^[2-9]\d{11}$').hasMatch(docno)) {
      docnoError.value = 'Enter a valid 12-digit Aadhaar number above first.';
      return;
    }
    docnoError.value = '';
    demoOtp.value = (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();
    otpSent.value = true;
    otpError.value = 'Demo OTP: ${demoOtp.value}';
    for (var c in otpInputs) {
      c.clear();
    }
    
    otpTimer.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpTimer.value > 0) {
        otpTimer.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void verifyOtp() {
    String entered = otpInputs.map((e) => e.text).join();
    if (entered.length < 6) {
      otpError.value = 'Enter all 6 digits of the OTP.';
      return;
    }
    if (entered == demoOtp.value) {
      otpVerified.value = true;
      otpError.value = '';
      _timer?.cancel();
    } else {
      otpError.value = 'Incorrect OTP. Try again.';
      for (var c in otpInputs) {
        c.clear();
      }
    }
  }

  void resetOtpIfAadhaarChanged() {
    if (otpVerified.value) {
      otpVerified.value = false;
      otpSent.value = false;
      demoOtp.value = null;
      docnoError.value = 'Aadhaar number changed. Verify again.';
    }
  }

  void submitForm() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline, color: Color(0xFF1B9A6C), size: 100),
              const SizedBox(height: 16),
              const Text('Sent for approval', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('${shopController.text.isNotEmpty ? shopController.text : "The customer"} is now with your manager.', textAlign: TextAlign.center),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2B2F87)),
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  child: const Text('Add another customer', style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}