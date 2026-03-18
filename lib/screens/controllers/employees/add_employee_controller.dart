import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/data/screens/employee_repository.dart';
import 'package:buraq_enterprise_admin/screens/controllers/employees/employee_controller.dart';
import 'package:buraq_enterprise_admin/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AddEmployeeController extends GetxController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController allocateAmountController =
      TextEditingController();
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

  void createEmployee({required BuildContext context}) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      await employeeRepository.addEmployee(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),
        amount: int.parse(allocateAmountController.text.trim()),
      );
      if (context.mounted) {
        context.pop();
      }
      AppUtils.showToast(
        label: "Employee Added Sucessfully",
        vairant: ToastVariants.success,
      );
    } catch (e) {
      print("Add Employeee ERROR: $e");
      AppUtils.showToast(
        label: AppUtils.getFirebaseErrorMessage(message: e.toString()),
        vairant: ToastVariants.error,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
