import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/data/screens/project_repository.dart';
import 'package:buraq_enterprise_admin/utils/app_util.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AddProjectScreenController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController projectDiscriptionController =
      TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController totalBudgetAllocatedController =
      TextEditingController();

  final ProjectRepository _projectRepository = ProjectRepository();

  final isLoading = false.obs;

  final List<String> selectedEmployeeIds = [];

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


  Future<void> createProject({required BuildContext context}) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    isLoading.value = true;
    try {     
      await _projectRepository.addProject(
        projectName: projectNameController.text.trim(),
        projectDiscription: projectDiscriptionController.text.trim(),
        startDate: DateTime.parse(startDateController.text.trim()),
        endDate: DateTime.parse(endDateController.text.trim()),        
        totalBudgetAllocated: int.parse(totalBudgetAllocatedController.text.trim()),
        employeeIds: selectedEmployeeIds
      );
      if (context.mounted) {
        context.pop();
      }
       AppUtils.showToast(
        label: AppUtils.getFirebaseErrorMessage(message: "Project Added Sucessfully"),
        vairant: ToastVariants.success,
      );
    } catch (e) {
      print(e.toString());

      
      AppUtils.showToast(
        label: AppUtils.getFirebaseErrorMessage(message: e.toString()),
        vairant: ToastVariants.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    projectNameController.dispose();
    projectDiscriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    totalBudgetAllocatedController.dispose();
  }
}
