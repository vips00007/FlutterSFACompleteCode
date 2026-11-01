import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';

import '../../data/datasource/remote/customer_api_service.dart';
import '../../data/models/customer_reference_data_response.dart';
import '../../data/models/customer_create_request.dart';

  import 'dart:io';

class AddOutletViewModel extends GetxController {
  final CustomerApiService _apiService = CustomerApiService();

  // Common states
  final currentStep = 0.obs;
  final maxStepReached = (-1).obs;
  final isLoading = false.obs;
  final isRefDataLoading = false.obs;
  final refDataError = ''.obs;

  // Reference Data
  final customerTypes = <CustomerTypeModel>[].obs;
  final allLookups = <LookupItem>[].obs;
  final allBeats = <BeatItem>[].obs;

  // Header / Global
  final avatarPath = RxnString();
  final avatarError = ''.obs;
  final isUploadingImage = false.obs;

  final rtypeUuid = RxnString();
  final rtypeName = ''.obs;
  final clientReqId = RxnString();

  final shopController = TextEditingController();
  final personController = TextEditingController();
  final mobileController = TextEditingController();
  final wacb = false.obs;
  final waController = TextEditingController();
  final emailController = TextEditingController();

  // Address
  final capturedGeo = RxnString();
  double? lat;
  double? lng;
  final a1Controller = TextEditingController();
  final a2Controller = TextEditingController();
  final a3Controller = TextEditingController();
  final selectedState = RxnString();
  final cityController = TextEditingController();
  final pinController = TextEditingController();
  final isLocating = false.obs;

  final statesList = [
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chhattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal",
    "Delhi",
    "Jammu and Kashmir",
    "Chandigarh",
    "Puducherry",
  ];

  // --- STEP 2 ---
  final subTypeUuid = RxnString();
  final channelUuid = RxnString();
  final segmentUuid = RxnString();
  final categoryUuid = RxnString();
  final clsUuid = RxnString();
  final beatUuid = RxnString();

  final establishedYearController = TextEditingController();
  final dob = Rxn<DateTime>();
  final dobController = TextEditingController();
  final anniversary = Rxn<DateTime>();
  final anniversaryController = TextEditingController();
  final shopSizeController = TextEditingController();
  
  final monthlyPotentialController = TextEditingController();
  final selectedBrands = <String>[].obs;
  final openTime = Rxn<TimeOfDay>();
  final closeTime = Rxn<TimeOfDay>();

  // Mechanic details
  final wtypeUuid = RxnString();
  final expController = TextEditingController();
  final eng = RxnString();
  final mechsController = TextEditingController();

  final brands = [
    'Castrol',
    'Servo',
    'Motul',
    'Gulf',
    'Shell',
    'Bosch',
    'Exide',
    'Genuine parts',
  ];
  final engs = ['Electrical', 'Mechanical', 'Both'];

  // --- STEP 3 ---
  final kycDocTypeUuid = RxnString();
  final kycDocTypeName = ''.obs;

  final fnController = TextEditingController();
  final lnController = TextEditingController();
  final docnoController = TextEditingController();

  final docfPath = RxnString();
  final isUploadingDoc = false.obs;

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

  @override
  void onInit() {
    super.onInit();
    fetchReferenceData();
  }

  Future<void> fetchReferenceData() async {
    isRefDataLoading.value = true;
    try {
      final res = await _apiService.getReferenceData();
      customerTypes.value = res.data.customerTypes;
      allLookups.value = res.data.lookups;
      allBeats.value = res.data.beats;

      if (customerTypes.isNotEmpty) {
        rtypeUuid.value = customerTypes.first.uuid;
        rtypeName.value = customerTypes.first.name.toLowerCase();
      }

      final kycTypes = kycDocTypeList;
      if (kycTypes.isNotEmpty) {
        final aadhaar = kycTypes.firstWhereOrNull(
          (e) => e.name.toLowerCase().contains('aadhaar'),
        );
        if (aadhaar != null) {
          kycDocTypeUuid.value = aadhaar.uuid;
          kycDocTypeName.value = aadhaar.name;
        } else {
          kycDocTypeUuid.value = kycTypes.first.uuid;
          kycDocTypeName.value = kycTypes.first.name;
        }
      }
    } catch (e) {
      refDataError.value = e.toString();
      Get.snackbar('API Error', 'Failed to load reference data.');
    } finally {
      isRefDataLoading.value = false;
    }
  }

  List<LookupItem> _getSortedLookups(Iterable<LookupItem> items) {
    var list = items.where((i) => i.isActive).toList();
    list.sort(
      (a, b) => (a.displayOrder ?? 999).compareTo(b.displayOrder ?? 999),
    );
    return list;
  }

