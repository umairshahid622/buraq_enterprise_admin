import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AddProjectScreenController extends GetxController {
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController projectDiscriptionController =
      TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController totalBudgetAllocatedController = TextEditingController();
  


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
