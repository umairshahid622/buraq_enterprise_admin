import 'package:buraq_enterprise_admin/core/config/extensions/app_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppUtils {
  static String formatPKR(num amount) {
    final formatter = NumberFormat('#,##0', 'en_IN');
    return "Rs ${formatter.format(amount)}";
  }

  static String? phoneNumberValidator({required String value}) {
    if (value.isEmpty) {
      return 'Please enter your phone number';
    }

    String pattern = r'^(03|(\+923))[0-9]{9}$';
    RegExp regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return 'Enter a valid number (e.g., 03001234567)';
    }
    return null;
  }

  static String? textValidator({required String value}) {
    if (value.isEmpty) {
      return 'This Field is Required';
    }
    return null;
  }

  static void showToast({
    required BuildContext context,
    required String label,
    required String vairant,
  }) {
    final Color backgroundColor;
    switch (vairant) {
      case "success":
        backgroundColor = context.appColors.colorGreen;
        break;
      case "error":
        backgroundColor = context.appColors.error;
        break;
      default:
        backgroundColor = context.appColors.colorGreen;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        width: 280.0,
        duration: const Duration(seconds: 2),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
    );
  }
}
