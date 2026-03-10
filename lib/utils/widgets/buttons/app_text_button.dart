import 'package:buraq_enterprise_admin/core/config/colors/app_color_scheme.dart';
import 'package:buraq_enterprise_admin/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextButton extends StatelessWidget {
  final void Function()? onPressedCallBack;
  final String buttonText;
  final double? fontSize;
  const AppTextButton({
    super.key,
    this.onPressedCallBack,
    required this.buttonText,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final AppColorScheme appColorScheme = context.appColors;
    return TextButton(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(
          GoogleFonts.inter(
            color: appColorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
        foregroundColor: WidgetStatePropertyAll(appColorScheme.primary),
        overlayColor: WidgetStatePropertyAll(
          appColorScheme.primary.withValues(alpha: .08),
        ),
      ),
      onPressed: onPressedCallBack,
      child: AppTextBody(
        text: buttonText,
        color: appColorScheme.primary,
        fontSize: fontSize ?? 14,
      ),
    );
  }
}
