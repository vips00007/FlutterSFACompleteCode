import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import '../../core/colors/app_colors.dart';
import '../../data/datasource/remote/customer_api_service.dart';
import '../../data/models/customer_reference_data_response.dart';
import '../../data/models/geography_response.dart';
import '../../data/models/customer_create_request.dart';

class AddOutletViewModel extends GetxController {
  final CustomerApiService _customerApiService = CustomerApiService();

  // Step Management
  final currentStep = 1.obs;

  // Step 1: Basics
  final customerType = 'Retailer'.obs;
  final customerTypeUuid = ''.obs;
  final customerTypeCode = ''.obs;

  final customerTypes = <CustomerTypeModel>[].obs;
  final isCustomerTypesLoading = false.obs;
  final customerTypesError = ''.obs;

  // Basic Info
  final shopNameController = TextEditingController(text: 'Sharma Auto Parts');
  final contactPersonController = TextEditingController(text: 'Rajesh Sharma');
  final mobileController = TextEditingController(text: '98765 43210');
  final altMobileController = TextEditingController();
  final emailController = TextEditingController();
  final whatsappController = TextEditingController();

  // Address
  final addressController = TextEditingController();
  final pinCodeController = TextEditingController();

  final latitude = RxnDouble();
  final longitude = RxnDouble();
  final isLocationLoading = false.obs;

  // Geo Data API
  final allGeographies = <GeographyItem>[].obs;
  final isGeographyLoading = false.obs;
  final geographyError = ''.obs;

  final selectedStateUuid = RxnString();
  final selectedCityUuid = RxnString();
  final selectedTerritoryUuid = RxnString();

  List<GeographyItem> get stateList => allGeographies
      .where((item) => item.type.toUpperCase() == 'STATE')
      .toList();

  List<GeographyItem> get cityList => allGeographies
      .where(
        (item) =>
            item.type.toUpperCase() == 'REGION' &&
            item.parentUuid == selectedStateUuid.value,
      )
      .toList();

  List<GeographyItem> get territoryList => allGeographies
      .where(
        (item) =>
            item.type.toUpperCase() == 'TERRITORY' &&
            item.parentUuid == selectedCityUuid.value,
      )
      .toList();

  String? get stateName {
    if (selectedStateUuid.value == null) return null;
    return allGeographies
        .firstWhereOrNull((g) => g.uuid == selectedStateUuid.value)
        ?.name;
  }

  String? get cityName {
    if (selectedCityUuid.value == null) return null;
    return allGeographies
        .firstWhereOrNull((g) => g.uuid == selectedCityUuid.value)
        ?.name;
  }

  // Step 2: Classification
  final allLookups = <LookupItem>[].obs;
  final allBeats = <BeatItem>[].obs;

  final selectedSubTypeUuid = RxnString();
  final selectedChannelUuid = RxnString();
  final selectedSegmentUuid = RxnString();
  final selectedCategoryUuid = RxnString();
  final selectedClassUuid = RxnString();
  final selectedBeatUuid = RxnString();

  // Sorting helper
  List<LookupItem> _getSortedLookups(Iterable<LookupItem> items) {
    var list = items
        .where(
          (i) =>
              i.isActive &&
              i.uuid.isNotEmpty &&
              i.uuid != '0' &&
              !i.name.toLowerCase().contains('select'),
        )
        .toList();
    list.sort(
      (a, b) => (a.displayOrder ?? 999).compareTo(b.displayOrder ?? 999),
    );
    return list;
  }

  List<LookupItem> get subTypeList => _getSortedLookups(
    allLookups.where(
      (item) =>
          item.lookupType == 'SUB_TYPE' &&
          item.customerTypeUuid == customerTypeUuid.value,
    ),
  );

  List<LookupItem> get channelList => _getSortedLookups(
    allLookups.where(
      (item) =>
          item.lookupType == 'CHANNEL' &&
          item.subTypeUuid == selectedSubTypeUuid.value,
    ),
  );

  List<LookupItem> get segmentList => _getSortedLookups(
    allLookups.where(
      (item) =>
          item.lookupType == 'SEGMENT' &&
          item.channelUuid == selectedChannelUuid.value,
    ),
  );

