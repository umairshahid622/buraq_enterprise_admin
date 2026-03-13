import 'package:buraq_enterprise_admin/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppUtils {
  static String getFirebaseErrorMessage({required String message}) {
    String msg = message.toString();

    if (msg.startsWith('Exception: ')) {
      msg = msg.substring(11);
    }
    return msg;
  }

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

  static String? amountValidator({required int value}) {
    if (value <= 0) {
      return "Amount must be greater than 0";
    }
    return null;
  }

  static String getFormattedPhoneNumber({required String phoneNumber}) {
    String formattedPhone = phoneNumber.trim();
    if (formattedPhone.startsWith('0')) {
      formattedPhone = '+92${formattedPhone.substring(1)}';
    } else if (!formattedPhone.startsWith('+')) {
      formattedPhone = '+92$formattedPhone';
    }
    return formattedPhone;
  }

  static void showToast({
    required String label,
    required ToastVariants vairant,
  }) {
    final scaffoldState = AppConstants.scaffoldMessengerKey.currentState;
    if (scaffoldState == null) return;
    final context = scaffoldState.context;
    final Color backgroundColor;
    switch (vairant) {
      case ToastVariants.success:
        backgroundColor = context.appColors.primary;
        break;
      case ToastVariants.error:
        backgroundColor = context.appColors.error;
        break;
    }
    
    scaffoldState.showSnackBar(
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
