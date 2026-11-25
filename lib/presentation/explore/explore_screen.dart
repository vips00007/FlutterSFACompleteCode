import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'add_outlet_viewmodel.dart';
import '../dashboard/dashboard_viewmodel.dart';
import 'widgets/otp_verification_bottom_sheet.dart';
import 'widgets/outlet_preview_bottom_sheet.dart';

class HtmlColors {
  static const Color bg = Color(0xFFF4F3F9);
  static const Color card = Colors.white;
  static const Color ink = Color(0xFF17193F);
  static const Color mut = Color(0xFF6B6F93);
  static const Color line = Color(0xFFDCDBEA);
  static const Color pri = Color(0xFF6A3FD6);
  static const Color acc = Color(0xFFFF9F1C);
  static const Color bad = Color(0xFFD62839);
  static const Color ok = Color(0xFF1B9A6C);
  static const Color dotBorder = Color(0xFFB4BCD9);
  static const Color dotText = Color(0xFF8A93B2);
  static const Color lineConnector = Color(0xFFC3C9E2);
  static const Color stepDone = Color(0xFF22C55E);
}

class AddOutletScreen extends StatefulWidget {
  const AddOutletScreen({super.key});

  @override
  State<AddOutletScreen> createState() => _AddOutletScreenState();
}

