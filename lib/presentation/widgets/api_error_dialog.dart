import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/network/api_exception.dart';

/// Shows a professional center-screen API validation error dialog
/// matching the exact visual styling specified in design guidelines.
void showApiErrorDialog({
  String? title,
  String? description,
  List<String>? errors,
  Object? error,
}) {
  // Prevent multiple overlapping error dialogs
  if (Get.isDialogOpen == true) {
    Get.back();
  }

  String dialogTitle = title ?? 'Unable to Process Request';
  String dialogDescription = description ?? 'Please check the details below and try again.';
  List<String> displayErrors = errors ?? [];
  List<ApiValidationErrorItem> structuredErrors = [];

  if (error != null) {
    if (error is ApiException) {
      dialogTitle = title ?? error.title;
      dialogDescription = description ?? error.message;
      structuredErrors = error.errors;
      displayErrors = error.errors.map((e) => e.displayMessage).toList();
    } else {
      final msg = error.toString().replaceAll('Exception: ', '').trim();
      if (displayErrors.isEmpty && msg.isNotEmpty) {
        displayErrors = [msg];
      }
    }
  }

  if (displayErrors.isEmpty) {
    displayErrors = ['An unexpected error occurred. Please try again.'];
  }

  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFCDAD9), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row: Circular Icon Avatar, Title & Subtitle, Close (X)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFCDAD9),
                      ),
                      child: Icon(
                        _getHeaderIcon(dialogTitle),
                        color: const Color(0xFF8B2525),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dialogTitle,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF17193F),
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            dialogDescription,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B6F93),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Color(0xFF6B6F93),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),

                // Stacked Error Rows
                if (displayErrors.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(displayErrors.length, (index) {
                      final errText = displayErrors[index];
                      final fieldName = index < structuredErrors.length ? structuredErrors[index].field : null;
                      final iconData = _getFieldIcon(fieldName, errText);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFADBD8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF5B7B1), width: 0.8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              iconData,
                              color: const Color(0xFF8B2525),
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                errText,
                                style: const TextStyle(
                                  color: Color(0xFF8B2525),
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  height: 1.25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
    barrierDismissible: true,
  );
}

IconData _getHeaderIcon(String title) {
  final lower = title.toLowerCase();
  if (lower.contains('customer') || lower.contains('outlet') || lower.contains('user')) {
    return Icons.person_outline_rounded;
  }
  if (lower.contains('plan') || lower.contains('date')) {
    return Icons.event_busy_rounded;
  }
  return Icons.error_outline_rounded;
}

IconData _getFieldIcon(String? field, String errText) {
  final f = field?.toLowerCase() ?? '';
  final lower = errText.toLowerCase();

  if (f == 'todate' || f == 'fromdate' || f == 'days' || lower.contains('date') || lower.contains('days') || lower.contains('duration')) {
    return Icons.calendar_today_outlined;
  }
  if (f == 'mobilenumber' || f == 'mobile' || f == 'phone' || lower.contains('mobile') || lower.contains('phone') || lower.contains('number')) {
    return Icons.phone_outlined;
  }
  if (f == 'email' || lower.contains('email') || lower.contains('mail')) {
    return Icons.email_outlined;
  }
  if (f == 'customer' || f == 'name' || lower.contains('customer') || lower.contains('name')) {
    return Icons.person_outline_rounded;
  }
  return Icons.error_outline_rounded;
}
