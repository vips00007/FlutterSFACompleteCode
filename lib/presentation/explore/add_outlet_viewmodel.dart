import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/colors/app_colors.dart';

class AddOutletViewModel extends GetxController {
  // Step Management
  final currentStep = 1.obs;

  // Step 1: Basics
  final customerType = 'Retailer'.obs;

  // Basic Info
  final shopNameController = TextEditingController(text: 'Sharma Auto Parts');
  final contactPersonController = TextEditingController(text: 'Rajesh Sharma');
  final mobileController = TextEditingController(text: '98765 43210');
  final altMobileController = TextEditingController();
  final emailController = TextEditingController();
  final whatsappController = TextEditingController();

  // Address
  final addressController = TextEditingController(text: 'Vijay Nagar');
  final pinCodeController = TextEditingController(text: '452010');

  // Geo Data
  final state = 'Madhya Pradesh'.obs;
  final city = 'Indore'.obs;
  final territory = 'Indore East'.obs;
  final isPinMapped = true.obs;

  // Step 2: Classification
  final subType = 'Retailer'.obs;
  final channel = 'General Trade'.obs;
  final segment = 'Automotive'.obs;
  final category = 'A'.obs;
  final classificationClass = 'Premium'.obs;
  final beatArea = ''.obs;

  final beatAreas = <String>[
    'Vijay Nagar Beat (Mon)',
    'Palasia Beat (Tue)',
    'Bhawarkua Beat (Wed)',
  ].obs;

  // Step 3: Details & Docs

  // Expanded states
  final isBusinessInfoExpanded = false.obs;
  final isKycExpanded = false.obs;
  final isBankExpanded = false.obs;

  // Business Info
  final regNumberController = TextEditingController();
  final businessType = 'Proprietorship'.obs;
  final estYearController = TextEditingController();

  // Type Specific Details
  final shopSize = 'Small (<200 sq ft)'.obs; // Retailer
  final monthlyPotential = '₹1–3 L'.obs; // Retailer
  final brandsStockedController = TextEditingController(); // Retailer
  final shopTimingsController = TextEditingController(); // Retailer

  final workshopType = 'Two-wheeler'.obs; // Mechanic
  final experienceController = TextEditingController(); // Mechanic
  final specializationController = TextEditingController(); // Mechanic
  final mechanicsCountController = TextEditingController(); // Mechanic

  // KYC
  final panController = TextEditingController();
  final gstController = TextEditingController();
  final kycDocType = 'Aadhaar'.obs;

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
    pinCodeController.addListener(_onPinCodeChanged);
    channel.listen((_) => _loadBeats());
  }

  void _onPinCodeChanged() {
    final pin = pinCodeController.text;
    if (pin.length == 6) {
      if (pin == '452010') {
        state.value = 'Madhya Pradesh';
        city.value = 'Indore';
        territory.value = 'Indore East';
        isPinMapped.value = true;
      } else if (pin == '452001') {
        state.value = 'Madhya Pradesh';
        city.value = 'Indore';
        territory.value = 'Indore Central';
        isPinMapped.value = true;
      } else if (pin == '462001') {
        state.value = 'Madhya Pradesh';
        city.value = 'Bhopal';
        territory.value = 'Bhopal North';
        isPinMapped.value = true;
      } else {
        state.value = 'Madhya Pradesh (guess)';
        city.value = '—';
        territory.value = 'Select territory';
        isPinMapped.value = false;
      }
    }
  }

  void _loadBeats() {
    if (channel.value == 'General Trade') {
      beatAreas.value = [
        'Vijay Nagar Beat (Mon)',
        'Palasia Beat (Tue)',
        'Bhawarkua Beat (Wed)',
      ];
    } else if (channel.value == 'Modern Trade') {
      beatAreas.value = ['Treasure Island Cluster'];
    } else {
      beatAreas.value = [];
    }
    beatArea.value = '';
  }

  void toggleCustomerType(String type) {
    customerType.value = type;
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
    } else if (currentStep.value == 2) {
      if (beatArea.value.isEmpty) {
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
                        '${beatArea.value} · ${selectedFileName.value}',
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
      // Simulate API call processing a multipart request
      await Future.delayed(const Duration(seconds: 2));

      if (!context.mounted) return;
      // Show success dialog matching ov2
      _showSuccessDialog(context);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save outlet',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showSuccessDialog(BuildContext context) {
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
                      const TextSpan(
                        text: 'CUST-2026-004871',
                        style: TextStyle(
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
    brandsStockedController.dispose();
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