  List<LookupItem> get subTypeList => _getSortedLookups(
    allLookups.where(
      (item) =>
          item.lookupType == 'SUB_TYPE' &&
          item.customerTypeUuid == rtypeUuid.value,
    ),
  );
  List<LookupItem> get channelList => _getSortedLookups(
    allLookups.where(
      (item) =>
          item.lookupType == 'CHANNEL' && item.subTypeUuid == subTypeUuid.value,
    ),
  );
  List<LookupItem> get segmentList => _getSortedLookups(
    allLookups.where(
      (item) =>
          item.lookupType == 'SEGMENT' && item.channelUuid == channelUuid.value,
    ),
  );
  List<LookupItem> get categoryList => _getSortedLookups(
    allLookups.where(
      (item) =>
          item.lookupType == 'CATEGORY' &&
          item.segmentUuid == segmentUuid.value,
    ),
  );
  List<LookupItem> get classList => _getSortedLookups(
    allLookups.where(
      (item) =>
          item.lookupType == 'CLASS' && item.categoryUuid == categoryUuid.value,
    ),
  );
  List<LookupItem> get shopSizeList => _getSortedLookups(
    allLookups.where((item) => item.lookupType == 'SHOP_SIZE'),
  );
  List<LookupItem> get monthlyPotentialList => _getSortedLookups(
    allLookups.where((item) => item.lookupType == 'MONTHLY_POTENTIAL'),
  );
  List<LookupItem> get kycDocTypeList => _getSortedLookups(
    allLookups.where((item) => item.lookupType == 'KYC_DOCUMENT_TYPE'),
  );
  List<LookupItem> get workshopTypeList => _getSortedLookups(
    allLookups.where((item) => item.lookupType == 'WORKSHOP_TYPE'),
  );
  List<BeatItem> get activeBeats => allBeats.where((b) => b.isActive).toList();

  void onCustomerTypeChanged(String uuid, String name) {
    if (rtypeUuid.value != uuid) {
      rtypeUuid.value = uuid;
      rtypeName.value = name.toLowerCase();
      onSubTypeChanged(null);
      
      // Clear mechanic specific fields
      wtypeUuid.value = null;
      expController.clear();
      eng.value = null;
      mechsController.clear();
    }
  }

  void onSubTypeChanged(String? uuid) {
    subTypeUuid.value = uuid;
    onChannelChanged(null);
  }

  void onChannelChanged(String? uuid) {
    channelUuid.value = uuid;
    onSegmentChanged(null);
  }

  void onSegmentChanged(String? uuid) {
    segmentUuid.value = uuid;
    onCategoryChanged(null);
  }

  void onCategoryChanged(String? uuid) {
    categoryUuid.value = uuid;
    clsUuid.value = null;
  }

