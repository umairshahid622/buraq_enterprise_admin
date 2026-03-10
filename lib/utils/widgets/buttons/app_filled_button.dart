import 'package:buraq_enterprise_admin/core/config/colors/app_color_scheme.dart';
import 'package:buraq_enterprise_admin/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_spiner.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AppFilledButton extends StatelessWidget {
  final void Function()? onPressedCallBack;
  final String buttonText;
  final bool? isEnable;
  final bool? isLoading;
  final double? buttonHeight;
  final double? buttonWidth;
  final double? fontSize;

  const AppFilledButton({
    super.key,
    required this.onPressedCallBack,
    required this.buttonText,
    this.isEnable,
    this.isLoading = false,
    this.buttonHeight,
    this.buttonWidth,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final AppColorScheme appColors = context.appColors;
    return SizedBox(
        width: buttonWidth ?? double.infinity,
        height: buttonHeight ?? 48,
        child: FilledButton(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
            ),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return appColors.primary.withValues(alpha: .35);
              }
              return appColors.primary;
            }),
          ),
          onPressed: (isLoading ?? false) || !(isEnable ?? true) ? null : onPressedCallBack,
          child: isLoading ?? false
              ? const SizedBox(height: 22, width: 22, child: AppSpiner())
              : AppTextBody(
                  text: buttonText,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize ?? 16,
                  color: appColors.colorButtonText,
                  textAlign: TextAlign.center,
                ),
        ),
      );
  }
}
