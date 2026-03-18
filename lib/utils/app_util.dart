import 'package:buraq_enterprise_admin/core/config/colors/app_color_scheme.dart';
import 'package:buraq_enterprise_admin/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppUtils {
  static String getFirebaseErrorMessage({required String message}) {
    String msg = message.toString();

    if (msg.startsWith('Exception: ')) {
      msg = msg.substring(11);
    }

    // ─── Firebase Auth ───────────────────────────────────────────
    switch (msg) {
      // Sign-in / Sign-up
      case 'user-not-found':
      case '[firebase_auth/user-not-found]':
        return 'No account found with this email address.';
      case 'wrong-password':
      case '[firebase_auth/wrong-password]':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
      case '[firebase_auth/email-already-in-use]':
        return 'This email is already registered. Try signing in.';
      case 'invalid-email':
      case '[firebase_auth/invalid-email]':
        return 'The email address is not valid.';
      case 'weak-password':
      case '[firebase_auth/weak-password]':
        return 'Password must be at least 6 characters.';
      case 'operation-not-allowed':
      case '[firebase_auth/operation-not-allowed]':
        return 'This sign-in method is not enabled.';

      // Account state
      case 'user-disabled':
      case '[firebase_auth/user-disabled]':
        return 'This account has been disabled. Contact support.';
      case 'user-token-expired':
      case '[firebase_auth/user-token-expired]':
        return 'Your session has expired. Please sign in again.';
      case 'invalid-user-token':
      case '[firebase_auth/invalid-user-token]':
        return 'Invalid session. Please sign in again.';

      // Credential / Provider
      case 'account-exists-with-different-credential':
      case '[firebase_auth/account-exists-with-different-credential]':
        return 'An account already exists with a different sign-in method.';
      case 'invalid-credential':
      case '[firebase_auth/invalid-credential]':
        return 'The credential is invalid or has expired.';
      case 'credential-already-in-use':
      case '[firebase_auth/credential-already-in-use]':
        return 'This credential is already linked to another account.';
      case 'provider-already-linked':
      case '[firebase_auth/provider-already-linked]':
        return 'This sign-in method is already linked to your account.';
      case 'no-such-provider':
      case '[firebase_auth/no-such-provider]':
        return 'This sign-in method is not linked to your account.';

      // Email actions (reset / verify)
      case 'expired-action-code':
      case '[firebase_auth/expired-action-code]':
        return 'This link has expired. Please request a new one.';
      case 'invalid-action-code':
      case '[firebase_auth/invalid-action-code]':
        return 'This link is invalid. It may have already been used.';
      case 'missing-action-code':
      case '[firebase_auth/missing-action-code]':
        return 'The action code is missing.';

      // Phone / MFA
      case 'invalid-phone-number':
      case '[firebase_auth/invalid-phone-number]':
        return 'The phone number is not valid.';
      case 'missing-phone-number':
      case '[firebase_auth/missing-phone-number]':
        return 'Please enter a phone number.';
      case 'quota-exceeded':
      case '[firebase_auth/quota-exceeded]':
        return 'SMS quota exceeded. Please try again later.';
      case 'captcha-check-failed':
      case '[firebase_auth/captcha-check-failed]':
        return 'reCAPTCHA verification failed. Please try again.';
      case 'invalid-verification-code':
      case '[firebase_auth/invalid-verification-code]':
        return 'The verification code is incorrect.';
      case 'invalid-verification-id':
      case '[firebase_auth/invalid-verification-id]':
        return 'The verification session is invalid. Please restart.';
      case 'session-expired':
      case '[firebase_auth/session-expired]':
        return 'The verification code has expired. Please resend it.';
      case 'missing-verification-code':
      case '[firebase_auth/missing-verification-code]':
        return 'Please enter the verification code.';

      // Network / Rate limiting
      case 'network-request-failed':
      case '[firebase_auth/network-request-failed]':
        return 'Network error. Check your connection and try again.';
      case 'too-many-requests':
      case '[firebase_auth/too-many-requests]':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'requires-recent-login':
      case '[firebase_auth/requires-recent-login]':
        return 'Please sign in again to complete this action.';
      case 'popup-blocked':
      case '[firebase_auth/popup-blocked]':
        return 'Sign-in popup was blocked. Allow popups and try again.';
      case 'popup-closed-by-user':
      case '[firebase_auth/popup-closed-by-user]':
        return 'Sign-in was cancelled.';

      // ─── Firestore ─────────────────────────────────────────────
      case 'permission-denied':
      case '[cloud_firestore/permission-denied]':
        return 'You do not have permission to perform this action.';
      case 'not-found':
      case '[cloud_firestore/not-found]':
        return 'The requested data was not found.';
      case 'already-exists':
      case '[cloud_firestore/already-exists]':
        return 'This data already exists.';
      case 'resource-exhausted':
      case '[cloud_firestore/resource-exhausted]':
        return 'Service limit reached. Please try again later.';
      case 'failed-precondition':
      case '[cloud_firestore/failed-precondition]':
        return 'Operation rejected due to current data state.';
      case 'aborted':
      case '[cloud_firestore/aborted]':
        return 'Operation aborted. Please try again.';
      case 'out-of-range':
      case '[cloud_firestore/out-of-range]':
        return 'Value is out of the allowed range.';
      case 'unimplemented':
      case '[cloud_firestore/unimplemented]':
        return 'This operation is not supported.';
      case 'internal':
      case '[cloud_firestore/internal]':
        return 'An internal server error occurred. Please try again.';
      case 'unavailable':
      case '[cloud_firestore/unavailable]':
        return 'Service is currently unavailable. Please try again.';
      case 'data-loss':
      case '[cloud_firestore/data-loss]':
        return 'Unrecoverable data loss or corruption.';
      case 'unauthenticated':
      case '[cloud_firestore/unauthenticated]':
        return 'Please sign in to continue.';
      case 'cancelled':
      case '[cloud_firestore/cancelled]':
        return 'The operation was cancelled.';
      case 'deadline-exceeded':
      case '[cloud_firestore/deadline-exceeded]':
        return 'The operation timed out. Please try again.';

      // ─── Firebase Storage ───────────────────────────────────────
      case '[firebase_storage/object-not-found]':
        return 'File not found.';
      case '[firebase_storage/unauthorized]':
        return 'You are not authorised to access this file.';
      case '[firebase_storage/cancelled]':
        return 'Upload was cancelled.';
      case '[firebase_storage/unknown]':
        return 'An unknown storage error occurred.';
      case '[firebase_storage/quota-exceeded]':
        return 'Storage quota exceeded.';
      case '[firebase_storage/unauthenticated]':
        return 'Please sign in to upload files.';
      case '[firebase_storage/retry-limit-exceeded]':
        return 'Upload failed after multiple retries. Check your connection.';
      case '[firebase_storage/invalid-checksum]':
        return 'File upload failed due to a checksum mismatch.';
      case '[firebase_storage/server-file-wrong-size]':
        return 'File size mismatch. Please try uploading again.';

      default:
        // Strip any remaining bracketed prefix e.g. "[firebase_auth/unknown]"
        final bracketMatch = RegExp(r'^\[.*?\]\s*').firstMatch(msg);
        if (bracketMatch != null) {
          final stripped = msg.substring(bracketMatch.end).trim();
          if (stripped.isNotEmpty) return stripped;
        }
        return msg.isNotEmpty
            ? msg
            : 'An unexpected error occurred. Please try again.';
    }
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

  static String? amountValidator({required int? value}) {
    if (value == null) {
      return "Please enter amount";
    }

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

  static getNameInitalsContainer({
    required String firstName,
    required String lastName,
    required AppColorScheme colorScheme,
    double size = 75.0,
  }) {
    final String firstNameInitial = firstName.isEmpty
        ? ''
        : firstName[0].toUpperCase();
    final String lastNameInitial = lastName.isEmpty
        ? ''
        : lastName[0].toUpperCase();
    return Container(
      alignment: Alignment.center,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.primary,
      ),
      child: AppTextHeading(
        text: "$firstNameInitial$lastNameInitial",
        fontSize: size / 2,
        color: colorScheme.outline,
      ),
    );
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
        backgroundColor = context.appColors.colorGreen;
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
        duration: const Duration(seconds: 4),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
    );
  }
}
