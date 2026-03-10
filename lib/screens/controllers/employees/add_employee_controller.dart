import 'package:buraq_enterprise_admin/data/screens/employee_repository.dart';
import 'package:buraq_enterprise_admin/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEmployeeController extends GetxController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final EmployeeRepository employeeRepository = EmployeeRepository();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    super.onClose();
  }

  void createEmployee() async {
    isLoading.value = true;

    try {
      await employeeRepository.addEmployee(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),
      );
      AppUtils.showToast(
        context: Get.overlayContext!,
        label: "Employee Added Sucessfully",
        vairant: "success",
      );
    } catch (e) {
      AppUtils.showToast(
        context: Get.overlayContext!,
        label: e.toString(),
        vairant: "error",
      );
    } finally {
      isLoading.value = false;
    }
  }
}
