import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/screens/auth/login_controller.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text_field.dart';
import 'package:buraq_enterprise_admin/utils/widgets/buttons/app_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpBottomSheetWidget extends StatelessWidget {
  const OtpBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.find<LoginController>();
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConstants.borderRadius),
          topRight: Radius.circular(AppConstants.borderRadius),
        ),
      ),
      padding: EdgeInsets.all(AppConstants.padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppTextHeading(text: "Verify OTP"),
          const SizedBox(height: 10),
          const AppTextBody(text: "Enter the 6-digit code sent to your phone"),
          const SizedBox(height: 20),
          otpForm(controller),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Form otpForm(LoginController controller) {
    return Form(
      key: controller.otpFormKey,
      child: Column(
        children: [
          Row(
            children: controller.otpControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final otpController = entry.value;
              final isLast = index == controller.otpLength - 1;
              final isFirst = index == 0;
              return Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AppTextField(
                    type: TextFieldType.otp,
                    controller: otpController,
                    focusNode: controller.otpFocusNodes[index],
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    autoFocus: index == 0,
                    onTextChangeCallBack: (value) {
                      if (value.isNotEmpty && value.length == 1) {
                        if (!isLast) {
                          controller.otpFocusNodes[index + 1].requestFocus();
                        } else {
                          controller.otpFocusNodes[index].unfocus();
                        }
                      } else if (value.isEmpty) {
                        if (!isFirst) {
                          controller.otpFocusNodes[index - 1].requestFocus();
                        }
                      }
                    },
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          Obx(() {
            return AppFilledButton(
              isLoading: controller.otpLoading.value,
              isEnable: !controller.otpLoading.value,
              buttonText: "Verify Now",
              onPressedCallBack: () async {
                await controller.verifyOtp();
              },
            );
          }),
        ],
      ),
    );
  }
}

// import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
// import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
// import 'package:buraq_enterprise_admin/screens/auth/login_controller.dart';
// import 'package:buraq_enterprise_admin/utils/widgets/app_text.dart';
// import 'package:buraq_enterprise_admin/utils/widgets/app_text_field.dart';
// import 'package:buraq_enterprise_admin/utils/widgets/buttons/app_filled_button.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class OtpBottomSheetWidget extends StatefulWidget {
//   const OtpBottomSheetWidget({super.key, required this.loginController});
//   final LoginController loginController;

//   @override
//   State<OtpBottomSheetWidget> createState() => _OtpBottomSheetWidgetState();
// }

// class _OtpBottomSheetWidgetState extends State<OtpBottomSheetWidget> {
//   // Create a unique form key for this bottom sheet instance
//   final _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     // Clear OTP fields when bottom sheet opens
//     _clearOtpFields();
//     // Focus on first field
//     if (widget.loginController.otpFocusNodes.isNotEmpty) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         widget.loginController.otpFocusNodes[0].requestFocus();
//       });
//     }
//   }

//   void _clearOtpFields() {
//     for (var controller in widget.loginController.otpControllers) {
//       controller.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//         left: AppConstants.padding,
//         right: AppConstants.padding,
//         top: AppConstants.padding,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//           const AppTextHeading(text: "Verify OTP"),
//           const SizedBox(height: 10),
//           const AppTextBody(text: "Enter the 6-digit code sent to your phone"),
//           const SizedBox(height: 20),
//           otpFields(widget.loginController),

//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   Form otpFields(LoginController controller) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: controller.otpControllers.asMap().entries.map((entry) {
//               final index = entry.key;
//               final otpController = entry.value;
//               final isLast = index == controller.otpLength - 1;
//               final isFirst = index == 0;

//               return Flexible(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 4),
//                   child: AppTextField(
//                     type: TextFieldType.otp,
//                     controller: otpController,
//                     focusNode: controller.otpFocusNodes[index],
//                     textAlign: TextAlign.center,
//                     maxLength: 1,
//                     autoFocus: index == 0,
//                     onTextChangeCallBack: (value) async {
//                       if (value.isNotEmpty && value.length == 1) {
//                         if (!isLast) {
//                           controller.otpFocusNodes[index + 1].requestFocus();
//                         } else {
//                           controller.otpFocusNodes[index].unfocus();
//                           await controller.verifyOtp(_formKey);
//                         }
//                       } else if (value.isEmpty) {
//                         if (!isFirst) {
//                           controller.otpFocusNodes[index - 1].requestFocus();
//                         }
//                       }
//                     },
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//           const SizedBox(height: 20),
//           Obx(() {
//             return AppFilledButton(
//               isEnable: !controller.otpLoading.value && controller.completeOtp.length == controller.otpLength,
//               isLoading: controller.otpLoading.value,
//               onPressedCallBack: () async {
//                 FocusManager.instance.primaryFocus?.unfocus();
//                 await controller.verifyOtp(_formKey);
//               },
//               buttonText: "Verify Now",
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }

// // import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
// // import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';

// // import 'package:buraq_enterprise_admin/screens/auth/login_controller.dart';
// // import 'package:buraq_enterprise_admin/utils/widgets/app_text.dart';
// // import 'package:buraq_enterprise_admin/utils/widgets/app_text_field.dart';
// // import 'package:buraq_enterprise_admin/utils/widgets/bottom_sheet.dart/controller/otp_bottom_sheet_controller.dart';
// // import 'package:buraq_enterprise_admin/utils/widgets/buttons/app_filled_button.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';

// // class OtpBottomSheetWidget extends StatelessWidget {
// //   const OtpBottomSheetWidget({super.key, required this.loginController});
// //   final LoginController loginController;
// //   @override
// //   Widget build(BuildContext context) {
// //     if (Get.isRegistered<OtpBottomSheetController>()) {
// //       Get.delete<OtpBottomSheetController>();
// //     }
// //     final controller = Get.put<OtpBottomSheetController>(
// //       OtpBottomSheetController(loginController: loginController),
// //     );
// //     return Padding(
// //       padding: EdgeInsets.only(
// //         bottom: MediaQuery.of(context).viewInsets.bottom,
// //         left: AppConstants.padding,
// //         right: AppConstants.padding,
// //         top: AppConstants.padding,
// //       ),
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         children: [
// //           const AppTextHeading(text: "Verify OTP"),
// //           const SizedBox(height: 10),
// //           const AppTextBody(text: "Enter the 6-digit code sent to your phone"),
// //           const SizedBox(height: 20),
// //           otpFields(controller),

// //           const SizedBox(height: 20),
// //         ],
// //       ),
// //     );
// //   }

// //   Form otpFields(OtpBottomSheetController controller) {
// //     return Form(
// //       key: controller.formKey,
// //       child: Column(
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: controller.otpControllers.asMap().entries.map((entry) {
// //               final index = entry.key;
// //               final otpController = entry.value;
// //               final isLast = index == controller.otpLength - 1;
// //               final isFirst = index == 0;

// //               return Flexible(
// //                 child: Padding(
// //                   padding: EdgeInsets.symmetric(horizontal: 4),
// //                   child: AppTextField(
// //                     type: TextFieldType.otp,
// //                     controller: otpController,
// //                     focusNode: controller.otpFocusNodes[index],
// //                     textAlign: TextAlign.center,
// //                     maxLength: 1,
// //                     autoFocus: index == 0,
// //                     onTextChangeCallBack: (value) async {
// //                       if (value.isNotEmpty && value.length == 1) {
// //                         if (!isLast) {
// //                           controller.otpFocusNodes[index + 1].requestFocus();
// //                         } else {
// //                           controller.otpFocusNodes[index].unfocus();
// //                           await controller.verifyOtp();
// //                         }
// //                       } else if (value.isEmpty) {
// //                         if (!isFirst) {
// //                           controller.otpFocusNodes[index - 1].requestFocus();
// //                         }
// //                       }
// //                     },
// //                   ),
// //                 ),
// //               );
// //             }).toList(),
// //           ),
// //           const SizedBox(height: 20),

// //           Obx(() {
// //             return AppFilledButton(
// //               isEnable:
// //                   !controller.otpLoading.value &&
// //                   controller.completeOtp.length == controller.otpLength,
// //               isLoading: controller.otpLoading.value,
// //               onPressedCallBack: () async{
// //                 FocusManager.instance.primaryFocus?.unfocus();
// //                 await controller.verifyOtp();
// //               },
// //               buttonText: "Verify Now",
// //             );
// //           }),
// //         ],
// //       ),
// //     );
// //   }
// // }
