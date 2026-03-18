import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/data/auth/auth_repository.dart';
import 'package:buraq_enterprise_admin/screens/controllers/common/user_controller.dart';
import 'package:buraq_enterprise_admin/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final phoneNumberController = TextEditingController();
  final RxBool loading = false.obs;
  final RxBool otpLoading = false.obs;

  String? _verificationId;
  String? get verificationId => _verificationId;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  int otpLength = 6;

  late final List<TextEditingController> otpControllers = List.generate(
    otpLength,
    (index) => TextEditingController(),
  );

  late final List<FocusNode> otpFocusNodes = List.generate(
    otpLength,
    (index) => FocusNode(),
  );

  String get completeOtp => otpControllers.map((e) => e.text).join();

  Future<void> verifyPhoneNumber(Function(String verId)? onCodeSent) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    loading.value = true;
    try {
      await AuthRepository().verifyPhoneNumber(
        phoneNumber: phoneNumberController.text,
        onCodeSent: (verId) {
          _verificationId = verId;
          loading.value = false;
          onCodeSent?.call(verId);
        },
        onError: (error) {
          loading.value = false;
        },
      );
    } catch (e) {
      String error = AppUtils.getFirebaseErrorMessage(message: e.toString());
      AppUtils.showToast(
        label: error,
        vairant: ToastVariants.error,
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    if (!otpFormKey.currentState!.validate()) {
      return;
    }

    if (verificationId == null || completeOtp.length != otpLength) {
      return;
    }
    otpLoading.value = true;
    try {
      await AuthRepository().signInWithOtp(verificationId!, completeOtp);

      final userController = Get.find<UserController>();
      await userController.fetchUserProfile();
    } catch (e) {
      String error = AppUtils.getFirebaseErrorMessage(message: e.toString());
      AppUtils.showToast(
        label: error,
        vairant: ToastVariants.error,
      );
    } finally {
      otpLoading.value = false;
    }
  }

  void clearOtp() {
    for (var controller in otpControllers) {
      controller.clear();
    }
    for (var node in otpFocusNodes) {
      node.unfocus();
    }
  }

  @override
  void onClose() {
    phoneNumberController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}



// import 'package:buraq_enterprise_admin/core/config/colors/app_colors.dart';
// import 'package:buraq_enterprise_admin/data/auth/auth_repository.dart';
// import 'package:buraq_enterprise_admin/screens/controllers/common/user_controller.dart';
// import 'package:buraq_enterprise_admin/utils/app_util.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';

// class LoginController extends GetxController {
//   final AuthRepository _authRepo;

//   LoginController(this._authRepo);

//   final formKey = GlobalKey<FormState>();

//   late final List<TextEditingController> otpControllers = List.generate(
//     otpLength,
//     (index) => TextEditingController(),
//   );

//   late final List<FocusNode> otpFocusNodes = List.generate(
//     otpLength,
//     (index) => FocusNode(),
//   );

//   String get completeOtp => otpControllers.map((e) => e.text).join();

//   final RxBool otpLoading = false.obs;
//   final int otpLength = 6;

//   final phoneNumberController = TextEditingController();
//   final RxBool loading = false.obs;
//   bool _isBottomSheetShowing = false;

//   String? _verificationId;
//   String? get verificationId => _verificationId;

//   Future<void> verifyPhoneNumber(Function(String verId)? onCodeSent) async {
//     if (!formKey.currentState!.validate()) {
//       return;
//     }

//     loading.value = true;
//     try {
//       await _authRepo.verifyPhoneNumber(
//         phoneNumber: phoneNumberController.text,
//         onCodeSent: (verId) {
//           _verificationId = verId;
//           loading.value = false;
//           _isBottomSheetShowing = true;
//           onCodeSent?.call(verId);
//         },
//         onError: (error) {
//           loading.value = false;
//           AppUtils.showToast(
//             context: Get.context!,
//             label: error,
//             backGroundColor: AppColors.error,
//           );
//         },
//       );
//     } catch (e) {
//       loading.value = false;
//       AppUtils.showToast(
//         context: Get.context!,
//         label: "Something went wrong",
//         backGroundColor: AppColors.error,
//       );
//     }
//   }

//   Future<void> verifyOtp([GlobalKey<FormState>? formKey]) async {
//     if (formKey != null && !formKey.currentState!.validate()) {
//       return;
//     }
//     otpLoading.value = true;
//     try {
//       await _authRepo.signInWithOtp(verificationId!, completeOtp);

//       final userController = Get.find<UserController>();
//       await userController.fetchUserProfile();
//     } catch (e) {
//         print(e);
      
//       rethrow;
//     } finally {
//       otpLoading.value = false;
//     }
//   }

//   void setBottomSheetClosed() {
//     _isBottomSheetShowing = false;
//   }

//   bool get isBottomSheetShowing => _isBottomSheetShowing;

//   Future<void> resendOtp() async {}
// }
