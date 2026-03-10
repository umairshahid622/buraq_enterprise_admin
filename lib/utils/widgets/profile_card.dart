
import 'package:buraq_enterprise_admin/core/config/colors/app_color_scheme.dart';
import 'package:buraq_enterprise_admin/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final Widget cardWidget;
  const ProfileCard({super.key, required this.cardWidget});

  @override
  Widget build(BuildContext context) {
    final AppColorScheme appColorScheme = context.appColors;
    return Container(
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
    );
  }
}
