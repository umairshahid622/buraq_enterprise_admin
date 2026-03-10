import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class EmployeeScreenController extends GetxController {
  TextEditingController employeeSearchController = TextEditingController();

  @override
  void onClose() {
    super.onClose();
    employeeSearchController.dispose();
  }
}
