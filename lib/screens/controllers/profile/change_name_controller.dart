import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buraq_enterprise_admin/screens/controllers/common/user_controller.dart';

class ChangeNameController extends GetxController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;



  Future<void> saveChanges() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    isLoading.value = true;
    try {
      await Get.find<UserController>().updateUser(firstName: firstNameController.text.trim(), lastName: lastNameController.text.trim());
    } catch (e) {
      AppUtils.showToast(label: e.toString(), vairant: ToastVariants.error);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    final userController = Get.find<UserController>();
    firstNameController.text = userController.user?.firstName ?? '';
    lastNameController.text = userController.user?.lastName ?? '';
  }
  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.onClose();
  }
}