  void onKycDocTypeChanged(String uuid, String name) {
    if (kycDocTypeUuid.value != uuid) {
      kycDocTypeUuid.value = uuid;
      kycDocTypeName.value = name;
    }
  }

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
  Future<void> pickFile(
    RxnString pathRef, {
    bool isImage = false,
    String? kind,
  }) async {
    try {
      PlatformFile? file = await FilePicker.pickFile(
        type: isImage ? FileType.image : FileType.custom,
        allowedExtensions: isImage ? null : ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (file != null && file.path != null) {
        final ioFile = File(file.path!);
        if (await ioFile.length() > 5 * 1024 * 1024) {
          Get.snackbar('Error', 'File size exceeds 5 MB');
          return;
        }
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
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      lat = position.latitude;
      lng = position.longitude;
      capturedGeo.value =
          '${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}';

      List<Placemark> placemarks = await Geocoding().placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        a1Controller.text = [
          p.street,
          p.subLocality,
        ].where((e) => e != null && e.isNotEmpty).join(', ');
        a2Controller.text = p.locality ?? '';
        a3Controller.text = p.subAdministrativeArea ?? '';
        cityController.text = p.locality ?? p.subAdministrativeArea ?? '';
        pinController.text = p.postalCode ?? '';
        if (p.administrativeArea != null &&
            statesList.contains(p.administrativeArea)) {
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
      if (subTypeList.isNotEmpty && subTypeUuid.value == null)
        setError('sub', 'Required');
      if (channelList.isNotEmpty && channelUuid.value == null)
        setError('chan', 'Required');
      if (segmentList.isNotEmpty && segmentUuid.value == null)
        setError('seg', 'Required');
      if (categoryList.isNotEmpty && categoryUuid.value == null)
        setError('cat', 'Required');
      if (classList.isNotEmpty && clsUuid.value == null)
        setError('cls', 'Required');
      if (activeBeats.isNotEmpty && beatUuid.value == null)
        setError('beat', 'Required');

      final estYear = establishedYearController.text.trim();
      if (estYear.isEmpty) {
        setError('estYear', 'Required');
      } else if (int.tryParse(estYear) == null || estYear.length != 4) {
        setError('estYear', 'Enter a valid 4-digit year');
      }

      if (dob.value == null) {
        setError('dob', 'Required');
      }
      if (anniversary.value == null) {
        setError('anniversary', 'Required');
      }

      final sizeStr = shopSizeController.text.trim();
      if (sizeStr.isEmpty) {
        setError('size', 'Required');
      } else if (int.tryParse(sizeStr) == null) {
        setError('size', 'Enter a valid numeric size');
      }

      final potStr = monthlyPotentialController.text.trim();
      if (potStr.isEmpty) {
        setError('pot', 'Required');
      } else if (int.tryParse(potStr) == null) {
        setError('pot', 'Enter a valid numeric potential');
      }

      if (selectedBrands.isEmpty) setError('brands', 'Required');

      if (openTime.value == null) setError('open', 'Required');
      if (closeTime.value == null) setError('close', 'Required');

      if (rtypeName.value.toLowerCase() == 'mechanic') {
        if (workshopTypeList.isNotEmpty && wtypeUuid.value == null)
          setError('wtype', 'Required');
        if (expController.text.trim().isEmpty) setError('exp', 'Required');
        if (eng.value == null) setError('eng', 'Required');
        if (mechsController.text.trim().isEmpty) setError('mechs', 'Required');
      }
    } else if (step == 2) {
      if (fnController.text.trim().isEmpty) setError('fn', 'Required');
      if (lnController.text.trim().isEmpty) setError('ln', 'Required');
      if (kycDocTypeUuid.value == null) setError('doctype', 'Required');

      final docno = docnoController.text.trim();
      if (docno.isEmpty) {
        setError('docno', 'Required');
      } else {
        if (kycDocTypeName.value.toLowerCase().contains('aadhaar')) {
          if (!RegExp(r'^\d{12}$').hasMatch(docno)) {
            setError(
              'docno',
              'Enter a valid document number (Aadhaar: 12 digits)',
            );
          }
        } else {
          if (!RegExp(
            r'^[A-Z]{2}[0-9]{2}[ -]?[A-Z0-9]{11,13}$',
            caseSensitive: false,
          ).hasMatch(docno)) {
            setError('docno', 'Enter a valid document number');
          }
        }
      }

      if (docfPath.value == null) {
        setError('docf', 'Attachment required');
      }

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
      } else if (!RegExp(
        r'^[A-Z]{4}0[A-Z0-9]{6}$',
        caseSensitive: false,
      ).hasMatch(ifsc)) {
        setError('ifsc', 'Format: SBIN0001234');
      }

      if (bankfPath.value == null) setError('bankf', 'Attachment required');

      if (gst.value == 'Registered') {
        final gstno = gstnoController.text.trim();
        if (gstno.isEmpty) {
          setError('gstno', 'Required');
        } else if (!RegExp(
          r'^\d{2}[A-Z]{5}\d{4}[A-Z][1-9A-Z]Z[0-9A-Z]$',
          caseSensitive: false,
        ).hasMatch(gstno)) {
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

  Future<void> submitForm() async {
    if (isLoading.value) return;

    // Ensure we have a location
    if (lat == null || lng == null) {
      Get.snackbar(
        'Error',
        'Please capture your location first in Step 1.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final kycList = <KycDocument>[];
      if (docfPath.value != null && kycDocTypeUuid.value != null) {
        String docType = 'OTHER';
        if (kycDocTypeName.value.toUpperCase().contains('AADHAAR')) {
          docType = 'AADHAAR';
        } else if (kycDocTypeName.value.toUpperCase().contains('PAN')) {
          docType = 'PAN';
        } else if (kycDocTypeName.value.toUpperCase().contains('DRIVING')) {
          docType = 'DRIVING_LICENSE';
        } else if (kycDocTypeName.value.toUpperCase().contains('PASSPORT')) {
          docType = 'PASSPORT';
        } else if (kycDocTypeName.value.toUpperCase().contains('VOTER')) {
          docType = 'VOTER_ID';
        } else {
          docType = kycDocTypeName.value.toUpperCase().replaceAll(' ', '_');
        }

        kycList.add(
          KycDocument(
            documentType: docType,
            documentNumber: docnoController.text.trim(),
            firstName: fnController.text.trim(),
            lastName: lnController.text.trim(),
            verificationRef: "ver_91c2",
            documentFileId: 'kyc-aadhaar',
          ),
        );
      }

      if (clientReqId.value == null) {
        clientReqId.value = _apiService.generateUuidV4();
      }

      final request = CustomerCreateRequest(
        customerType: rtypeUuid.value,
        shopName: shopController.text.trim(),
        contactPerson: personController.text.trim(),
        mobile: mobileController.text.trim(),
        alternateMobile: waController.text.trim().isNotEmpty
            ? waController.text.trim()
            : null,
        email: emailController.text.trim().isNotEmpty
            ? emailController.text.trim()
            : null,
        whatsappNumber: waController.text.trim().isNotEmpty
            ? waController.text.trim()
            : null,
        addressLine1: a1Controller.text.trim(),
        addressLine2: a2Controller.text.trim().isNotEmpty
            ? a2Controller.text.trim()
            : null,
        landmark: a3Controller.text.trim().isNotEmpty
            ? a3Controller.text.trim()
            : null,
        pincode: pinController.text.trim(),
        city: cityController.text.trim(),
        state: selectedState.value,
        latitude: lat,
        longitude: lng,
        subTypeUuid: subTypeUuid.value,
        channelUuid: channelUuid.value,
        segmentUuid: segmentUuid.value,
        categoryUuid: categoryUuid.value,
        classUuid: clsUuid.value,
        businessTypeCode: "PARTNERSHIP",
        source: 'EMPLOYEE',
        territoryUuid: beatUuid.value != null 
            ? allBeats.firstWhereOrNull((b) => b.uuid == beatUuid.value)?.territoryUuid 
            : null,
        beatUuid: beatUuid.value,
        clientRequestId: clientReqId.value,
        establishedYear: int.tryParse(establishedYearController.text.trim()),
        dateOfBirth: dob.value != null
            ? "${dob.value!.day.toString().padLeft(2, '0')}-${dob.value!.month.toString().padLeft(2, '0')}-${dob.value!.year}"
            : null,
        anniversaryDate: anniversary.value != null
            ? "${anniversary.value!.day.toString().padLeft(2, '0')}-${anniversary.value!.month.toString().padLeft(2, '0')}-${anniversary.value!.year}"
            : null,
        shopSizeSqFt: int.tryParse(shopSizeController.text.trim()),
        monthlyPotential: int.tryParse(monthlyPotentialController.text.trim()),
        brandsStocked: selectedBrands.isNotEmpty
            ? selectedBrands.toList()
            : null,
        shopTimings: ShopTimings(
          openTime: openTime.value != null
              ? "${openTime.value!.hour.toString().padLeft(2, '0')}:${openTime.value!.minute.toString().padLeft(2, '0')}"
              : null,
          closeTime: closeTime.value != null
              ? "${closeTime.value!.hour.toString().padLeft(2, '0')}:${closeTime.value!.minute.toString().padLeft(2, '0')}"
              : null,
        ),
        workshopType: wtypeUuid.value != null
            ? workshopTypeList
                  .firstWhereOrNull((e) => e.uuid == wtypeUuid.value)
                  ?.code
            : null,
        experienceYears: int.tryParse(expController.text.trim()),
        engineSpecialty: eng.value?.toUpperCase(),
        mechanicCount: int.tryParse(mechsController.text.trim()),
        bank: BankDetails(
          bankName: bankController.text.trim().isNotEmpty
              ? bankController.text.trim()
              : null,
          accountHolder: holderController.text.trim().isNotEmpty
              ? holderController.text.trim()
              : null,
          accountNumber: accController.text.trim().isNotEmpty
              ? accController.text.trim()
              : null,
          ifsc: ifscController.text.trim().isNotEmpty
              ? ifscController.text.trim()
              : null,
          accountType: "SAVINGS",
          proofClientRef: 'bank-proof',
        ),
        gstRegistrationType: gst.value.toUpperCase(),
        gstNumber: gstnoController.text.trim().isNotEmpty
            ? gstnoController.text.trim()
            : null,
        gstCategory: gst.value == 'Registered'
            ? gstcat.value.toUpperCase()
            : null,
        credit: CreditDetails(
          creditLimit: 100000,
          creditDays: 30,
          openingBalance: 0,
        ),
        shopImageFileRef: null,
        kyc: kycList.isNotEmpty ? kycList : null,
        attachments: [],
      );

      final res = await _apiService.createCustomer(
        request,
        shopImagePath: avatarPath.value,
        aadhaarPath: docfPath.value,
        bankProofPath: bankfPath.value,
      );

      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF1B9A6C),
                  size: 100,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sent for approval',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '${shopController.text.isNotEmpty ? shopController.text : "The customer"} is now with your manager.\nRef: ${res.data?.customerCode ?? ""}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2B2F87),
                    ),
                    onPressed: () {
                      Get.back();
                      Get.back();
                    },
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
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
}
