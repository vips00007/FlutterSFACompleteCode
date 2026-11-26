import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/shared_prefs_manager.dart';
import '../../domain/entities/outlet.dart';
import '../favorites/favorites_viewmodel.dart';
import '../profile/profile_viewmodel.dart';
import '../home/home_viewmodel.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Color Constants matching My Profile Screen (ProfileScreen)
  static const Color primaryBlue = Color(0xFF555ABC);
  static const Color primaryDarkBlue = Color(0xFF17193F);
  static const Color primaryLightBlue = Color(0xFF8B8ED3);
  static const Color bgColor = Color(0xFFF4F3F9);
  static const Color cardColor = Colors.white;
  static const Color inkColor = Color(0xFF17193F);
  static const Color slateColor = Color(0xFF6B6F93);
  static const Color lineColor = Color(0xFFDCDBEA);

  bool _isSubmitted = false;
  // Controllers
  late final TextEditingController _distributorNameController;
  late final TextEditingController _ownerNameController;
  late final TextEditingController _mobileController;
  late final TextEditingController _emailController;
  late final TextEditingController _areaController;
  late final TextEditingController _gstController;

  @override
  void initState() {
    super.initState();
    final savedName =
        SharedPrefsManager.getName() ?? SharedPrefsManager.getSavedUsername() ?? '';
    final savedMobile = SharedPrefsManager.getMobile() ??
        (SharedPrefsManager.getSavedUsername()?.contains('@') == false
            ? SharedPrefsManager.getSavedUsername()
            : '') ??
        '';
    final savedEmail = SharedPrefsManager.getEmail() ??
        (SharedPrefsManager.getSavedUsername()?.contains('@') == true
            ? SharedPrefsManager.getSavedUsername()
            : '') ??
        '';
    final savedCompany = SharedPrefsManager.getCompanyCode() ?? 'LUMAN';

    _distributorNameController = TextEditingController(text: savedCompany);
    _ownerNameController = TextEditingController(text: savedName.isNotEmpty ? savedName : 'Golu Yadav');
    _mobileController = TextEditingController(text: savedMobile.isNotEmpty ? savedMobile : '7725860819');
    _emailController = TextEditingController(text: savedEmail);
    _areaController = TextEditingController(text: 'Bhopal North · Beat 4');
    _gstController = TextEditingController(text: '23AABCSO231F1Z5');

    final Outlet? outlet = Get.arguments as Outlet?;
    if (outlet != null) {
      if (outlet.firmName.isNotEmpty) _distributorNameController.text = outlet.firmName;
      if (outlet.firstName.isNotEmpty || outlet.lastName.isNotEmpty) {
        _ownerNameController.text = '${outlet.firstName} ${outlet.lastName}'.trim();
      }
      if (outlet.mobileNumber.isNotEmpty) _mobileController.text = outlet.mobileNumber;
    }
  }

  @override
  void dispose() {
    _distributorNameController.dispose();
    _ownerNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _areaController.dispose();
    _gstController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final ownerName = _ownerNameController.text.trim();
    final mobile = _mobileController.text.trim();
    final email = _emailController.text.trim();

    if (ownerName.isEmpty) {
      Get.snackbar('Validation Error', 'Please enter your name',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.shade50);
      return;
    }

    if (mobile.isNotEmpty && (mobile.length != 10 || !RegExp(r'^\d{10}$').hasMatch(mobile))) {
      Get.snackbar('Validation Error', 'Please enter a valid 10-digit mobile number',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.shade50);
      return;
    }

    if (email.isNotEmpty && !RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
      Get.snackbar('Validation Error', 'Please enter a valid email address',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.shade50);
      return;
    }

    await SharedPrefsManager.saveName(ownerName);
    if (mobile.isNotEmpty) {
      await SharedPrefsManager.saveMobile(mobile);
    }
    if (email.isNotEmpty) {
      await SharedPrefsManager.saveEmail(email);
    }

    // Refresh active ViewModels across app
    if (Get.isRegistered<FavoritesViewModel>()) {
      Get.find<FavoritesViewModel>().loadUserData();
    }
    if (Get.isRegistered<ProfileViewModel>()) {
      Get.find<ProfileViewModel>().loadUserData();
    }
    if (Get.isRegistered<HomeViewModel>()) {
      Get.find<HomeViewModel>().loadUserData();
    }

    setState(() {
      _isSubmitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isSubmitted) {
      return _buildSubmittedView();
    }
    return _buildEditFormView();
  }

  Widget _buildEditFormView() {
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroAndNoticeSection(),
            _buildPersonalDetailsCard(),
            _buildWorkDetailsCard(),
            _buildSaveButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
/////////thi=
  Widget _buildHeroAndNoticeSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: _buildHeroHeader(),
        ),
        Positioned(
          left: 12,
          right: 12,
          bottom: 0,
          child: _buildNoticeBanner(),
        ),
      ],
    );
  }

  Widget _buildHeroHeader() {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final name = _ownerNameController.text.trim().isNotEmpty
        ? _ownerNameController.text.trim()
        : 'Golu Yadav';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'G';
    final company = _distributorNameController.text.trim().isNotEmpty
        ? _distributorNameController.text.trim()
        : 'LUMAN';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryDarkBlue, primaryBlue, primaryLightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withValues(alpha: 0.22),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Glow Circles
          Positioned(
            right: -40,
            top: -50,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -40,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14, statusBarHeight + 10, 14, 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Action Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.20),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    Text(
                      'EDIT PROFILE',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.90),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                    InkWell(
                      onTap: _submitForm,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.check_rounded,
                              color: primaryBlue,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Done',
                              style: TextStyle(
                                color: primaryBlue,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Compact Profile Header Row (Without "Update profile details" text)
                Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              colors: [
                                Color(0xFFFFD166),
                                Color(0xFF60A5FA),
                                Color(0xFF93C5FD),
                                Color(0xFFFFD166),
                              ],
                            ),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF171B78),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              initial,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Icon(
                              Icons.edit_rounded,
                              color: primaryBlue,
                              size: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.22),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 7,
                                      height: 7,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF5DF2A6),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      'Active',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.22),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.domain_rounded,
                                      color: Colors.white,
                                      size: 13,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      company,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: lineColor),
        boxShadow: [
          BoxShadow(
            color: inkColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF59F00),
                  Color(0xFFFFD24A),
                ],
              ),
            ),
            child: const Icon(
              Icons.access_time_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Changes go to the company for approval',
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  'Updates stay pending until approved.',
                  style: TextStyle(
                    color: slateColor,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDetailsCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: lineColor),
        boxShadow: [
          BoxShadow(
            color: inkColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('PERSONAL DETAILS'),
          const SizedBox(height: 10),
          _buildInputField(
            label: 'Full Name',
            icon: Icons.person_outline_rounded,
            controller: _ownerNameController,
            hintText: 'Enter full name',
          ),
          const SizedBox(height: 10),
          _buildMobileInputField(),
          const SizedBox(height: 10),
          _buildInputField(
            label: 'Email Address',
            icon: Icons.email_outlined,
            controller: _emailController,
            hintText: 'name@company.com',
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkDetailsCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: lineColor),
        boxShadow: [
          BoxShadow(
            color: inkColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('WORK DETAILS'),
          const SizedBox(height: 10),
          _buildInputField(
            label: 'Distributor / Company Code',
            icon: Icons.domain_rounded,
            controller: _distributorNameController,
            hintText: 'Company Code',
          ),
          const SizedBox(height: 10),
          _buildInputField(
            label: 'Area / Beat',
            icon: Icons.location_on_outlined,
            controller: _areaController,
            hintText: 'Area / Beat location',
          ),
          const SizedBox(height: 10),
          _buildLockedGstField(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 12,
          decoration: BoxDecoration(
            color: primaryBlue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            color: primaryBlue,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    String? hintText,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 4),
          child: Text(
            label,
            style: const TextStyle(
              color: slateColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF9FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: lineColor, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  icon,
                  color: primaryBlue,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  style: const TextStyle(
                    color: inkColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      color: slateColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 2, bottom: 4),
          child: Text(
            'Mobile Number',
            style: TextStyle(
              color: slateColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF9FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: lineColor, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.phone_outlined,
                  color: primaryBlue,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.only(right: 10),
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: lineColor,
                      width: 1,
                    ),
                  ),
                ),
                child: const Text(
                  '+91',
                  style: TextStyle(
                    color: inkColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                    color: inkColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '7725860819',
                    hintStyle: TextStyle(
                      color: slateColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLockedGstField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 2, bottom: 4),
          child: Text(
            'GST Number',
            style: TextStyle(
              color: slateColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        CustomPaint(
          painter: _DashedBorderPainter(
            color: lineColor,
            radius: 14,
            strokeWidth: 1,
          ),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F3F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.receipt_long_outlined,
                    color: primaryBlue,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _gstController.text,
                    style: const TextStyle(
                      color: slateColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.lock_outline_rounded,
                        color: slateColor,
                        size: 13,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Locked',
                        style: TextStyle(
                          color: slateColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Row(
            children: const [
              Icon(
                Icons.info_outline_rounded,
                color: slateColor,
                size: 13,
              ),
              SizedBox(width: 5),
              Text(
                "GST number can't be edited here",
                style: TextStyle(
                  color: slateColor,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryDarkBlue,
            primaryBlue,
            primaryLightBlue,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _submitForm,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Save Changes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmittedView() {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0F000000),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: inkColor,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Edit profile',
                    style: TextStyle(
                      color: inkColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [primaryDarkBlue, primaryBlue],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryBlue.withValues(alpha: 0.30),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.check_rounded, color: Colors.white, size: 36),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Sent for approval',
                      style: TextStyle(
                        color: inkColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Your profile changes were saved and sent for approval.\nUpdates will reflect across your application.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: slateColor,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: lineColor),
                        boxShadow: [
                          BoxShadow(
                            color: inkColor.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'SUBMITTED CHANGES',
                            style: TextStyle(
                              color: primaryBlue,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Name', style: TextStyle(color: slateColor, fontSize: 13)),
                              Text(
                                _ownerNameController.text,
                                style: const TextStyle(color: inkColor, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(color: lineColor, height: 1),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Mobile', style: TextStyle(color: slateColor, fontSize: 13)),
                              Text(
                                '+91 ${_mobileController.text}',
                                style: const TextStyle(color: inkColor, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                          if (_emailController.text.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(color: lineColor, height: 1),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Email', style: TextStyle(color: slateColor, fontSize: 13)),
                                Text(
                                  _emailController.text,
                                  style: const TextStyle(color: inkColor, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(color: lineColor, height: 1),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Status', style: TextStyle(color: slateColor, fontSize: 13)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF8E1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.access_time_rounded, color: Color(0xFFF57F17), size: 13),
                                    SizedBox(width: 4),
                                    Text(
                                      'Pending approval',
                                      style: TextStyle(color: Color(0xFFF57F17), fontWeight: FontWeight.bold, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [primaryDarkBlue, primaryBlue],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Back to profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double strokeWidth;

  _DashedBorderPainter({
    required this.color,
    required this.radius,
    this.strokeWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    final Path path = Path()..addRRect(rrect);

    final Path dashPath = Path();
    const double dashWidth = 5.0;
    const double dashSpace = 3.0;

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double len = (distance + dashWidth < metric.length)
            ? dashWidth
            : metric.length - distance;
        dashPath.addPath(metric.extractPath(distance, distance + len), Offset.zero);
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