  List<LookupItem> get categoryList => _getSortedLookups(
    allLookups.where(
      (item) =>
          item.lookupType == 'CATEGORY' &&
          item.segmentUuid == selectedSegmentUuid.value,
    ),
  );

  List<LookupItem> get classList => _getSortedLookups(
    allLookups.where(
      (item) =>
          item.lookupType == 'CLASS' &&
          item.categoryUuid == selectedCategoryUuid.value,
    ),
  );

  List<LookupItem> get shopSizeList => _getSortedLookups(
    allLookups.where((item) => item.lookupType == 'SHOP_SIZE'),
  );

  List<LookupItem> get monthlyPotentialList => _getSortedLookups(
    allLookups.where((item) => item.lookupType == 'MONTHLY_POTENTIAL'),
  );

  List<LookupItem> get businessTypeList => _getSortedLookups(
    allLookups.where((item) => item.lookupType == 'BUSINESS_TYPE'),
  );

  List<LookupItem> get kycDocTypeList => _getSortedLookups(
    allLookups.where((item) => item.lookupType == 'KYC_DOCUMENT_TYPE'),
  );

  List<BeatItem> get beatList => allBeats.toList();

  String _getLookupName(String? uuid) {
    if (uuid == null) return 'N/A';
    return allLookups.firstWhereOrNull((l) => l.uuid == uuid)?.name ?? 'N/A';
  }

  String get subTypeName => _getLookupName(selectedSubTypeUuid.value);
  String get channelName => _getLookupName(selectedChannelUuid.value);
  String get segmentName => _getLookupName(selectedSegmentUuid.value);
  String get categoryName => _getLookupName(selectedCategoryUuid.value);
  String get className => _getLookupName(selectedClassUuid.value);
  String get shopSizeName => _getLookupName(selectedShopSizeUuid.value);
  String get monthlyPotentialName =>
      _getLookupName(selectedMonthlyPotentialUuid.value);
  String get businessTypeName => _getLookupName(selectedBusinessTypeUuid.value);
  String get kycDocTypeName => _getLookupName(selectedKycDocTypeUuid.value);
  String get beatName {
    if (selectedBeatUuid.value == null) return 'N/A';
    return allBeats
            .firstWhereOrNull((b) => b.uuid == selectedBeatUuid.value)
            ?.name ??
        'N/A';
  }

  // Step 3: Details & Docs

  // Expanded states
  final isBusinessInfoExpanded = false.obs;
  final isKycExpanded = false.obs;
  final isBankExpanded = false.obs;

  // Business Info
  final regNumberController = TextEditingController();
  final selectedBusinessTypeUuid = RxnString();
  final estYearController = TextEditingController();

  // Type Specific Details
  final selectedShopSizeUuid = RxnString(); // Retailer
  final selectedMonthlyPotentialUuid = RxnString(); // Retailer

  final availableBrands = ['MRF', 'Bosch', 'Exide'];
  final selectedBrands = <String>[].obs; // Retailer

  final shopTimingsController = TextEditingController(); // Retailer

  final workshopType = 'Two-wheeler'.obs; // Mechanic
  final experienceController = TextEditingController(); // Mechanic
  final specializationController = TextEditingController(); // Mechanic
  final mechanicsCountController = TextEditingController(); // Mechanic

  // KYC
  final panController = TextEditingController();
  final gstRegistrationType = 'UNREGISTERED'.obs;
  final gstController = TextEditingController();
  final selectedKycDocTypeUuid = RxnString();

  // Bank
  final bankNameController = TextEditingController();
  final accHolderController = TextEditingController();
  final accNumberController = TextEditingController();
  final ifscController = TextEditingController();

