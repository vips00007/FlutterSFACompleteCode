import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_outlet_viewmodel.dart';
import '../dashboard/dashboard_viewmodel.dart';

class HtmlColors {
  static const Color bg = Color(0xFFF9FAFB);
  static const Color card = Colors.white;
  static const Color ink = Color(0xFF1B2733);
  static const Color mut = Color(0xFF64748B);
  static const Color line = Color(0xFFE2E8F0);
  static const Color pri = Color(0xFF8A2BE2);
  static const Color acc = Color(0xFF6D28D9);
  static const Color sec = Color(0xFFB197FC);
  static const Color bad = Color(0xFFD32F2F);
  static const Color ok = Color(0xFF1B873F);
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
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 18,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTabs(viewModel),
                        const SizedBox(height: 12),
                        _buildStepCard(viewModel, context),
                        const SizedBox(height: 100),
                      ],
                    ),
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
      bottomSheet: _buildBottomNav(viewModel),
    );
  }

  Widget _buildHeader(AddOutletViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: HtmlColors.pri,
        gradient: const LinearGradient(
          colors: [HtmlColors.acc, HtmlColors.pri, HtmlColors.sec],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
        boxShadow: [
          BoxShadow(
            color: HtmlColors.pri.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 16, 18, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              icon: Image.asset(
                'assets/images/queue.png',
                width: 64,
                height: 64,
              ),
              onPressed: () {
                final dashboardViewModel = Get.find<DashboardViewModel>();
                dashboardViewModel.changeTabIndex(0);
              },
            ),
            const SizedBox(width: 12),
            _buildAvatar(viewModel),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'New customer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Obx(
                    () => Text(
                      'Step ${viewModel.currentStep.value + 1} of 3',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Obx(() {
                      return FractionallySizedBox(
                        widthFactor: (viewModel.maxStepReached.value + 1) / 3,
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: HtmlColors.acc,
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                      );
                    }),
                  ),
                  Obx(() {
                    if (viewModel.avatarError.value.isNotEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text(
                          'Shop photo required. Tap the camera circle.',
                          style: TextStyle(
                            color: Color(0xFFFFD166),
                            fontSize: 12,
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
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(AddOutletViewModel viewModel) {
    return Obx(() {
      final hasAvatar = viewModel.avatarPath.value != null;
      final isError = viewModel.avatarError.isNotEmpty;
      final isUploading = viewModel.isUploadingImage.value;

      return GestureDetector(
        onTap: isUploading
            ? null
            : () => viewModel.pickFile(
                viewModel.avatarPath,
                isImage: true,
                kind: 'SHOP_IMAGE',
              ),
        child: SizedBox(
          width: 56,
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (!hasAvatar)
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: CustomPaint(painter: _DottedCirclePainter()),
                ),
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hasAvatar
                      ? Colors.transparent
                      : Colors.white.withValues(alpha: 0.15),
                  border: Border.all(
                    color: isError
                        ? HtmlColors.bad
                        : (hasAvatar ? HtmlColors.acc : Colors.transparent),
                    width: 2,
                  ),
                  image: hasAvatar
                      ? DecorationImage(
                          image: FileImage(File(viewModel.avatarPath.value!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: isUploading
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : (hasAvatar
                          ? null
                          : const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 22,
                            )),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTabs(AddOutletViewModel viewModel) {
    final tabs = ['Shop & address', 'Classification', 'KYC, bank & licences'];
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isCur = viewModel.currentStep.value == index;
            final isDone = viewModel.maxStepReached.value >= index && !isCur;

            Color bgColor = HtmlColors.card;
            Color borderColor = HtmlColors.line;
            Color textColor = HtmlColors.mut;

            if (isCur) {
              bgColor = HtmlColors.pri;
              borderColor = HtmlColors.pri;
              textColor = Colors.white;
            } else if (isDone) {
              borderColor = HtmlColors.ok;
              textColor = HtmlColors.ok;
            }

            return Padding(
              padding: const EdgeInsets.only(right: 6, bottom: 12),
              child: GestureDetector(
                onTap: () => viewModel.goStep(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    (isDone ? '✓ ' : '') + tabs[index],
                    style: TextStyle(
                      color: textColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  Widget _buildStepCard(AddOutletViewModel viewModel, BuildContext context) {
    return Obx(() {
      final step = viewModel.currentStep.value;
      String title = '';
      String desc = '';
      Widget content = const SizedBox.shrink();

      if (step == 0) {
        title = 'Shop & address';
        desc = 'Photo, owner contact and location of the shop.';
        content = _buildStep1Fields(viewModel);
      } else if (step == 1) {
        title = 'Classification';
        desc = 'Classification, beat mapping and shop profile.';
        content = _buildStep2Fields(viewModel, context);
      } else if (step == 2) {
        title = 'KYC, bank & licences';
        desc = 'Identity, bank account and licences, then submit.';
        content = _buildStep3Fields(viewModel);
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        decoration: BoxDecoration(
          color: HtmlColors.card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: HtmlColors.ink.withValues(alpha: 0.08),
              blurRadius: 28,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              desc,
              style: const TextStyle(color: HtmlColors.mut, fontSize: 14),
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      );
    });
  }

  Widget _sub(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 4),
      child: Container(
        padding: const EdgeInsets.only(left: 12, top: 4),
        decoration: const BoxDecoration(
          border: Border(left: BorderSide(color: Color(0xFFFF9F1C), width: 4)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

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
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (label.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: RichText(
                  text: TextSpan(
                    text: label,
                    style: const TextStyle(
                      color: HtmlColors.mut,
                      fontSize: 13,
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
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  error,
                  style: const TextStyle(color: HtmlColors.bad, fontSize: 12),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _textInput({
    required AddOutletViewModel viewModel,
    required String key,
    required TextEditingController controller,
    String? hint,
    TextInputType? type,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Obx(() {
      final hasErr = viewModel.hasError(key);
      return TextField(
        controller: controller,
        keyboardType: type,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(fontSize: 15, color: HtmlColors.ink),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: HtmlColors.ink.withValues(alpha: 0.5)),
          filled: true,
          fillColor: HtmlColors.bg,
          contentPadding: const EdgeInsets.all(12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: hasErr ? HtmlColors.bad : HtmlColors.line,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: hasErr ? HtmlColors.bad : HtmlColors.pri,
              width: 2,
            ),
          ),
        ),
      );
    });
  }

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
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: HtmlColors.bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasErr ? HtmlColors.bad : HtmlColors.line,
            width: 1.5,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: rxValue.value,
            hint: const Text('Select', style: TextStyle(fontSize: 15)),
            isExpanded: true,
            items: options
                .map(
                  (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
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

  Widget _dropdown({
    required AddOutletViewModel viewModel,
    required String key,
    required RxnString rxValue,
    required List<String> options,
  }) {
    return Obx(() {
      final hasErr = viewModel.hasError(key);
      return Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: HtmlColors.bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasErr ? HtmlColors.bad : HtmlColors.line,
            width: 1.5,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: rxValue.value,
            hint: const Text('Select', style: TextStyle(fontSize: 15)),
            isExpanded: true,
            items: options
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) => rxValue.value = val,
          ),
        ),
      );
    });
  }

  Widget _pillsRef({
    required RxnString rxValue,
    required List<MapEntry<String, String>> options,
    Function(String, String)? onChanged,
  }) {
    return Obx(() {
      return Wrap(
        spacing: 8,
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
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
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _pills({required RxString rxValue, required List<String> options}) {
    return Obx(() {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options.map((opt) {
          final isSelected = rxValue.value == opt;
          return GestureDetector(
            onTap: () => rxValue.value = opt,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
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
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

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
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 9,
                ),
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
                    fontSize: 14,
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
      final uploading = isUploading?.value ?? false;
      return GestureDetector(
        onTap: uploading
            ? null
            : () => viewModel.pickFile(rxPath, isImage: isImage, kind: kind),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: HtmlColors.bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasErr
                  ? HtmlColors.bad
                  : (hasFile ? HtmlColors.ok : HtmlColors.line),
              width: 1.5,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            children: [
              if (uploading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: HtmlColors.pri,
                  ),
                )
              else
                Icon(
                  Icons.upload_file,
                  color: hasFile ? HtmlColors.ok : HtmlColors.mut,
                  size: 20,
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  uploading
                      ? 'Uploading...'
                      : (hasFile
                            ? rxPath.value!.split('/').last
                            : 'Choose file or take photo'),
                  style: TextStyle(
                    color: (hasFile || uploading)
                        ? HtmlColors.ok
                        : HtmlColors.mut,
                    fontSize: 14,
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

  Widget _buildStep1Fields(AddOutletViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sub('Shop details'),
        _fld(
          viewModel: vm,
          key: 'rtype',
          label: 'Customer type',
          child: _pillsRef(
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

        _sub('Contact details'),
        _fld(
          viewModel: vm,
          key: 'mobile',
          label: 'Mobile number',
          child: _textInput(
            viewModel: vm,
            key: 'mobile',
            controller: vm.mobileController,
            type: TextInputType.phone,
            hint: '98XXXXXXXX',
          ),
        ),

        Row(
          children: [
            Obx(
              () => Checkbox(
                value: vm.wacb.value,
                onChanged: vm.toggleWacb,
                activeColor: HtmlColors.pri,
              ),
            ),
            const Expanded(
              child: Text(
                'Mobile number is also my WhatsApp number',
                style: TextStyle(fontSize: 14, color: HtmlColors.ink),
              ),
            ),
          ],
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

        _sub('Address'),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: HtmlColors.acc,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            elevation: 0,
          ),
          onPressed: vm.captureLocation,
          icon: Obx(
            () => vm.isLocating.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.my_location),
          ),
          label: const Text(
            'Use my current location',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Obx(
          () => Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 12),
            child: Text(
              vm.capturedGeo.value != null
                  ? 'Captured ${vm.capturedGeo.value}'
                  : 'Fills address lines, state, city and pin code.',
              style: const TextStyle(color: HtmlColors.mut, fontSize: 13),
            ),
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
          ),
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
        _fld(
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
        _fld(
          viewModel: vm,
          key: 'city',
          label: 'City',
          child: _textInput(
            viewModel: vm,
            key: 'city',
            controller: vm.cityController,
          ),
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

  Widget _buildStep2Fields(AddOutletViewModel vm, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _fld(
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
        _fld(
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
        _fld(
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
        _fld(
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
        _fld(
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
        _fld(
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

        _sub('Shop profile'),
        _fld(
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
        _fld(
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
        _fld(
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
        _fld(
          viewModel: vm,
          key: 'size',
          label: 'Shop size (Sq Ft)',
          child: _textInput(
            viewModel: vm,
            key: 'size',
            controller: vm.shopSizeController,
            type: TextInputType.number,
            hint: 'e.g. 850',
          ),
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
            const SizedBox(width: 12),
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
                _sub('Workshop details'),
                _fld(
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
                _fld(
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
                _fld(
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
                _fld(
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
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildStep3Fields(AddOutletViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sub('KYC'),
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
        _fld(
          viewModel: vm,
          key: 'fn',
          label: 'First name',
          child: _textInput(
            viewModel: vm,
            key: 'fn',
            controller: vm.fnController,
          ),
        ),
        _fld(
          viewModel: vm,
          key: 'ln',
          label: 'Last name',
          child: _textInput(
            viewModel: vm,
            key: 'ln',
            controller: vm.lnController,
          ),
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

        _sub('Bank details'),
        _fld(
          viewModel: vm,
          key: 'bank',
          label: 'Bank name',
          child: _textInput(
            viewModel: vm,
            key: 'bank',
            controller: vm.bankController,
          ),
        ),
        _fld(
          viewModel: vm,
          key: 'holder',
          label: 'Account holder name',
          child: _textInput(
            viewModel: vm,
            key: 'holder',
            controller: vm.holderController,
          ),
        ),
        _fld(
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
        _fld(
          viewModel: vm,
          key: 'ifsc',
          label: 'IFSC code',
          child: _textInput(
            viewModel: vm,
            key: 'ifsc',
            controller: vm.ifscController,
          ),
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
        _fld(
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
        _fld(
          viewModel: vm,
          key: 'ff',
          label: 'FSSAI attachment',
          isOpt: true,
          child: _filePicker(viewModel: vm, key: 'ff', rxPath: vm.ffPath),
        ),

        _fld(
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
        _fld(
          viewModel: vm,
          key: 'df',
          label: 'Drug licence attachment',
          isOpt: true,
          child: _filePicker(viewModel: vm, key: 'df', rxPath: vm.dfPath),
        ),

        _fld(
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
        _fld(
          viewModel: vm,
          key: 'sf',
          label: 'Shop licence attachment',
          isOpt: true,
          child: _filePicker(viewModel: vm, key: 'sf', rxPath: vm.sfPath),
        ),
      ],
    );
  }

  Widget _buildBottomNav(AddOutletViewModel viewModel) {
    return Container(
      decoration: const BoxDecoration(
        color: HtmlColors.card,
        border: Border(top: BorderSide(color: HtmlColors.line)),
      ),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 30),
      child: Obx(() {
        final step = viewModel.currentStep.value;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (step > 0)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    onPressed: viewModel.previousStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HtmlColors.bg,
                      foregroundColor: HtmlColors.pri,
                      elevation: 0,
                      side: const BorderSide(color: HtmlColors.line),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: Obx(
                () => ElevatedButton(
                  onPressed: viewModel.isLoading.value
                      ? null
                      : viewModel.nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: step == 2 ? HtmlColors.ok : HtmlColors.pri,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: viewModel.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          step == 2 ? 'Submit for approval' : 'Next',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _DottedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const dashWidth = 4.0;
    const dashSpace = 4.0;

    double circumference = 2 * math.pi * radius;
    int dashCount = (circumference / (dashWidth + dashSpace)).floor();

    double sweepAngle = (2 * math.pi) / dashCount;
    double dashAngle = (dashWidth / circumference) * 2 * math.pi;

    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * sweepAngle,
        dashAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
