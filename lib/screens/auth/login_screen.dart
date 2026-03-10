import 'package:buraq_enterprise_admin/core/config/colors/app_colors.dart';
import 'package:buraq_enterprise_admin/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/screens/auth/login_controller.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text_field.dart';
import 'package:buraq_enterprise_admin/utils/widgets/bottom_sheet.dart/widget/otp_bottom_sheet_widget.dart';
import 'package:buraq_enterprise_admin/utils/widgets/buttons/app_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double spacing = screenHeight * 0.03;
    return GetBuilder<LoginController>(
      init: LoginController(),
      dispose: (_) => Get.delete<LoginController>(),
      builder: (controller) {
        return AppScrollableBody(
          centerContent: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.padding),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  _peopleIcon(context: context),
                  SizedBox(height: spacing),
                  AppTextHeading(text: "Admin Login"),
                  SizedBox(height: spacing),
                  _phoneNumberField(controller),
                  SizedBox(height: spacing),
                  _continueButton(controller, context),
                  SizedBox(height: spacing),
                  AppTextBody(text: "Admin-only access"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _peopleIcon({required BuildContext context}) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        color: colors.primary,
      ),
      child: const Icon(
        Icons.add_moderator_outlined,
        size: 40,
        color: AppColors.darkBg,
      ),
    );
  }

  AppTextField _phoneNumberField(LoginController controller) {
    return AppTextField(
      maxLength: 12,
      prefixIcon: const Icon(Icons.phone),
      type: TextFieldType.phoneNumber,
      controller: controller.phoneNumberController,
      hintText: "Enter Your Phone Number",
    );
  }

  Widget _continueButton(LoginController controller, BuildContext context) {
    return Obx(() {
      return AppFilledButton(
        // isEnable: !controller.loading.value,
        isLoading: controller.loading.value,
        buttonText: "Continue",
        onPressedCallBack: () {
          // print("Continue Button Pressed");
          controller.verifyPhoneNumber((verId) {
            if (!context.mounted) return;
            print("Verification ID: $verId");
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              isDismissible: true,
              builder: (BuildContext context) {
                return OtpBottomSheetWidget();
              },
            ).whenComplete(() {
              controller.clearOtp();
            });
          });
        },
      );
    });
  }
}


// import 'package:buraq_enterprise_admin/core/config/colors/app_colors.dart';
// import 'package:buraq_enterprise_admin/core/config/extensions/app_colors_extension.dart';
// import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
// import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
// import 'package:buraq_enterprise_admin/data/auth/auth_repository.dart';
// import 'package:buraq_enterprise_admin/screens/auth/login_controller.dart';
// import 'package:buraq_enterprise_admin/utils/widgets/app_scroll_body.dart';
// import 'package:buraq_enterprise_admin/utils/widgets/app_text.dart';
// import 'package:buraq_enterprise_admin/utils/widgets/app_text_field.dart';
// import 'package:buraq_enterprise_admin/utils/widgets/bottom_sheet.dart/widget/otp_bottom_sheet_widget.dart';
// import 'package:buraq_enterprise_admin/utils/widgets/buttons/app_filled_button.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final double spacing = screenHeight * 0.02;
//     final controller = Get.put<LoginController>(
//       LoginController(AuthRepository()),
//     );
//     return AppScrollableBody(
//       centerContent: true,
//       child: Form(
//         key: controller.formKey,
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: AppConstants.padding),
//           child: Column(
//             children: [
//               _peopleIcon(context: context),
//               SizedBox(height: spacing),
//               const AppTextHeading(text: "Admin Login"),
//               SizedBox(height: spacing),
//               _phoneNumberField(controller),
//               SizedBox(height: spacing),
//               _continueButton(controller, context),
//               SizedBox(height: spacing),
//               const AppTextBody(text: "Admin-only access"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   AppTextField _phoneNumberField(LoginController controller) {
//     return AppTextField(
//       maxLength: 12,
//       prefixIcon: const Icon(Icons.phone),
//       type: TextFieldType.phoneNumber,
//       controller: controller.phoneNumberController,
//       hintText: "Enter Your Phone Number",
//     );
//   }

//   Widget _peopleIcon({required BuildContext context}) {
//     final colors = context.appColors;
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(AppConstants.borderRadius),
//         color: colors.primary,
//       ),
//       child: const Icon(
//         Icons.add_moderator_outlined,
//         size: 40,
//         color: AppColors.darkBg,
//       ),
//     );
//   }

  // Widget _continueButton(LoginController controller, BuildContext context) {
  //   return Obx(() {
  //     return AppFilledButton(
  //       isEnable: !controller.loading.value && !controller.isBottomSheetShowing,
  //       isLoading: controller.loading.value,
  //       onPressedCallBack: () => controller.verifyPhoneNumber((verId) {
  //         if (!context.mounted || controller.isBottomSheetShowing) {
  //           return;
  //         }
          
  //         showModalBottomSheet(
  //           context: context,
  //           isScrollControlled: true,
  //           isDismissible: true,
  //           enableDrag: true,
  //           builder: (context) => OtpBottomSheetWidget(loginController: controller),
  //         ).whenComplete(() {
  //           // Reset flag when bottom sheet is closed
  //           controller.setBottomSheetClosed();
  //         });
  //       }),
  //       buttonText: "Continue",
  //     );
  //   });
  // }
// }