  // Attachments
  final selectedFileName = ''.obs;
  PlatformFile? selectedFile;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomerReferenceData();
    fetchGeographyData().then((_) {
      fetchCurrentLocationAndAddress();
    });
  }

  Future<void> fetchGeographyData() async {
    isGeographyLoading.value = true;
    geographyError.value = '';

    try {
      final response = await _customerApiService.getGeographyData();
      allGeographies.value = response.data.items;
    } catch (e) {
      geographyError.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isGeographyLoading.value = false;
    }
  }

  void onStateSelected(String? uuid) {
    selectedStateUuid.value = uuid;
    selectedCityUuid.value = null;
    selectedTerritoryUuid.value = null;
  }

  void onCitySelected(String? uuid) {
    selectedCityUuid.value = uuid;
    selectedTerritoryUuid.value = null;
  }

  void onTerritorySelected(String? uuid) {
    selectedTerritoryUuid.value = uuid;
  }

  Future<void> fetchCurrentLocationAndAddress() async {
    isLocationLoading.value = true;
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Location Required',
            'Location permission denied. Cannot auto-fetch address.',
            backgroundColor: Colors.orangeAccent,
            colorText: Colors.white,
          );
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Location Required',
          'Location permissions are permanently denied. Please enable from settings to auto-fetch address.',
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
        );
        return;
      }

      bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        Get.snackbar(
          'Location Required',
          'GPS is disabled. Please enable location services.',
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      List<geocoding.Placemark> placemarks = await geocoding.Geocoding()
          .placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        geocoding.Placemark place = placemarks.first;

        List<String> addressParts = [];
        if (place.street != null && place.street!.isNotEmpty)
          addressParts.add(place.street!);
        if (place.subLocality != null && place.subLocality!.isNotEmpty)
          addressParts.add(place.subLocality!);
        if (place.locality != null && place.locality!.isNotEmpty)
          addressParts.add(place.locality!);
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty)
          addressParts.add(place.administrativeArea!);

        if (addressController.text.trim().isEmpty) {
          addressController.text = addressParts.join(', ');
        }

        debugPrint('\n===== AUTO-FETCHED LOCATION =====');
        debugPrint('Address: ${addressParts.join(', ')}');
        debugPrint('Pincode: ${place.postalCode}');
        debugPrint('Lat/Lng: ${position.latitude}, ${position.longitude}');
        debugPrint('=================================\n');

        if (place.postalCode != null && pinCodeController.text.trim().isEmpty) {
          pinCodeController.text = place.postalCode!;
        }

        // Try to match state
        if (place.administrativeArea != null && allGeographies.isNotEmpty) {
          final stateItem = allGeographies.firstWhereOrNull(
            (g) =>
                g.type.toUpperCase() == 'STATE' &&
                g.name.toLowerCase() == place.administrativeArea!.toLowerCase(),
          );
          if (stateItem != null && selectedStateUuid.value == null) {
            onStateSelected(stateItem.uuid);

            // Try to match city
            String? cityNameToMatch =
                place.locality ?? place.subAdministrativeArea;
            if (cityNameToMatch != null && cityNameToMatch.isNotEmpty) {
              final cityItem = allGeographies.firstWhereOrNull(
                (g) =>
                    g.type.toUpperCase() == 'REGION' &&
                    g.parentUuid == stateItem.uuid &&
                    g.name.toLowerCase() == cityNameToMatch.toLowerCase(),
              );
              if (cityItem != null && selectedCityUuid.value == null) {
                onCitySelected(cityItem.uuid);
              }
            }
          }
        }
      }
    } catch (e) {
      Get.snackbar(
        'Location Notice',
        'Could not fetch current address. Please enter manually.',
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
      );
    } finally {
      isLocationLoading.value = false;
    }
  }

  Future<void> fetchCustomerReferenceData() async {
    isCustomerTypesLoading.value = true;
    customerTypesError.value = '';

    try {
      final response = await _customerApiService.getReferenceData();
      customerTypes.value = response.data.customerTypes;
      allLookups.value = response.data.lookups;
      allBeats.value = response.data.beats;

      // Preserve current selection if it exists in the fetched list
      if (customerTypes.isNotEmpty) {
        final existingType = customerTypes.firstWhereOrNull(
          (t) =>
              t.name.toLowerCase() == customerType.value.toLowerCase() ||
              t.code.toLowerCase() == customerType.value.toLowerCase(),
        );

        if (existingType != null) {
          customerType.value = existingType.name;
          customerTypeUuid.value = existingType.uuid;
          customerTypeCode.value = existingType.code;
        } else {
          // If default isn't found, pick the first one
          customerType.value = customerTypes.first.name;
          customerTypeUuid.value = customerTypes.first.uuid;
          customerTypeCode.value = customerTypes.first.code;
        }
      }
    } catch (e) {
      customerTypesError.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isCustomerTypesLoading.value = false;
    }
  }

  void toggleCustomerType(CustomerTypeModel type) {
    if (customerTypeUuid.value != type.uuid) {
      customerType.value = type.name;
      customerTypeUuid.value = type.uuid;
      customerTypeCode.value = type.code;
      onSubTypeSelected(null);
    }
  }

  void onSubTypeSelected(String? uuid) {
    selectedSubTypeUuid.value = uuid;
    onChannelSelected(null);
  }

  void onChannelSelected(String? uuid) {
    selectedChannelUuid.value = uuid;
    onSegmentSelected(null);
  }

  void onSegmentSelected(String? uuid) {
    selectedSegmentUuid.value = uuid;
    onCategorySelected(null);
  }

  void onCategorySelected(String? uuid) {
    selectedCategoryUuid.value = uuid;
    onClassSelected(null);
  }

  void onClassSelected(String? uuid) {
    selectedClassUuid.value = uuid;
  }

  void onShopSizeSelected(String? uuid) {
    selectedShopSizeUuid.value = uuid;
  }

  void onMonthlyPotentialSelected(String? uuid) {
    selectedMonthlyPotentialUuid.value = uuid;
  }

  void onBusinessTypeSelected(String? uuid) {
    selectedBusinessTypeUuid.value = uuid;
  }

  void onKycDocTypeSelected(String? uuid) {
    selectedKycDocTypeUuid.value = uuid;
  }

  void onBeatSelected(String? uuid) {
    selectedBeatUuid.value = uuid;
  }

  void nextStep(BuildContext context) {
    if (currentStep.value < 3) {
      if (_validateCurrentStep()) {
        currentStep.value++;
      }
    } else {
      if (_validateCurrentStep()) {
        _showSubmitDialog(context);
      }
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  bool _validateCurrentStep() {
    if (currentStep.value == 1) {
      if (shopNameController.text.length < 3) {
        Get.snackbar(
          'Validation Error',
          'Shop Name is required (min 3 chars)',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
      if (contactPersonController.text.trim().isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Contact Person is required',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
      if (mobileController.text
              .trim()
              .replaceAll(RegExp(r'[^0-9]'), '')
              .length !=
          10) {
        Get.snackbar(
          'Validation Error',
          'Valid 10-digit Mobile is required',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
      if (addressController.text.trim().isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Address Line 1 is required',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
      if (pinCodeController.text.trim().isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Pincode is required',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
      if (selectedStateUuid.value == null ||
          selectedCityUuid.value == null ||
          selectedTerritoryUuid.value == null) {
        Get.snackbar(
          'Validation Error',
          'Geography selection (State, City, Territory) is required',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
    } else if (currentStep.value == 2) {
      if (subTypeList.isNotEmpty && selectedSubTypeUuid.value == null) {
        Get.snackbar(
          'Validation Error',
          'Sub Type is required',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
      if (channelList.isNotEmpty && selectedChannelUuid.value == null) {
        Get.snackbar(
          'Validation Error',
          'Channel is required',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
      if (segmentList.isNotEmpty && selectedSegmentUuid.value == null) {
        Get.snackbar(
          'Validation Error',
          'Segment is required',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
      if (categoryList.isNotEmpty && selectedCategoryUuid.value == null) {
        Get.snackbar(
          'Validation Error',
          'Category is required',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
      if (classList.isNotEmpty && selectedClassUuid.value == null) {
        Get.snackbar(
          'Validation Error',
          'Class is required',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
      if (beatList.isNotEmpty && selectedBeatUuid.value == null) {
        Get.snackbar(
          'Validation Error',
          'Beat Area is required',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
    } else if (currentStep.value == 3) {
      if (selectedFile == null) {
        Get.snackbar(
          'Validation Error',
          'Attachment is required',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
    }
    return true;
  }

  Future<void> pickFile() async {
    try {
      PlatformFile? file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (file != null) {
        // Max 5 MB validation
        int size = file.lengthSync() ?? 0;
        if (size == 0) {
          size = await file.length() ?? 0;
        }

        if (size > 5 * 1024 * 1024) {
          Get.snackbar(
            'Error',
            'File must be under 5 MB',
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
          return;
        }

        selectedFile = file;
        selectedFileName.value = file.name;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick file',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void removeFile() {
    selectedFile = null;
    selectedFileName.value = '';
  }

  void _showSubmitDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('❓', style: TextStyle(fontSize: 34)),
                const SizedBox(height: 8),
                const Text(
                  'Submit Customer?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B2733),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Are you sure you want to submit this customer?',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7A8C)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F6FA),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1B2733),
                          ),
                          children: [
                            TextSpan(
                              text: customerType.value,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: ' · ${shopNameController.text}'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$beatName · ${selectedFileName.value}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1B2733),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1B2733),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          side: const BorderSide(
                            color: Color(0xFFD9E1EA),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(99),
                          ),
                          minimumSize: const Size(0, 40),
                        ),
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Cancel',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 6,
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: isLoading.value
                              ? null
                              : () {
                                  Navigator.pop(dialogContext);
                                  submitOutlet(context);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryPurple,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            shadowColor: AppColors.primaryPurple.withValues(
                              alpha: 0.3,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(99),
                            ),
                            minimumSize: const Size(0, 40),
                          ),
                          child: isLoading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Confirm & Submit',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> submitOutlet(BuildContext context) async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      // 1. Get Location (fallback if not fetched initially)
      if (latitude.value == null || longitude.value == null) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            Get.snackbar(
              'Location Required',
              'Please allow location access to create a customer',
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
            isLoading.value = false;
            return;
          }
        }

        if (permission == LocationPermission.deniedForever) {
          Get.snackbar(
            'Location Required',
            'Location permissions are permanently denied, please enable from settings',
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
          isLoading.value = false;
          return;
        }

        bool isLocationServiceEnabled =
            await Geolocator.isLocationServiceEnabled();
        if (!isLocationServiceEnabled) {
          Get.snackbar(
            'Location Required',
            'GPS is disabled. Please enable location services.',
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
          isLoading.value = false;
          return;
        }

        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 10),
          ),
        );
        latitude.value = position.latitude;
        longitude.value = position.longitude;
      }

      // 2. Build Request Payload
      final request = CustomerCreateRequest(
        customerType: customerTypeUuid.value,
        shopName: shopNameController.text.trim(),
        contactPerson: contactPersonController.text.trim(),
        mobile: mobileController.text.trim().replaceAll(RegExp(r'[^0-9]'), ''),
        alternateMobile: altMobileController.text.trim().isNotEmpty
            ? altMobileController.text.trim().replaceAll(RegExp(r'[^0-9]'), '')
            : null,
        email: emailController.text.trim().isNotEmpty
            ? emailController.text.trim()
            : null,
        addressLine1: addressController.text.trim(),
        pincode: pinCodeController.text.trim(),
        city: cityName,
        state: stateName,
        latitude: latitude.value!,
        longitude: longitude.value!,
        gstRegistrationType: gstRegistrationType.value,
        pan: panController.text.trim().isNotEmpty
            ? panController.text.trim()
            : null,
        gst: gstController.text.trim().isNotEmpty
            ? gstController.text.trim()
            : null,
        subTypeUuid: selectedSubTypeUuid.value ?? '',
        channelUuid: selectedChannelUuid.value ?? '',
        segmentUuid: selectedSegmentUuid.value ?? '',
        categoryUuid: selectedCategoryUuid.value ?? '',
        classUuid: selectedClassUuid.value ?? '',
        source: 'EMPLOYEE',
        territoryUuid: selectedTerritoryUuid.value ?? '',
        beatUuid: selectedBeatUuid.value,
        clientRequestId: _customerApiService.generateUuidV4(),
        shopSizeCode: selectedShopSizeUuid.value,
        monthlyPotentialCode: selectedMonthlyPotentialUuid.value,
        businessTypeCode: selectedBusinessTypeUuid.value,
        kycDocTypeUuid: selectedKycDocTypeUuid.value,
        regNumber: regNumberController.text.trim().isNotEmpty
            ? regNumberController.text.trim()
            : null,
        estYear: estYearController.text.trim().isNotEmpty
            ? estYearController.text.trim()
            : null,
        brandsStocked: selectedBrands.isNotEmpty
            ? selectedBrands.toList()
            : null,
        shopTimings: shopTimingsController.text.trim().isNotEmpty
            ? shopTimingsController.text.trim()
            : null,
        workshopType: workshopType.value.isNotEmpty ? workshopType.value : null,
        experience: experienceController.text.trim().isNotEmpty
            ? experienceController.text.trim()
            : null,
        specialization: specializationController.text.trim().isNotEmpty
            ? specializationController.text.trim()
            : null,
        mechanicsCount: mechanicsCountController.text.trim().isNotEmpty
            ? mechanicsCountController.text.trim()
            : null,
        bankName: bankNameController.text.trim().isNotEmpty
            ? bankNameController.text.trim()
            : null,
        accHolder: accHolderController.text.trim().isNotEmpty
            ? accHolderController.text.trim()
            : null,
        accNumber: accNumberController.text.trim().isNotEmpty
            ? accNumberController.text.trim()
            : null,
        ifsc: ifscController.text.trim().isNotEmpty
            ? ifscController.text.trim()
            : null,
      );

      // --- DEBUG LOGGING ---
      try {
        final jsonPayload = const JsonEncoder.withIndent(
          '  ',
        ).convert(request.toJson());
        debugPrint(
          '\n===== CUSTOMER_CREATE_REQUEST =====\n$jsonPayload\n===================================\n',
        );
      } catch (logError) {
        debugPrint('Failed to encode CUSTOMER_CREATE_REQUEST: $logError');
      }
      // ---------------------

      // 3. Call API
      final response = await _customerApiService.createCustomer(request);

      if (!context.mounted) return;

      String customerCode = response.data?.customerCode ?? 'N/A';

      // Show success dialog
      _showSuccessDialog(context, customerCode);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showSuccessDialog(BuildContext context, String customerCode) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: AppColors.lightBlueBackground,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '✓',
                      style: TextStyle(
                        fontSize: 34,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Customer Submitted',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B2733),
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7A8C),
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text:
                            '${shopNameController.text} has been sent for approval.\n',
                      ),
                      const TextSpan(text: 'Ref: '),
                      TextSpan(
                        text: customerCode,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B2733),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          // Reset form and go back to step 1
                          currentStep.value = 1;
                          shopNameController.clear();
                          contactPersonController.clear();
                          removeFile();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primaryPurple,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          side: const BorderSide(
                            color: AppColors.primaryPurple,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(99),
                          ),
                          minimumSize: const Size(0, 40),
                        ),
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Add Another',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          Get.back(); // Or navigate to customer list
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          shadowColor: AppColors.primaryPurple.withValues(
                            alpha: 0.3,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(99),
                          ),
                          minimumSize: const Size(0, 40),
                        ),
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'View Customer',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void onClose() {
    shopNameController.dispose();
    contactPersonController.dispose();
    mobileController.dispose();
    altMobileController.dispose();
    emailController.dispose();
    whatsappController.dispose();
    addressController.dispose();
    pinCodeController.dispose();
    regNumberController.dispose();
    estYearController.dispose();
    shopTimingsController.dispose();
    experienceController.dispose();
    specializationController.dispose();
    mechanicsCountController.dispose();
    panController.dispose();
    gstController.dispose();
    bankNameController.dispose();
    accHolderController.dispose();
    accNumberController.dispose();
    ifscController.dispose();
    super.onClose();
  }
}
