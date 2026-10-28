import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_outlet_viewmodel.dart';
import '../dashboard/dashboard_viewmodel.dart';

// HTML Colors mapped to the existing purple theme tokens
class HtmlColors {
  static const Color bg = Color(0xFFF9FAFB); // grey.shade50
  static const Color card = Colors.white;
  static const Color ink = Color(0xFF1B2733);
  static const Color mut = Color(0xFF64748B); // Text secondary
  static const Color line = Color(0xFFE2E8F0);
  static const Color pri = Color(0xFF8A2BE2); // Primary
  static const Color acc = Color(0xFF6D28D9); // Accent
  static const Color sec = Color(0xFFB197FC); // Secondary
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: HtmlColors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(viewModel),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTabs(viewModel),
                    const SizedBox(height: 12),
                    _buildStepCard(viewModel, context),
                    const SizedBox(height: 100), // Padding for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
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
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 16, 18, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Home Icon (Largest)
            IconButton(
              padding: EdgeInsets.zero,
              icon: Image.asset('assets/images/queue.png', width: 64, height: 64),
              onPressed: () {
                final dashboardViewModel = Get.find<DashboardViewModel>();
                dashboardViewModel.changeTabIndex(0);
              },
            ),
            const SizedBox(width: 12),
            // 2. Camera Circle (Medium)
            _buildAvatar(viewModel),
            const SizedBox(width: 16),
            // 3. Text/Heading
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
                  Obx(() => Text(
                    'Step ${viewModel.currentStep.value + 1} of 3',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                    ),
                  )),
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
      return GestureDetector(
        onTap: () => viewModel.pickFile(viewModel.avatarPath, isImage: true),
        child: SizedBox(
          width: 56, // Medium size
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (!hasAvatar)
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CustomPaint(painter: _DottedCirclePainter()),
                ),
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hasAvatar ? Colors.transparent : Colors.white.withValues(alpha: 0.15),
                  border: Border.all(
                    color: isError ? HtmlColors.bad : (hasAvatar ? HtmlColors.acc : Colors.transparent),
                    width: 2,
                  ),
                  image: hasAvatar
                      ? DecorationImage(image: FileImage(File(viewModel.avatarPath.value!)), fit: BoxFit.cover)
                      : null,
                ),
                child: hasAvatar ? null : const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 22),
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
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
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
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(desc, style: const TextStyle(color: HtmlColors.mut, fontSize: 14)),
            const SizedBox(height: 16),
            content,
          ],
        ),
      );
    });
  }

  // ===== WIDGET HELPERS ===== //
  
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
                    style: const TextStyle(color: HtmlColors.mut, fontSize: 13, fontWeight: FontWeight.w600),
                    children: [
                      if (!isOpt) const TextSpan(text: ' *', style: TextStyle(color: HtmlColors.bad)),
                    ]
                  ),
                ),
              ),
            child,
            if (hasErr)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(error, style: const TextStyle(color: HtmlColors.bad, fontSize: 12)),
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
            borderSide: BorderSide(color: hasErr ? HtmlColors.bad : HtmlColors.line, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: hasErr ? HtmlColors.bad : HtmlColors.pri, width: 2),
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
          border: Border.all(color: hasErr ? HtmlColors.bad : HtmlColors.line, width: 1.5),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: rxValue.value,
            hint: const Text('Select', style: TextStyle(fontSize: 15)),
            isExpanded: true,
            items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) => rxValue.value = val,
          ),
        ),
      );
    });
  }

  Widget _pills({
    required RxString rxValue,
    required List<String> options,
  }) {
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
                border: Border.all(color: isSelected ? HtmlColors.pri : HtmlColors.line, width: 1.5),
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
        decoration: hasErr ? BoxDecoration(border: Border.all(color: HtmlColors.bad, width: 1.5), borderRadius: BorderRadius.circular(12)) : null,
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
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected ? HtmlColors.pri : HtmlColors.bg,
                  border: Border.all(color: isSelected ? HtmlColors.pri : HtmlColors.line, width: 1.5),
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
  }) {
    return Obx(() {
      final hasErr = viewModel.hasError(key);
      final hasFile = rxPath.value != null;
      return GestureDetector(
        onTap: () => viewModel.pickFile(rxPath, isImage: isImage),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: HtmlColors.bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasErr ? HtmlColors.bad : (hasFile ? HtmlColors.ok : HtmlColors.line),
              width: 1.5,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.upload_file, color: hasFile ? HtmlColors.ok : HtmlColors.mut, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  hasFile ? rxPath.value!.split('/').last : 'Choose file or take photo',
                  style: TextStyle(color: hasFile ? HtmlColors.ok : HtmlColors.mut, fontSize: 14),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ===== STEP 1 FIELDS ===== //
  Widget _buildStep1Fields(AddOutletViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sub('Shop details'),
        _fld(viewModel: vm, key: 'rtype', label: 'Retailer type', child: _pills(rxValue: vm.rtype, options: ['retailer', 'mechanic'])),
        _fld(viewModel: vm, key: 'shop', label: 'Shop name', child: _textInput(viewModel: vm, key: 'shop', controller: vm.shopController)),
        _fld(viewModel: vm, key: 'person', label: 'Contact person name', child: _textInput(viewModel: vm, key: 'person', controller: vm.personController)),
        
        _sub('Contact details'),
        _fld(viewModel: vm, key: 'mobile', label: 'Mobile number', child: _textInput(viewModel: vm, key: 'mobile', controller: vm.mobileController, type: TextInputType.phone, hint: '98XXXXXXXX')),
        
        Row(
          children: [
            Obx(() => Checkbox(value: vm.wacb.value, onChanged: vm.toggleWacb, activeColor: HtmlColors.pri)),
            const Expanded(child: Text('Mobile number is also my WhatsApp number', style: TextStyle(fontSize: 14, color: HtmlColors.ink))),
          ],
        ),
        
        _fld(viewModel: vm, key: 'wa', label: 'WhatsApp number', child: _textInput(viewModel: vm, key: 'wa', controller: vm.waController, type: TextInputType.phone)),
        _fld(viewModel: vm, key: 'email', label: 'Email ID', child: _textInput(viewModel: vm, key: 'email', controller: vm.emailController, type: TextInputType.emailAddress)),
        
        _sub('Address'),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: HtmlColors.acc,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 13),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            elevation: 0,
          ),
          onPressed: vm.captureLocation,
          icon: Obx(() => vm.isLocating.value ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.my_location)),
          label: const Text('Use my current location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        Obx(() => Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 12),
          child: Text(
            vm.capturedGeo.value != null ? 'Captured ${vm.capturedGeo.value}' : 'Fills address lines, state, city and pin code.',
            style: const TextStyle(color: HtmlColors.mut, fontSize: 13),
          ),
        )),
        
        _fld(viewModel: vm, key: 'a1', label: 'Address line 1', child: _textInput(viewModel: vm, key: 'a1', controller: vm.a1Controller)),
        _fld(viewModel: vm, key: 'a2', label: 'Address line 2', child: _textInput(viewModel: vm, key: 'a2', controller: vm.a2Controller)),
        _fld(viewModel: vm, key: 'a3', label: 'Address line 3', child: _textInput(viewModel: vm, key: 'a3', controller: vm.a3Controller)),
        _fld(viewModel: vm, key: 'state', label: 'State', child: _dropdown(viewModel: vm, key: 'state', rxValue: vm.selectedState, options: vm.statesList)),
        _fld(viewModel: vm, key: 'city', label: 'City', child: _textInput(viewModel: vm, key: 'city', controller: vm.cityController)),
        _fld(viewModel: vm, key: 'pin', label: 'Pin code', child: _textInput(viewModel: vm, key: 'pin', controller: vm.pinController, type: TextInputType.number)),
      ],
    );
  }

  // ===== STEP 2 FIELDS ===== //
  Widget _buildStep2Fields(AddOutletViewModel vm, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _fld(viewModel: vm, key: 'sub', label: 'Sub type', child: _dropdown(viewModel: vm, key: 'sub', rxValue: vm.subType, options: vm.subTypes)),
        _fld(viewModel: vm, key: 'chan', label: 'Channel', child: _dropdown(viewModel: vm, key: 'chan', rxValue: vm.channel, options: vm.channels)),
        _fld(viewModel: vm, key: 'seg', label: 'Segment', child: _dropdown(viewModel: vm, key: 'seg', rxValue: vm.segment, options: vm.segments)),
        _fld(viewModel: vm, key: 'cat', label: 'Category', child: _dropdown(viewModel: vm, key: 'cat', rxValue: vm.category, options: vm.categories)),
        _fld(viewModel: vm, key: 'cls', label: 'Class', child: _dropdown(viewModel: vm, key: 'cls', rxValue: vm.cls, options: vm.classes)),
        _fld(viewModel: vm, key: 'beat', label: 'Beat', child: _dropdown(viewModel: vm, key: 'beat', rxValue: vm.beat, options: vm.beats)),
        
        _sub('Shop profile'),
        _fld(viewModel: vm, key: 'size', label: 'Shop size (sq ft)', child: _textInput(viewModel: vm, key: 'size', controller: vm.sizeController, type: TextInputType.number)),
        _fld(viewModel: vm, key: 'pot', label: 'Monthly potential (₹)', child: _textInput(viewModel: vm, key: 'pot', controller: vm.potController, type: TextInputType.number)),
        _fld(viewModel: vm, key: 'brands', label: 'Brands stocked', child: _chips(viewModel: vm, key: 'brands', rxValues: vm.selectedBrands, options: vm.brands)),
        
        Row(
          children: [
            Expanded(
              child: _fld(viewModel: vm, key: 'open', label: 'Shop opens', child: _textInput(
                viewModel: vm, key: 'open', controller: TextEditingController(text: vm.openTime.value?.format(context) ?? ''), readOnly: true,
                onTap: () async {
                  final t = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 9, minute: 0));
                  if (t != null) vm.openTime.value = t;
                }
              )),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _fld(viewModel: vm, key: 'close', label: 'Shop closes', child: _textInput(
                viewModel: vm, key: 'close', controller: TextEditingController(text: vm.closeTime.value?.format(context) ?? ''), readOnly: true,
                onTap: () async {
                  final t = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 20, minute: 0));
                  if (t != null) vm.closeTime.value = t;
                }
              )),
            ),
          ],
        ),

        Obx(() {
          if (vm.rtype.value == 'mechanic') {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _sub('Workshop details'),
                _fld(viewModel: vm, key: 'wtype', label: 'Workshop type', child: _dropdown(viewModel: vm, key: 'wtype', rxValue: vm.wtype, options: vm.wtypes)),
                _fld(viewModel: vm, key: 'exp', label: 'Experience (years)', child: _textInput(viewModel: vm, key: 'exp', controller: vm.expController, type: TextInputType.number)),
                _fld(viewModel: vm, key: 'eng', label: 'Engine specialty', child: _dropdown(viewModel: vm, key: 'eng', rxValue: vm.eng, options: vm.engs)),
                _fld(viewModel: vm, key: 'mechs', label: 'Mechanics in workshop', child: _textInput(viewModel: vm, key: 'mechs', controller: vm.mechsController, type: TextInputType.number)),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  // ===== STEP 3 FIELDS ===== //
  Widget _buildStep3Fields(AddOutletViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sub('KYC'),
        _fld(viewModel: vm, key: 'doctype', label: 'Document type', child: _pills(rxValue: vm.doctype, options: ['Aadhaar', 'Driving Licence'])),
        _fld(viewModel: vm, key: 'fn', label: 'First name', child: _textInput(viewModel: vm, key: 'fn', controller: vm.fnController)),
        _fld(viewModel: vm, key: 'ln', label: 'Last name', child: _textInput(viewModel: vm, key: 'ln', controller: vm.lnController)),
        
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
        
        Obx(() {
          if (vm.doctype.value == 'Aadhaar') {
            return _fld(viewModel: vm, key: 'otp', label: 'Aadhaar OTP verification', child: _buildOtpBox(vm));
          }
          return const SizedBox.shrink();
        }),

        _fld(viewModel: vm, key: 'docf', label: 'Document attachment', child: _filePicker(viewModel: vm, key: 'docf', rxPath: vm.docfPath)),
        
        _sub('Bank details'),
        _fld(viewModel: vm, key: 'bank', label: 'Bank name', child: _textInput(viewModel: vm, key: 'bank', controller: vm.bankController)),
        _fld(viewModel: vm, key: 'holder', label: 'Account holder name', child: _textInput(viewModel: vm, key: 'holder', controller: vm.holderController)),
        _fld(viewModel: vm, key: 'acc', label: 'Account number', child: _textInput(viewModel: vm, key: 'acc', controller: vm.accController, type: TextInputType.number)),
        _fld(viewModel: vm, key: 'ifsc', label: 'IFSC code', child: _textInput(viewModel: vm, key: 'ifsc', controller: vm.ifscController)),
        _fld(viewModel: vm, key: 'bankf', label: 'Bank document (cheque / passbook)', child: _filePicker(viewModel: vm, key: 'bankf', rxPath: vm.bankfPath)),
        
        _sub('GST & licences (GST required, others optional)'),
        _fld(viewModel: vm, key: 'gst', label: 'GST type', child: _pills(rxValue: vm.gst, options: ['Registered', 'Unregistered'])),
        
        Obx(() {
          if (vm.gst.value == 'Registered') {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _fld(viewModel: vm, key: 'gstcat', label: 'GST category', child: _pills(rxValue: vm.gstcat, options: ['Regular', 'Composition', 'Both'])),
                _fld(viewModel: vm, key: 'gstno', label: 'GST number', child: _textInput(viewModel: vm, key: 'gstno', controller: vm.gstnoController)),
              ],
            );
          }
          return const SizedBox.shrink();
        }),

        _sub('Optional licences'),
        _fld(viewModel: vm, key: 'fssai', label: 'FSSAI number', isOpt: true, child: _textInput(viewModel: vm, key: 'fssai', controller: vm.fssaiController, type: TextInputType.number)),
        _fld(viewModel: vm, key: 'ff', label: 'FSSAI attachment', isOpt: true, child: _filePicker(viewModel: vm, key: 'ff', rxPath: vm.ffPath)),
        
        _fld(viewModel: vm, key: 'drug', label: 'Drug licence number', isOpt: true, child: _textInput(viewModel: vm, key: 'drug', controller: vm.drugController)),
        _fld(viewModel: vm, key: 'df', label: 'Drug licence attachment', isOpt: true, child: _filePicker(viewModel: vm, key: 'df', rxPath: vm.dfPath)),
        
        _fld(viewModel: vm, key: 'shopl', label: 'Shop licence number', isOpt: true, child: _textInput(viewModel: vm, key: 'shopl', controller: vm.shoplController)),
        _fld(viewModel: vm, key: 'sf', label: 'Shop licence attachment', isOpt: true, child: _filePicker(viewModel: vm, key: 'sf', rxPath: vm.sfPath)),
      ],
    );
  }

  Widget _buildOtpBox(AddOutletViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HtmlColors.bg,
        border: Border.all(color: vm.otpVerified.value ? HtmlColors.ok : HtmlColors.line, width: 1.5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: vm.otpVerified.value ? [BoxShadow(color: HtmlColors.ok.withValues(alpha: 0.2), spreadRadius: 4)] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  color: vm.otpVerified.value ? HtmlColors.ok : HtmlColors.pri,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified_user, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Aadhaar verification', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Enter the 12-digit Aadhaar number above, then send an OTP.', style: TextStyle(fontSize: 13, color: HtmlColors.mut)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          if (vm.otpVerified.value)
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: HtmlColors.ok, disabledBackgroundColor: HtmlColors.ok,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
              ),
              child: const Text('Aadhaar verified ✓', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
              else if (!vm.otpSent.value)
                ElevatedButton(
                  onPressed: vm.sendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HtmlColors.pri,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                    elevation: 0,
                  ),
                  child: const Text('Send OTP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                )
          else
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (i) => Container(
                    width: 45, height: 56,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextField(
                      controller: vm.otpInputs[i],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true, fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: HtmlColors.line)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: HtmlColors.pri)),
                      ),
                      onChanged: (val) {
                        if (val.isNotEmpty && i < 5) FocusScope.of(Get.context!).nextFocus();
                      },
                    ),
                  )),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: vm.verifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HtmlColors.pri,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                    ),
                    child: const Text('Verify OTP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          
          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (vm.docnoError.value.isNotEmpty) 
                  Padding(padding: const EdgeInsets.only(top: 8), child: Text(vm.docnoError.value, style: const TextStyle(color: HtmlColors.bad, fontSize: 13))),
                if (vm.otpError.value.isNotEmpty) 
                  Padding(padding: const EdgeInsets.only(top: 8), child: Text(vm.otpError.value, style: TextStyle(color: vm.otpError.value.contains('Demo OTP') ? HtmlColors.mut : HtmlColors.bad, fontSize: 13))),
              ],
            );
          }),
        ],
      ),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                    ),
                    child: const Text('Back', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            Expanded(
              child: ElevatedButton(
                onPressed: viewModel.nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: step == 2 ? HtmlColors.ok : HtmlColors.pri,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                ),
                child: Text(
                  step == 2 ? 'Submit for approval' : 'Next',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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