class _AddOutletScreenState extends State<AddOutletScreen> {
  late final AddOutletViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Get.put(AddOutletViewModel());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HtmlColors.bg,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildHeader(viewModel),
                _buildStepper(viewModel),
                Expanded(
                  child: SingleChildScrollView(
                    controller: viewModel.scrollController,
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                    child: _buildStepCard(viewModel, context),
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            if (viewModel.isRefDataLoading.value) {
              return Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: const Center(
                  child: CircularProgressIndicator(color: HtmlColors.pri),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(viewModel, context),
    );
  }

  // Header matching compact HTML redesign specification with full-header image cover
  Widget _buildHeader(AddOutletViewModel viewModel) {
    return Obx(() {
      final avatarPath = viewModel.avatarPath.value;
      final hasAvatar = avatarPath != null && avatarPath.isNotEmpty;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.fromLTRB(14, hasAvatar ? 16 : 12, 14, 12),
        constraints: BoxConstraints(minHeight: hasAvatar ? 140 : 60),
        decoration: BoxDecoration(
          color: HtmlColors.pri,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
          boxShadow: [
            BoxShadow(
              color: HtmlColors.pri.withValues(alpha: 0.18),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
          image: hasAvatar
              ? DecorationImage(
                  image: FileImage(File(avatarPath)),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.45),
                    BlendMode.darken,
                  ),
                )
              : null,
        ),
        child: Row(
          crossAxisAlignment:
              hasAvatar ? CrossAxisAlignment.end : CrossAxisAlignment.center,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                final dashboardViewModel = Get.find<DashboardViewModel>();
                dashboardViewModel.changeTabIndex(0);
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: viewModel.shopController,
                    builder: (context, value, child) {
                      final text = value.text.trim();
                      return Text(
                        text.isNotEmpty ? text : 'New customer',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          shadows: hasAvatar
                              ? [
                                  const Shadow(
                                    color: Colors.black54,
                                    blurRadius: 4,
                                  )
                                ]
                              : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                  const SizedBox(height: 1),
                  Obx(
                    () => Text(
                      'Step ${viewModel.currentStep.value + 1} of 3',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12,
                        shadows: hasAvatar
                            ? [
                                const Shadow(
                                  color: Colors.black54,
                                  blurRadius: 4,
                                )
                              ]
                            : null,
                      ),
                    ),
                  ),
                  Obx(() {
                    if (viewModel.avatarError.value.isNotEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Text(
                          'Shop photo required - tap camera',
                          style: TextStyle(
                            color: Color(0xFFFFD166),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
            const SizedBox(width: 10),
            _buildCameraAvatar(viewModel),
          ],
        ),
      );
    });
  }

  // Right Camera Button (.hav)
  Widget _buildCameraAvatar(AddOutletViewModel viewModel) {
    return Obx(() {
      final isError = viewModel.avatarError.isNotEmpty;
      final isUploading = viewModel.isUploadingImage.value;

      return GestureDetector(
        onTap: isUploading
            ? null
            : () => viewModel.showImageSourceSheet(
                  viewModel.avatarPath,
                  kind: 'SHOP_IMAGE',
                ),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.25),
            border: Border.all(
              color: isError
                  ? const Color(0xFFFFD166)
                  : Colors.white.withValues(alpha: 0.8),
              width: 1.5,
            ),
          ),
          child: isUploading
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 20,
                ),
        ),
      );
    });
  }

  // Sticky Horizontal Stepper (.stp) with extended lines
  Widget _buildStepper(AddOutletViewModel viewModel) {
    final titles = ['Shop Info', 'Classification', 'KYC | Bank | License'];

    return Obx(() {
      final cur = viewModel.currentStep.value;

      return Container(
        color: HtmlColors.bg,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: List.generate(titles.length * 2 - 1, (i) {
            if (i.isEven) {
              final index = i ~/ 2;
              final isCur = cur == index;
              final isDone = viewModel.maxStepReached.value >= index && !isCur;

              return GestureDetector(
                onTap: () => viewModel.goStep(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDone ? HtmlColors.stepDone : HtmlColors.card,
                        border: Border.all(
                          color: isDone
                              ? HtmlColors.stepDone
                              : (isCur
                                  ? HtmlColors.pri
                                  : HtmlColors.dotBorder),
                          width: 2.5,
                        ),
                        boxShadow: isCur
                            ? [
                                BoxShadow(
                                  color: HtmlColors.pri.withValues(alpha: 0.15),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: isDone
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 20,
                              )
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isCur
                                      ? HtmlColors.pri
                                      : HtmlColors.dotText,
                                  fontSize: 14,
                                  fontWeight: isCur
                                      ? FontWeight.w800
                                      : FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      titles[index],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isCur ? FontWeight.w800 : FontWeight.w600,
                        color: isCur
                            ? HtmlColors.pri
                            : (isDone ? HtmlColors.ink : HtmlColors.dotText),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else {
              final prevIndex = (i - 1) ~/ 2;
              final isLineOn =
                  viewModel.maxStepReached.value >= prevIndex || cur > prevIndex;

              return Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.only(left: 6, right: 6, bottom: 18),
                  decoration: BoxDecoration(
                    color: isLineOn ? HtmlColors.pri : HtmlColors.lineConnector,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }
          }),
        ),
      );
    });
  }

  // Main Card (.card)
  Widget _buildStepCard(AddOutletViewModel viewModel, BuildContext context) {
    return Obx(() {
      final step = viewModel.currentStep.value;
      Widget content = const SizedBox.shrink();

      if (step == 0) {
        content = _buildStep1Fields(viewModel, context);
      } else if (step == 1) {
        content = _buildStep2Fields(viewModel, context);
      } else if (step == 2) {
        content = _buildStep3Fields(viewModel);
      }

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: HtmlColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: HtmlColors.line),
          boxShadow: [
            BoxShadow(
              color: HtmlColors.ink.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: content,
      );
    });
  }

  // Section divider matching compact HTML spec (.sub)
  Widget _sub(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      padding: const EdgeInsets.only(left: 9, top: 1, bottom: 1),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: HtmlColors.pri, width: 3),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: HtmlColors.ink,
        ),
      ),
    );
  }

  // Field Wrapper (.fld)
  Widget _fld({
    required AddOutletViewModel viewModel,
    required String key,
    required String label,
    required Widget child,
    bool isOpt = false,
  }) {
    return Obx(() {
      final error = viewModel.getError(key);
      final hasErr = error.isNotEmpty;

      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: RichText(
                  text: TextSpan(
                    text: label,
                    style: const TextStyle(
                      color: HtmlColors.mut,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      if (!isOpt)
                        const TextSpan(
                          text: ' *',
                          style: TextStyle(color: HtmlColors.bad),
                        ),
                    ],
                  ),
                ),
              ),
            child,
            if (hasErr)
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  error,
                  style: const TextStyle(color: HtmlColors.bad, fontSize: 11),
                ),
              ),
          ],
        ),
      );
    });
  }

  // Input Field (Height 44px, Border Radius 10px, Strict 10-Digit Mobile Formatter)
  Widget _textInput({
    required AddOutletViewModel viewModel,
    required String key,
    required TextEditingController controller,
    String? hint,
    TextInputType? type,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
    List<TextInputFormatter>? inputFormatters,
    ValueChanged<String>? onChangedExtra,
  }) {
    final isPhone = type == TextInputType.phone || key == 'mobile' || key == 'wa';
    final formatters = inputFormatters ??
        (isPhone
            ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ]
            : null);

    return Obx(() {
      final hasErr = viewModel.hasError(key);
      final isVerifiedMobile = key == 'mobile' && viewModel.isMobileVerified.value;
      final borderColor = hasErr
          ? HtmlColors.bad
          : (isVerifiedMobile ? HtmlColors.ok : HtmlColors.line);
      final focusedBorderColor = hasErr
          ? HtmlColors.bad
          : (isVerifiedMobile ? HtmlColors.ok : HtmlColors.pri);

      return SizedBox(
        height: 44,
        child: TextField(
          controller: controller,
          keyboardType: type,
          readOnly: readOnly,
          onTap: onTap,
          inputFormatters: formatters,
          style: const TextStyle(fontSize: 14.5, color: HtmlColors.ink),
          onChanged: (val) {
            if (onChangedExtra != null) {
              onChangedExtra(val);
            }
            if (isPhone) {
              final clean = val.replaceAll(RegExp(r'\D'), '');
              if (clean.length == 10 && RegExp(r'^[6-9]\d{9}$').hasMatch(clean)) {
                viewModel.setError(key, '');
              }
            } else if (key == 'email') {
              final trimmed = val.trim();
              if (RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
              ).hasMatch(trimmed)) {
                viewModel.setError('email', '');
              }
            } else if (viewModel.hasError(key)) {
              if (val.trim().isNotEmpty) viewModel.setError(key, '');
            }
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: HtmlColors.mut.withValues(alpha: 0.6),
              fontSize: 14,
            ),
            filled: true,
            fillColor: HtmlColors.bg,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            suffixIcon: suffixIcon,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: borderColor,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: focusedBorderColor,
                width: 1.5,
              ),
            ),
          ),
        ),
      );
    });
  }

  // Dropdown Select Ref (Height 44px)
  Widget _dropdownRef({
    required AddOutletViewModel viewModel,
    required String key,
    required RxnString rxValue,
    required List<MapEntry<String, String>> options,
    Function(String?)? onChanged,
  }) {
    return Obx(() {
      final hasErr = viewModel.hasError(key);
      return Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: HtmlColors.bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasErr ? HtmlColors.bad : HtmlColors.line,
            width: 1.5,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: rxValue.value,
            hint: const Text('Select', style: TextStyle(fontSize: 14, color: HtmlColors.mut)),
            isExpanded: true,
            items: options
                .map(
                  (e) => DropdownMenuItem(
                    value: e.key,
                    child: Text(
                      e.value,
                      style: const TextStyle(fontSize: 14.5, color: HtmlColors.ink),
                    ),
                  ),
                )
                .toList(),
            onChanged: (val) {
              if (onChanged != null) {
                onChanged(val);
              } else {
                rxValue.value = val;
              }
            },
          ),
        ),
      );
    });
  }

  // Simple Dropdown (Height 44px)
  Widget _dropdown({
    required AddOutletViewModel viewModel,
    required String key,
    required RxnString rxValue,
    required List<String> options,
  }) {
    return Obx(() {
      final hasErr = viewModel.hasError(key);
      return Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: HtmlColors.bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasErr ? HtmlColors.bad : HtmlColors.line,
            width: 1.5,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: rxValue.value,
            hint: const Text('Select', style: TextStyle(fontSize: 14, color: HtmlColors.mut)),
            isExpanded: true,
            items: options
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: const TextStyle(fontSize: 14.5, color: HtmlColors.ink),
                      ),
                    ))
                .toList(),
            onChanged: (val) => rxValue.value = val,
          ),
        ),
      );
    });
  }

  // Single-select Checkbox Row (.cbs) for Retailer Type
  Widget _checkboxRadioRef({
    required RxnString rxValue,
    required List<MapEntry<String, String>> options,
    Function(String, String)? onChanged,
  }) {
    return Obx(() {
      return Wrap(
        spacing: 20,
        runSpacing: 8,
        children: options.map((opt) {
          final isSelected = rxValue.value == opt.key;
          return GestureDetector(
            onTap: () {
              if (onChanged != null) {
                onChanged(opt.key, opt.value);
              } else {
                rxValue.value = opt.key;
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isSelected ? HtmlColors.pri : HtmlColors.bg,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected ? HtmlColors.pri : HtmlColors.dotBorder,
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 8),
                Text(
                  opt.value,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: HtmlColors.ink,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }

  // Rounded Pills (.pills)
  Widget _pillsRef({
    required RxnString rxValue,
    required List<MapEntry<String, String>> options,
    Function(String, String)? onChanged,
  }) {
    return Obx(() {
      return Wrap(
        spacing: 6,
        runSpacing: 6,
        children: options.map((opt) {
          final isSelected = rxValue.value == opt.key;
          return GestureDetector(
            onTap: () {
              if (onChanged != null) {
                onChanged(opt.key, opt.value);
              } else {
                rxValue.value = opt.key;
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? HtmlColors.pri : HtmlColors.bg,
                border: Border.all(
                  color: isSelected ? HtmlColors.pri : HtmlColors.line,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                opt.value,
                style: TextStyle(
                  color: isSelected ? Colors.white : HtmlColors.ink,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  // Standard Pills (.pills)
  Widget _pills({required RxString rxValue, required List<String> options}) {
    return Obx(() {
      return Wrap(
        spacing: 6,
        runSpacing: 6,
        children: options.map((opt) {
          final isSelected = rxValue.value == opt;
          return GestureDetector(
            onTap: () => rxValue.value = opt,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? HtmlColors.pri : HtmlColors.bg,
                border: Border.all(
                  color: isSelected ? HtmlColors.pri : HtmlColors.line,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                opt,
                style: TextStyle(
                  color: isSelected ? Colors.white : HtmlColors.ink,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  // Multi-select Chips
  Widget _chips({
    required RxList<String> rxValues,
    required List<String> options,
    required AddOutletViewModel viewModel,
    required String key,
  }) {
    return Obx(() {
      final hasErr = viewModel.hasError(key);
      return Container(
        decoration: hasErr
            ? BoxDecoration(
                border: Border.all(color: HtmlColors.bad, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              )
            : null,
        child: Wrap(
          spacing: 6,
          runSpacing: 6,
          children: options.map((opt) {
            final isSelected = rxValues.contains(opt);
            return GestureDetector(
              onTap: () {
                if (isSelected) {
                  rxValues.remove(opt);
                } else {
                  rxValues.add(opt);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? HtmlColors.pri : HtmlColors.bg,
                  border: Border.all(
                    color: isSelected ? HtmlColors.pri : HtmlColors.line,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  opt,
                  style: TextStyle(
                    color: isSelected ? Colors.white : HtmlColors.ink,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  // File Attachment Picker (.fl)
  Widget _filePicker({
    required AddOutletViewModel viewModel,
    required String key,
    required RxnString rxPath,
    bool isImage = false,
    String? kind,
    RxBool? isUploading,
  }) {
    return Obx(() {
      final hasErr = viewModel.hasError(key);
      final hasFile = rxPath.value != null;
      final uploading = (isUploading?.value ?? false) || (isImage && viewModel.isUploadingImage.value);
      return GestureDetector(
        onTap: uploading
            ? null
            : () {
                if (isImage) {
                  viewModel.showImageSourceSheet(rxPath, kind: kind);
                } else {
                  viewModel.pickFile(rxPath, isImage: isImage, kind: kind);
                }
              },
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: HtmlColors.bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: hasErr
                  ? HtmlColors.bad
                  : (hasFile ? HtmlColors.ok : HtmlColors.line),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              if (uploading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: HtmlColors.pri,
                  ),
                )
              else
                Icon(
                  Icons.upload_file_outlined,
                  color: hasFile ? HtmlColors.ok : HtmlColors.mut,
                  size: 18,
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  uploading
                      ? 'Processing & uploading...'
                      : (hasFile
                            ? rxPath.value!.split('/').last
                            : 'Choose file or take photo'),
                  style: TextStyle(
                    color: (hasFile || uploading)
                        ? HtmlColors.ok
                        : HtmlColors.mut,
                    fontSize: 13.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Mobile Number Field with Integrated Verify Button & Success State
  Widget _buildMobileField(AddOutletViewModel vm, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final isVerified = vm.isMobileVerified.value;
          final isSending = vm.isSendingOtp.value;

          return _textInput(
            viewModel: vm,
            key: 'mobile',
            controller: vm.mobileController,
            type: TextInputType.phone,
            hint: '10-digit mobile number',
            onChangedExtra: (val) {
              vm.onMobileNumberChanged(val);
            },
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 6, top: 4, bottom: 4),
              child: isVerified
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFA5D6A7)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF2E7D32),
                            size: 15,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Verified',
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ValueListenableBuilder<TextEditingValue>(
                      valueListenable: vm.mobileController,
                      builder: (context, value, child) {
                        final phone = value.text.replaceAll(RegExp(r'\D'), '');
                        final isValid = phone.length == 10 && RegExp(r'^[6-9]\d{9}$').hasMatch(phone);

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          child: ElevatedButton(
                            onPressed: (isValid && !isSending)
                                ? () => OtpVerificationBottomSheet.show(context, vm)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isValid ? HtmlColors.pri : HtmlColors.lineConnector,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: HtmlColors.bg,
                              disabledForegroundColor: HtmlColors.mut.withValues(alpha: 0.5),
                              elevation: isValid ? 1 : 0,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              minimumSize: const Size(64, 32),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: isSending
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Verify',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
            ),
          );
        }),
        Obx(() {
          if (vm.isMobileVerified.value) {
            return const Padding(
              padding: EdgeInsets.only(top: 4, left: 2),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: HtmlColors.ok,
                    size: 13,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Mobile Number Verified',
                    style: TextStyle(
                      color: HtmlColors.ok,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  // Step 1: Shop & Address
  Widget _buildStep1Fields(AddOutletViewModel vm, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _fld(
          viewModel: vm,
          key: 'rtype',
          label: 'Retailer type',
          child: _checkboxRadioRef(
            rxValue: vm.rtypeUuid,
            options: vm.customerTypes
                .map((e) => MapEntry(e.uuid, e.name))
                .toList(),
            onChanged: vm.onCustomerTypeChanged,
          ),
        ),
        _fld(
          viewModel: vm,
          key: 'shop',
          label: 'Shop name',
          child: _textInput(
            viewModel: vm,
            key: 'shop',
            controller: vm.shopController,
          ),
        ),
        _fld(
          viewModel: vm,
          key: 'person',
          label: 'Contact person name',
          child: _textInput(
            viewModel: vm,
            key: 'person',
            controller: vm.personController,
          ),
        ),

        _fld(
          viewModel: vm,
          key: 'mobile',
          label: 'Mobile number',
          child: _buildMobileField(vm, context),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Obx(
                () => Checkbox(
                  value: vm.wacb.value,
                  onChanged: vm.toggleWacb,
                  activeColor: HtmlColors.pri,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const Expanded(
                child: Text(
                  'Mobile number is also my WhatsApp number',
                  style: TextStyle(fontSize: 13, color: HtmlColors.ink),
                ),
              ),
            ],
          ),
        ),

        _fld(
          viewModel: vm,
          key: 'wa',
          label: 'WhatsApp number',
          child: _textInput(
            viewModel: vm,
            key: 'wa',
            controller: vm.waController,
            type: TextInputType.phone,
          ),
        ),
        _fld(
          viewModel: vm,
          key: 'email',
          label: 'Email ID',
          child: _textInput(
            viewModel: vm,
            key: 'email',
            controller: vm.emailController,
            type: TextInputType.emailAddress,
          ),
        ),

        _fld(
          viewModel: vm,
          key: 'a1',
          label: 'Address line 1',
          child: _textInput(
            viewModel: vm,
            key: 'a1',
            controller: vm.a1Controller,
            suffixIcon: AnimatedLocationIconButton(
              isLocating: vm.isLocating,
              onPressed: vm.captureLocation,
            ),
          ),
        ),
        Obx(
          () => vm.capturedGeo.value != null
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Captured ${vm.capturedGeo.value}',
                    style: const TextStyle(color: HtmlColors.mut, fontSize: 12),
                  ),
                )
              : const SizedBox.shrink(),
        ),

        _fld(
          viewModel: vm,
          key: 'a2',
          label: 'Address line 2',
          child: _textInput(
            viewModel: vm,
            key: 'a2',
            controller: vm.a2Controller,
          ),
        ),
        _fld(
          viewModel: vm,
          key: 'a3',
          label: 'Address line 3',
          child: _textInput(
            viewModel: vm,
            key: 'a3',
            controller: vm.a3Controller,
          ),
        ),

        // 2-Column Row for State & City
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'state',
                label: 'State',
                child: _dropdown(
                  viewModel: vm,
                  key: 'state',
                  rxValue: vm.selectedState,
                  options: vm.statesList,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'city',
                label: 'City',
                child: _textInput(
                  viewModel: vm,
                  key: 'city',
                  controller: vm.cityController,
                ),
              ),
            ),
          ],
        ),

        _fld(
          viewModel: vm,
          key: 'pin',
          label: 'Pin code',
          child: _textInput(
            viewModel: vm,
            key: 'pin',
            controller: vm.pinController,
            type: TextInputType.number,
          ),
        ),
      ],
    );
  }

  // Step 2: Classification
  Widget _buildStep2Fields(AddOutletViewModel vm, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'sub',
                label: 'Sub type',
                child: _dropdownRef(
                  viewModel: vm,
                  key: 'sub',
                  rxValue: vm.subTypeUuid,
                  options: vm.subTypeList
                      .map((e) => MapEntry(e.uuid, e.name))
                      .toList(),
                  onChanged: vm.onSubTypeChanged,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'chan',
                label: 'Channel',
                child: _dropdownRef(
                  viewModel: vm,
                  key: 'chan',
                  rxValue: vm.channelUuid,
                  options: vm.channelList
                      .map((e) => MapEntry(e.uuid, e.name))
                      .toList(),
                  onChanged: vm.onChannelChanged,
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'seg',
                label: 'Segment',
                child: _dropdownRef(
                  viewModel: vm,
                  key: 'seg',
                  rxValue: vm.segmentUuid,
                  options: vm.segmentList
                      .map((e) => MapEntry(e.uuid, e.name))
                      .toList(),
                  onChanged: vm.onSegmentChanged,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'cat',
                label: 'Category',
                child: _dropdownRef(
                  viewModel: vm,
                  key: 'cat',
                  rxValue: vm.categoryUuid,
                  options: vm.categoryList
                      .map((e) => MapEntry(e.uuid, e.name))
                      .toList(),
                  onChanged: vm.onCategoryChanged,
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'cls',
                label: 'Class',
                child: _dropdownRef(
                  viewModel: vm,
                  key: 'cls',
                  rxValue: vm.clsUuid,
                  options: vm.classList.map((e) => MapEntry(e.uuid, e.name)).toList(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'beat',
                label: 'Beat',
                child: _dropdownRef(
                  viewModel: vm,
                  key: 'beat',
                  rxValue: vm.beatUuid,
                  options: vm.activeBeats
                      .map((e) => MapEntry(e.uuid, e.name))
                      .toList(),
                ),
              ),
            ),
          ],
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'estYear',
                label: 'Established Year',
                child: _textInput(
                  viewModel: vm,
                  key: 'estYear',
                  controller: vm.establishedYearController,
                  type: TextInputType.number,
                  hint: 'e.g. 2015',
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'size',
                label: 'Shop size (sq ft)',
                child: _textInput(
                  viewModel: vm,
                  key: 'size',
                  controller: vm.shopSizeController,
                  type: TextInputType.number,
                  hint: 'e.g. 850',
                ),
              ),
            ),
          ],
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'dob',
                label: 'Date of Birth',
                child: _textInput(
                  viewModel: vm,
                  key: 'dob',
                  controller: vm.dobController,
                  readOnly: true,
                  hint: 'Select Date',
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: vm.dob.value ?? DateTime(1990),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      vm.dob.value = date;
                      vm.dobController.text = "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
                      vm.setError('dob', '');
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'anniversary',
                label: 'Anniversary Date',
                child: _textInput(
                  viewModel: vm,
                  key: 'anniversary',
                  controller: vm.anniversaryController,
                  readOnly: true,
                  hint: 'Select Date',
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: vm.anniversary.value ?? DateTime(2010),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      vm.anniversary.value = date;
                      vm.anniversaryController.text = "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
                      vm.setError('anniversary', '');
                    }
                  },
                ),
              ),
            ),
          ],
        ),

        _fld(
          viewModel: vm,
          key: 'pot',
          label: 'Monthly potential (₹)',
          child: _textInput(
            viewModel: vm,
            key: 'pot',
            controller: vm.monthlyPotentialController,
            type: TextInputType.number,
            hint: 'e.g. 150000',
          ),
        ),

        _fld(
          viewModel: vm,
          key: 'brands',
          label: 'Brands stocked',
          child: _chips(
            viewModel: vm,
            key: 'brands',
            rxValues: vm.selectedBrands,
            options: vm.brands,
          ),
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'open',
                label: 'Shop opens',
                child: _textInput(
                  viewModel: vm,
                  key: 'open',
                  controller: TextEditingController(
                    text: vm.openTime.value?.format(context) ?? '',
                  ),
                  readOnly: true,
                  hint: 'Select Time',
                  onTap: () async {
                    final t = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 9, minute: 0),
                    );
                    if (t != null) vm.openTime.value = t;
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'close',
                label: 'Shop closes',
                child: _textInput(
                  viewModel: vm,
                  key: 'close',
                  controller: TextEditingController(
                    text: vm.closeTime.value?.format(context) ?? '',
                  ),
                  readOnly: true,
                  hint: 'Select Time',
                  onTap: () async {
                    final t = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 20, minute: 0),
                    );
                    if (t != null) vm.closeTime.value = t;
                  },
                ),
              ),
            ),
          ],
        ),

        Obx(() {
          if (vm.rtypeName.value.toLowerCase() == 'mechanic') {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _fld(
                        viewModel: vm,
                        key: 'wtype',
                        label: 'Workshop type',
                        child: _dropdownRef(
                          viewModel: vm,
                          key: 'wtype',
                          rxValue: vm.wtypeUuid,
                          options: vm.workshopTypeList
                              .map((e) => MapEntry(e.uuid, e.name))
                              .toList(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _fld(
                        viewModel: vm,
                        key: 'exp',
                        label: 'Experience (years)',
                        child: _textInput(
                          viewModel: vm,
                          key: 'exp',
                          controller: vm.expController,
                          type: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _fld(
                        viewModel: vm,
                        key: 'eng',
                        label: 'Engine specialty',
                        child: _dropdown(
                          viewModel: vm,
                          key: 'eng',
                          rxValue: vm.eng,
                          options: vm.engs,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _fld(
                        viewModel: vm,
                        key: 'mechs',
                        label: 'Mechanics in workshop',
                        child: _textInput(
                          viewModel: vm,
                          key: 'mechs',
                          controller: vm.mechsController,
                          type: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  // Step 3: KYC | Bank | License
  Widget _buildStep3Fields(AddOutletViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _fld(
          viewModel: vm,
          key: 'doctype',
          label: 'Document type',
          child: _pillsRef(
            rxValue: vm.kycDocTypeUuid,
            options: vm.kycDocTypeList
                .map((e) => MapEntry(e.uuid, e.name))
                .toList(),
            onChanged: vm.onKycDocTypeChanged,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'fn',
                label: 'First name',
                child: _textInput(
                  viewModel: vm,
                  key: 'fn',
                  controller: vm.fnController,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'ln',
                label: 'Last name',
                child: _textInput(
                  viewModel: vm,
                  key: 'ln',
                  controller: vm.lnController,
                ),
              ),
            ),
          ],
        ),

        _fld(
          viewModel: vm,
          key: 'docno',
          label: 'Document number',
          child: _textInput(
            viewModel: vm,
            key: 'docno',
            controller: vm.docnoController,
          ),
        ),

        _fld(
          viewModel: vm,
          key: 'docf',
          label: 'Document attachment',
          child: _filePicker(
            viewModel: vm,
            key: 'docf',
            rxPath: vm.docfPath,
            kind: 'DOCUMENT',
            isUploading: vm.isUploadingDoc,
          ),
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'bank',
                label: 'Bank name',
                child: _textInput(
                  viewModel: vm,
                  key: 'bank',
                  controller: vm.bankController,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'holder',
                label: 'Account holder name',
                child: _textInput(
                  viewModel: vm,
                  key: 'holder',
                  controller: vm.holderController,
                ),
              ),
            ),
          ],
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'acc',
                label: 'Account number',
                child: _textInput(
                  viewModel: vm,
                  key: 'acc',
                  controller: vm.accController,
                  type: TextInputType.number,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'ifsc',
                label: 'IFSC code',
                child: _textInput(
                  viewModel: vm,
                  key: 'ifsc',
                  controller: vm.ifscController,
                ),
              ),
            ),
          ],
        ),

        _fld(
          viewModel: vm,
          key: 'bankf',
          label: 'Bank document (cheque / passbook)',
          child: _filePicker(viewModel: vm, key: 'bankf', rxPath: vm.bankfPath),
        ),

        _sub('GST & licences (GST required, others optional)'),
        _fld(
          viewModel: vm,
          key: 'gst',
          label: 'GST type',
          child: _pills(
            rxValue: vm.gst,
            options: ['Registered', 'Unregistered'],
          ),
        ),

        Obx(() {
          if (vm.gst.value == 'Registered') {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _fld(
                  viewModel: vm,
                  key: 'gstcat',
                  label: 'GST category',
                  child: _pills(
                    rxValue: vm.gstcat,
                    options: ['Regular', 'Composition', 'Both'],
                  ),
                ),
                _fld(
                  viewModel: vm,
                  key: 'gstno',
                  label: 'GST number',
                  child: _textInput(
                    viewModel: vm,
                    key: 'gstno',
                    controller: vm.gstnoController,
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),

        _sub('Optional licences'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'fssai',
                label: 'FSSAI number',
                isOpt: true,
                child: _textInput(
                  viewModel: vm,
                  key: 'fssai',
                  controller: vm.fssaiController,
                  type: TextInputType.number,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'ff',
                label: 'FSSAI attachment',
                isOpt: true,
                child: _filePicker(viewModel: vm, key: 'ff', rxPath: vm.ffPath),
              ),
            ),
          ],
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'drug',
                label: 'Drug licence number',
                isOpt: true,
                child: _textInput(
                  viewModel: vm,
                  key: 'drug',
                  controller: vm.drugController,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'df',
                label: 'Drug licence attachment',
                isOpt: true,
                child: _filePicker(viewModel: vm, key: 'df', rxPath: vm.dfPath),
              ),
            ),
          ],
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'shopl',
                label: 'Shop licence number',
                isOpt: true,
                child: _textInput(
                  viewModel: vm,
                  key: 'shopl',
                  controller: vm.shoplController,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _fld(
                viewModel: vm,
                key: 'sf',
                label: 'Shop licence attachment',
                isOpt: true,
                child: _filePicker(viewModel: vm, key: 'sf', rxPath: vm.sfPath),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Fixed Compact Bottom Navigation Bar (nav)
  Widget _buildBottomNav(AddOutletViewModel viewModel, BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: const BoxDecoration(
          color: HtmlColors.card,
          border: Border(top: BorderSide(color: HtmlColors.line)),
        ),
        child: Obx(() {
        final step = viewModel.currentStep.value;
        return Row(
          children: [
            if (step > 0)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: viewModel.previousStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HtmlColors.bg,
                        foregroundColor: HtmlColors.ink,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        side: const BorderSide(color: HtmlColors.line),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: SizedBox(
                height: 40,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: viewModel.isLoading.value
                        ? null
                        : () {
                            if (step == 2) {
                              OutletPreviewBottomSheet.show(context, viewModel);
                            } else {
                              viewModel.nextStep();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: step == 2 ? HtmlColors.pri : HtmlColors.pri,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: viewModel.isLoading.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : (step == 2
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.remove_red_eye_outlined, size: 16, color: Colors.white),
                                  SizedBox(width: 6),
                                  Text(
                                    'Preview Details',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                'Next',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    ),
    );
  }
}

// Custom StatefulWidget for Animated Location Icon inside Address Line 1
class AnimatedLocationIconButton extends StatefulWidget {
  final RxBool isLocating;
  final VoidCallback onPressed;

  const AnimatedLocationIconButton({
    super.key,
    required this.isLocating,
    required this.onPressed,
  });

  @override
  State<AnimatedLocationIconButton> createState() =>
      _AnimatedLocationIconButtonState();
}

class _AnimatedLocationIconButtonState
    extends State<AnimatedLocationIconButton> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final locating = widget.isLocating.value;

      return GestureDetector(
        onTap: locating ? null : widget.onPressed,
        child: Container(
          margin: const EdgeInsets.all(5),
          width: 34,
          height: 34,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (!locating)
                AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    final val = _animController.value;
                    return Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: HtmlColors.pri.withValues(
                              alpha: (1 - val) * 0.4,
                            ),
                            spreadRadius: val * 8,
                            blurRadius: 0,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x146A3FD6),
                ),
                child: locating
                    ? const Padding(
                        padding: EdgeInsets.all(7.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: HtmlColors.pri,
                        ),
                      )
                    : const Icon(
                        Icons.my_location_rounded,
                        color: HtmlColors.pri,
                        size: 18,
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
