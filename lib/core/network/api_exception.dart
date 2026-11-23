import 'dart:convert';

/// Represents a single validation error item returned from the API.
class ApiValidationErrorItem {
  final String? field;
  final String rawMessage;

  ApiValidationErrorItem({
    this.field,
    required this.rawMessage,
  });

  /// Provides a clean, user-friendly display message for UI components.
  String get displayMessage {
    final msg = rawMessage.trim();
    final f = field?.trim();

    if (f != null && f.isNotEmpty) {
      // Specific domain requirement mapping
      if ((f == 'toDate' || f == 'fromDate' || f == 'days') &&
          (msg.toLowerCase().contains('31 days') || msg.toLowerCase().contains('span at most'))) {
        return 'Plan duration must not exceed 31 days.';
      }

      // Check if message already contains field name
      final lowerMsg = msg.toLowerCase();
      final lowerField = f.toLowerCase();
      if (!lowerMsg.contains(lowerField)) {
        final formattedField = _formatFieldName(f);
        return '$formattedField: $msg';
      }
    }

    return msg.isNotEmpty ? msg : 'Validation error occurred';
  }

  static String _formatFieldName(String fieldName) {
    if (fieldName == 'toDate') return 'To Date';
    if (fieldName == 'fromDate') return 'From Date';
    if (fieldName == 'customerUuids') return 'Customers';
    if (fieldName == 'mobileNumber' || fieldName == 'mobile') return 'Mobile Number';

    // Convert camelCase to Title Case
    final result = fieldName.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(1)}',
    );
    return result[0].toUpperCase() + result.substring(1).trim();
  }

  @override
  String toString() => displayMessage;
}

/// Structured exception parsed from API response payloads.
class ApiException implements Exception {
  final int statusCode;
  final String? code;
  final String title;
  final String message;
  final List<ApiValidationErrorItem> errors;
  final String rawBody;

  ApiException({
    required this.statusCode,
    this.code,
    required this.title,
    required this.message,
    required this.errors,
    required this.rawBody,
  });

  /// Dynamically parses an API error response body.
  factory ApiException.fromResponse(
    int statusCode,
    String responseBody, {
    String? defaultTitle,
  }) {
    String parsedTitle = defaultTitle ?? 'Unable to Process Request';
    String parsedMessage = 'Please check the details below and try again.';
    String? errorCode;
    List<ApiValidationErrorItem> errorItems = [];

    try {
      if (responseBody.isNotEmpty && responseBody.trim().startsWith('{')) {
        final Map<String, dynamic> json = jsonDecode(responseBody);

        if (json['code'] != null) {
          errorCode = json['code'].toString();
        }

        if (json['message'] != null && json['message'].toString().trim().isNotEmpty) {
          final serverMsg = json['message'].toString().trim();
          if (errorCode == 'VALIDATION_ERROR' || serverMsg.toLowerCase().contains('validation failed')) {
            if (defaultTitle != null && defaultTitle.isNotEmpty) {
              parsedTitle = defaultTitle;
            } else {
              parsedTitle = 'Validation Error';
            }
          } else {
            parsedTitle = serverMsg;
          }
        }

        // Parse 'errors' field
        final rawErrors = json['errors'] ?? json['details'] ?? json['data']?['errors'];
        if (rawErrors != null) {
          if (rawErrors is List) {
            for (var item in rawErrors) {
              if (item is Map) {
                final field = item['field']?.toString();
                final msg = item['message']?.toString() ?? item['error']?.toString() ?? item.toString();
                if (msg.isNotEmpty) {
                  errorItems.add(ApiValidationErrorItem(field: field, rawMessage: msg));
                }
              } else if (item != null) {
                final str = item.toString().trim();
                if (str.isNotEmpty) {
                  errorItems.add(ApiValidationErrorItem(rawMessage: str));
                }
              }
            }
          } else if (rawErrors is Map) {
            rawErrors.forEach((key, val) {
              errorItems.add(ApiValidationErrorItem(field: key.toString(), rawMessage: val.toString()));
            });
          } else if (rawErrors is String && rawErrors.trim().isNotEmpty) {
            errorItems.add(ApiValidationErrorItem(rawMessage: rawErrors.trim()));
          }
        }
      }
    } catch (_) {
      // Body not JSON
    }

    // Default title tuning by status code / error code
    if (errorCode == 'VALIDATION_ERROR' && (defaultTitle == null || defaultTitle.isEmpty)) {
      parsedTitle = 'Unable to Create Plan';
    } else if (statusCode == 409 && (defaultTitle == null || defaultTitle.isEmpty)) {
      parsedTitle = 'Customer already exists';
    }

    // Fallbacks if no errors extracted
    if (errorItems.isEmpty) {
      if (statusCode == 409) {
        errorItems.add(ApiValidationErrorItem(rawMessage: 'Mobile number or email is already registered'));
      } else if (responseBody.isNotEmpty && !responseBody.trim().startsWith('{')) {
        errorItems.add(ApiValidationErrorItem(rawMessage: responseBody.trim()));
      } else {
        errorItems.add(ApiValidationErrorItem(rawMessage: 'Request failed with status code $statusCode'));
      }
    }

    return ApiException(
      statusCode: statusCode,
      code: errorCode,
      title: parsedTitle,
      message: parsedMessage,
      errors: errorItems,
      rawBody: responseBody,
    );
  }

  @override
  String toString() => '$title: ${errors.map((e) => e.displayMessage).join(', ')}';
}
