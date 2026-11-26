import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../add_outlet_viewmodel.dart';
import '../explore_screen.dart'; // For HtmlColors

class OutletPreviewBottomSheet extends StatelessWidget {
  final AddOutletViewModel viewModel;

  const OutletPreviewBottomSheet({
    super.key,
    required this.viewModel,
  });

  static Future<void> show(BuildContext context, AddOutletViewModel viewModel) async {
    if (!viewModel.validateAllSteps()) return;

    Get.bottomSheet(
      OutletPreviewBottomSheet(viewModel: viewModel),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      enterBottomSheetDuration: const Duration(milliseconds: 350),
      exitBottomSheetDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final maxHeight = (mediaQuery.size.height * 0.85).floorToDouble();

    return SizedBox(
      height: maxHeight,
      child: Container(
        decoration: const BoxDecoration(
          color: HtmlColors.bg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
          // Header Handle Bar & Title
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(bottom: BorderSide(color: HtmlColors.line)),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: HtmlColors.lineConnector,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.rate_review_outlined, color: HtmlColors.pri, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Preview Outlet Details',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: HtmlColors.ink,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close_rounded, color: HtmlColors.mut),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 10),
                  _buildMobileVerificationCard(),
                  const SizedBox(height: 10),
                  _buildClassificationCard(),
                  const SizedBox(height: 10),
                  _buildAddressCard(),
                  const SizedBox(height: 10),
                  _buildBusinessDetailsCard(),
                  if (viewModel.rtypeName.value.toLowerCase() == 'mechanic') ...[
                    const SizedBox(height: 10),
                    _buildMechanicDetailsCard(),
                  ],
                  const SizedBox(height: 10),
                  _buildBankAndGstCard(),
                  const SizedBox(height: 10),
                  _buildDocumentsCard(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Action Buttons Bar (Edit Details & Submit Outlet)
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: HtmlColors.line)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: HtmlColors.ink,
                          side: const BorderSide(color: HtmlColors.line, width: 1.5),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Edit Details',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: Obx(() {
                        final isLoading = viewModel.isLoading.value;
                        return ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  await viewModel.submitForm();
                                  if (Get.isBottomSheetOpen == true) {
                                    Get.back();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HtmlColors.pri,
                            foregroundColor: Colors.white,
                            elevation: 1,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Submit Outlet',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(Icons.check_circle_outline_rounded, size: 17),
                                    ],
                                  ),
                                ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  // --- Section Card Builder Helper ---
  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HtmlColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: HtmlColors.pri, size: 18),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: HtmlColors.ink,
                ),
              ),
            ],
          ),
          const Divider(height: 16, color: HtmlColors.line),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isVerified = false}) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                color: HtmlColors.mut,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(' : ', style: TextStyle(color: HtmlColors.mut)),
          Expanded(child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    color: HtmlColors.ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isVerified) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFA5D6A7)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 12),
                        SizedBox(width: 3),
                        Text(
                          'Verified',
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Cards ---
  Widget _buildHeaderCard() {
    final avatar = viewModel.avatarPath.value;
    final hasAvatar = avatar != null && avatar.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HtmlColors.line),
      ),
      child: Column(
        children: [
          if (hasAvatar)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              child: SizedBox(
                height: 140,
                width: double.infinity,
                child: Image.file(
                  File(avatar),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                if (!hasAvatar)
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: HtmlColors.pri.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.storefront_rounded, color: HtmlColors.pri, size: 28),
                  ),
                if (!hasAvatar) const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.shopController.text.trim(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: HtmlColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Contact: ${viewModel.personController.text.trim()}',
                        style: const TextStyle(fontSize: 13, color: HtmlColors.mut),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: HtmlColors.pri.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    viewModel.rtypeName.value.toUpperCase(),
                    style: const TextStyle(
                      color: HtmlColors.pri,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileVerificationCard() {
    return _buildCard(
      title: 'Contact & Mobile Verification',
      icon: Icons.phone_android_rounded,
      children: [
        _buildInfoRow(
          'Mobile Number',
          viewModel.mobileController.text.trim(),
          isVerified: viewModel.isMobileVerified.value,
        ),
        if (viewModel.waController.text.trim().isNotEmpty)
          _buildInfoRow('WhatsApp', viewModel.waController.text.trim()),
        if (viewModel.emailController.text.trim().isNotEmpty)
          _buildInfoRow('Email ID', viewModel.emailController.text.trim()),
      ],
    );
  }

  Widget _buildClassificationCard() {
    return _buildCard(
      title: 'Outlet Classification',
      icon: Icons.category_outlined,
      children: [
        _buildInfoRow('Sub Type', viewModel.selectedSubTypeName),
        _buildInfoRow('Channel', viewModel.selectedChannelName),
        _buildInfoRow('Segment', viewModel.selectedSegmentName),
        _buildInfoRow('Category', viewModel.selectedCategoryName),
        _buildInfoRow('Class', viewModel.selectedClassName),
        _buildInfoRow('Beat / Territory', viewModel.selectedBeatName),
      ],
    );
  }

  Widget _buildAddressCard() {
    final geo = viewModel.capturedGeo.value ?? '';
    return _buildCard(
      title: 'Address & Location',
      icon: Icons.location_on_outlined,
      children: [
        _buildInfoRow('Address Line 1', viewModel.a1Controller.text.trim()),
        if (viewModel.a2Controller.text.trim().isNotEmpty)
          _buildInfoRow('Address Line 2', viewModel.a2Controller.text.trim()),
        if (viewModel.a3Controller.text.trim().isNotEmpty)
          _buildInfoRow('Landmark', viewModel.a3Controller.text.trim()),
        _buildInfoRow('City', viewModel.cityController.text.trim()),
        _buildInfoRow('State', viewModel.selectedState.value ?? ''),
        _buildInfoRow('Pin Code', viewModel.pinController.text.trim()),
        if (geo.isNotEmpty) _buildInfoRow('GPS Location', geo),
      ],
    );
  }

  Widget _buildBusinessDetailsCard() {
    final est = viewModel.establishedYearController.text.trim();
    final size = viewModel.shopSizeController.text.trim();
    final pot = viewModel.monthlyPotentialController.text.trim();
    final brands = viewModel.selectedBrands;

    final openT = viewModel.openTime.value;
    final closeT = viewModel.closeTime.value;
    final timings = (openT != null && closeT != null)
        ? '${openT.format(Get.context!)} - ${closeT.format(Get.context!)}'
        : '';

    final dob = viewModel.dob.value;
    final dobStr = dob != null ? '${dob.day}/${dob.month}/${dob.year}' : '';

    final anniversary = viewModel.anniversary.value;
    final annStr = anniversary != null
        ? '${anniversary.day}/${anniversary.month}/${anniversary.year}'
        : '';

    return _buildCard(
      title: 'Business & Profile Details',
      icon: Icons.business_center_outlined,
      children: [
        if (est.isNotEmpty) _buildInfoRow('Established Year', est),
        if (dobStr.isNotEmpty) _buildInfoRow('Date of Birth', dobStr),
        if (annStr.isNotEmpty) _buildInfoRow('Anniversary', annStr),
        if (size.isNotEmpty) _buildInfoRow('Shop Size', '$size sq. ft.'),
        if (pot.isNotEmpty) _buildInfoRow('Monthly Potential', '₹ $pot'),
        if (timings.isNotEmpty) _buildInfoRow('Shop Timings', timings),
        if (brands.isNotEmpty) ...[
          const SizedBox(height: 4),
          const Text(
            'Stocked Brands:',
            style: TextStyle(fontSize: 12.5, color: HtmlColors.mut, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: brands.map((b) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: HtmlColors.pri.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: HtmlColors.pri.withValues(alpha: 0.3)),
                ),
                child: Text(
                  b,
                  style: const TextStyle(fontSize: 11.5, color: HtmlColors.pri, fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildMechanicDetailsCard() {
    final exp = viewModel.expController.text.trim();
    final eng = viewModel.eng.value ?? '';
    final mechs = viewModel.mechsController.text.trim();

    return _buildCard(
      title: 'Mechanic Profile Details',
      icon: Icons.handyman_outlined,
      children: [
        _buildInfoRow('Workshop Type', viewModel.selectedWorkshopTypeName),
        if (exp.isNotEmpty) _buildInfoRow('Experience', '$exp years'),
        if (eng.isNotEmpty) _buildInfoRow('Engine Specialty', eng),
        if (mechs.isNotEmpty) _buildInfoRow('Mechanics Count', mechs),
      ],
    );
  }

  Widget _buildBankAndGstCard() {
    final bank = viewModel.bankController.text.trim();
    final holder = viewModel.holderController.text.trim();
    final acc = viewModel.accController.text.trim();
    final ifsc = viewModel.ifscController.text.trim();

    final gst = viewModel.gst.value;
    final gstcat = viewModel.gstcat.value;
    final gstno = viewModel.gstnoController.text.trim();

    return _buildCard(
      title: 'Bank & GST Information',
      icon: Icons.account_balance_outlined,
      children: [
        if (bank.isNotEmpty) _buildInfoRow('Bank Name', bank),
        if (holder.isNotEmpty) _buildInfoRow('Account Holder', holder),
        if (acc.isNotEmpty) _buildInfoRow('Account No.', acc),
        if (ifsc.isNotEmpty) _buildInfoRow('IFSC Code', ifsc),
        _buildInfoRow('GST Type', gst),
        if (gst == 'Registered') ...[
          _buildInfoRow('GST Category', gstcat),
          if (gstno.isNotEmpty) _buildInfoRow('GSTIN Number', gstno),
        ],
      ],
    );
  }

  Widget _buildDocumentsCard() {
    final docType = viewModel.kycDocTypeName.value;
    final docNo = viewModel.docnoController.text.trim();
    final docPath = viewModel.docfPath.value;
    final bankPath = viewModel.bankfPath.value;

    return _buildCard(
      title: 'Uploaded Attachments',
      icon: Icons.attachment_rounded,
      children: [
        if (docType.isNotEmpty) _buildInfoRow('KYC Type', docType),
        if (docNo.isNotEmpty) _buildInfoRow('Document No.', docNo),
        _buildFileAttachmentRow('KYC Document', docPath),
        _buildFileAttachmentRow('Bank Proof Document', bankPath),
        if (viewModel.ffPath.value != null)
          _buildFileAttachmentRow('FSSAI Document', viewModel.ffPath.value),
        if (viewModel.dfPath.value != null)
          _buildFileAttachmentRow('Drug Licence Document', viewModel.dfPath.value),
        if (viewModel.sfPath.value != null)
          _buildFileAttachmentRow('Shop Licence Document', viewModel.sfPath.value),
      ],
    );
  }

  Widget _buildFileAttachmentRow(String label, String? filePath) {
    final hasFile = filePath != null && filePath.isNotEmpty;
    final fileName = hasFile ? filePath.split('/').last : 'Not uploaded';

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12.5, color: HtmlColors.mut),
            ),
          ),
          const Text(' : ', style: TextStyle(color: HtmlColors.mut)),
          Expanded(
            child: Row(
              children: [
                Icon(
                  hasFile ? Icons.insert_drive_file_outlined : Icons.cancel_outlined,
                  size: 15,
                  color: hasFile ? HtmlColors.ok : HtmlColors.mut,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: hasFile ? HtmlColors.ok : HtmlColors.mut,
                      fontWeight: hasFile ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
