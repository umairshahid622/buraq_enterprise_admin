import 'package:buraq_enterprise_admin/core/config/colors/app_color_scheme.dart';
import 'package:buraq_enterprise_admin/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class AppCardWidget extends StatelessWidget {
  final Widget cardWidget;
  final void Function()? onTap;
  const AppCardWidget({super.key, required this.cardWidget, this.onTap});

  @override
  Widget build(BuildContext context) {
    final AppColorScheme appColorScheme = context.appColors;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppConstants.padding * 1.5,
          horizontal: AppConstants.padding,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(
            color: appColorScheme.outline,
            width: AppConstants.borderStroke,
          ),
        ),
        child: cardWidget,
      ),
    );
  }
}
