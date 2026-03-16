import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AddProjectScreenController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController projectDiscriptionController =
      TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController totalBudgetAllocatedController = TextEditingController();
  

  final List<String> selectedEmployeeIds = [];
  


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isEmployeeSelected(String empId) {
    return selectedEmployeeIds.contains(empId);
  }

  void toggleEmployee(String empId) {
    if (selectedEmployeeIds.contains(empId)) {
      selectedEmployeeIds.remove(empId);
    } else {
      selectedEmployeeIds.add(empId);
    }
    update();
  }

  void createProject({required BuildContext context}) {
    if (formKey.currentState!.validate()) {    
      return;
    }

  }
}
