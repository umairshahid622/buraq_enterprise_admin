import 'package:buraq_enterprise_admin/core/config/colors/app_color_scheme.dart';
import 'package:buraq_enterprise_admin/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_admin/data/auth/auth_repository.dart';
import 'package:buraq_enterprise_admin/screens/controllers/common/user_controller.dart';
import 'package:buraq_enterprise_admin/screens/controllers/profile/profile_widget_controller.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text.dart';
import 'package:buraq_enterprise_admin/utils/widgets/buttons/app_filled_button.dart';
import 'package:buraq_enterprise_admin/utils/widgets/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ProfileScreenWidget extends StatelessWidget {
  const ProfileScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final profileWidgetController = Get.put(ProfileWidgetController(Get.put(AuthRepository())));
    final AppColorScheme appColorScheme = context.appColors;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double spacing = screenHeight * 0.05;
    final userController = Get.find<UserController>();
    return AppScrollableBody(
      child: Obx(() {
        final user = userController.user;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileCard(
              cardWidget: getTopCard(
                appColorScheme: appColorScheme,
                firstName: user?.firstName ?? '',
                lastName: user?.lastName ?? '',
                phoneNumber: user?.phoneNumber ?? '',
                role: user?.role ?? '',
              ),
            ),
            SizedBox(height: spacing / 2),
            AppTextHeading(text: "Account", fontSize: 22),
            SizedBox(height: spacing / 4),
            ProfileCard(cardWidget: getChangeNameCard(context)),
            SizedBox(height: spacing),
            _logoutButton(profileWidgetController),
          ],
        );
      }),
    );
  }

  Widget getChangeNameCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/profile/change-name');
      },
      child: Row(
        children: [
          Icon(
            Icons.account_circle_outlined,
            size: 25,
            color: context.appColors.secondary,
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextHeading(text: "Change Name", fontSize: 18),
              AppTextBody(
                text: "Change Your First and Last Name",
                fontSize: 14,
                color: context.appColors.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getTopCard({
    required AppColorScheme appColorScheme,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String role,
  }) {
    if (firstName.isEmpty && lastName.isEmpty) {
      return SizedBox.shrink();
    }
    final firstNameInitial = firstName[0];
    final lastNameInitial = lastName[0];

    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: appColorScheme.primary,
          ),
          child: AppTextHeading(
            text: "$firstNameInitial$lastNameInitial",
            fontSize: 32,
            color: appColorScheme.outline,
          ),
        ),
        SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextHeading(text: '$firstName $lastName', fontSize: 22),
            SizedBox(height: 5),
            AppTextBody(
              text: phoneNumber,
              color: appColorScheme.secondary,
              fontSize: 14,
            ),
            AppTextBody(
              text: "Role: $role",
              color: appColorScheme.secondary,
              fontSize: 14,
            ),
          ],
        ),
      ],
    );
  }

  Widget _logoutButton(ProfileWidgetController profileWidgetController) {
    return Obx(() {
      return AppFilledButton(
        isLoading: profileWidgetController.isLoading.value,
        isEnable: !profileWidgetController.isLoading.value,
        onPressedCallBack: () {
          profileWidgetController.logout();
        },
        buttonText: "Logout",
      );
    });
  }
}
