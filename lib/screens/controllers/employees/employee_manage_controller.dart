import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/data/screens/employee_repository.dart';
import 'package:buraq_enterprise_admin/models/employee_model.dart';
import 'package:buraq_enterprise_admin/screens/controllers/splash/splash_screen_controller.dart';
import 'package:buraq_enterprise_admin/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeManageController extends GetxController {
  EmployeeManageController({required this.employeeId});

  final String employeeId;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final EmployeeRepository _employeeRepository = EmployeeRepository();
  final SplashController splashController = Get.find<SplashController>();

  final RxString status = Status.active.name.obs;
  final ValueNotifier<String?> statusNotifier = ValueNotifier(null);
  final RxBool isSaving = false.obs;

  Employee? get employee {
    try {
      return splashController.employees.firstWhere(
        (element) => element.empId == employeeId,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _prefill();
  }

  void _prefill() {
    final emp = employee;
    if (emp == null) return;
    firstNameController.text = emp.firstName;
    lastNameController.text = emp.lastName;
    phoneController.text = emp.phone;
    status.value = emp.status.isEmpty ? Status.active.name : emp.status;
    statusNotifier.value = status.value;
  }

  void setStatus(String? value) {
    if (value == null) return;
    status.value = value;
    statusNotifier.value = value;
    update();
  }

  Future<void> saveChanges() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isSaving.value = true;
    update();
    try {
      await _employeeRepository.updateEmployee(
        employeeId: employeeId,
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        status: status.value,
      );
      AppUtils.showToast(
        label: "Employee updated successfully",
        vairant: ToastVariants.success,
      );
    } catch (e) {
      AppUtils.showToast(
        label: AppUtils.getFirebaseErrorMessage(message: e.toString()),
        vairant: ToastVariants.error,
      );
    } finally {
      isSaving.value = false;
      update();
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    statusNotifier.dispose();
    super.dispose();
  }
}
