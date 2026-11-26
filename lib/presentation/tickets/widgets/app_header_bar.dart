import 'package:flutter/material.dart';

class AppHeaderBar extends StatelessWidget {
  final String title;
  final VoidCallback onBackPressed;
  final Widget? trailing;

  const AppHeaderBar({
    super.key,
    required this.title,
    required this.onBackPressed,
    this.trailing,
  });

  static const Color primaryPurple = Color(0xFF555ABC);
  static const Color primaryDarkBlue = Color(0xFF17193F);
  static const Color primaryLightBlue = Color(0xFF8B8ED3);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      constraints: const BoxConstraints(minHeight: 60),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryDarkBlue, primaryPurple, primaryLightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryPurple.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: onBackPressed,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
