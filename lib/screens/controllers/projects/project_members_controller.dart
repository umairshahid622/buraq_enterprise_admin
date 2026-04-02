import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/data/screens/project_repository.dart';
import 'package:buraq_enterprise_admin/models/employee_model.dart';
import 'package:buraq_enterprise_admin/models/project_member_model.dart';
import 'package:buraq_enterprise_admin/models/project_model.dart';
import 'package:buraq_enterprise_admin/screens/controllers/splash/splash_screen_controller.dart';
import 'package:buraq_enterprise_admin/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectMembersController extends GetxController {
  ProjectMembersController({required this.projectId});

  final String projectId;

  final ProjectRepository _projectRepository = ProjectRepository();
  final SplashController splashController = Get.find<SplashController>();

  final RxList<ProjectMember> members = <ProjectMember>[].obs;
  final RxBool isMembersLoading = true.obs;
  final RxBool isActionLoading = false.obs;

  final Map<String, TextEditingController> allocationControllers = {};
  final Map<String, int> _lastAllocationValues = {};
  final TextEditingController projectBudgetController =
      TextEditingController();

  final RxList<String> selectedEmployeeIds = <String>[].obs;

  bool isEmployeeSelected(String empId) {
    return selectedEmployeeIds.contains(empId);
  }

  void toggleEmployee(String empId) {
    if (selectedEmployeeIds.contains(empId)) {
      selectedEmployeeIds.remove(empId);
    } else {
      selectedEmployeeIds.add(empId);
    }
  }
  @override
  void onReady() {
    super.onReady();
    members.bindStream(_projectRepository.fetchProjectMembers(projectId));
    ever(members, (_) {
      isMembersLoading.value = false;
      _syncControllers();
      update();
    });
  }

  ProjectModel? get project {
    try {
      return splashController.projects.firstWhere(
        (element) => element.projectId == projectId,
      );
    } catch (_) {
      return null;
    }
  }

  Employee? getEmployee(String employeeId) {
    try {
      return splashController.employees.firstWhere(
        (element) => element.empId == employeeId,
      );
    } catch (_) {
      return null;
    }
  }

  List<Employee> get availableEmployees {
    final assigned = {
      ...members.map((e) => e.employeeId),
      ...(project?.employeeIds ?? []),
    };
    return splashController.employees
        .where((e) => !assigned.contains(e.empId))
        .toList();
  }

  TextEditingController allocationControllerFor(String employeeId) {
    return allocationControllers.putIfAbsent(
      employeeId,
      () => TextEditingController(),
    );
  }

  Future<void> addMember() async {
    if (selectedEmployeeIds.isEmpty) {
      AppUtils.showToast(
        label: "Select at least one employee to add",
        vairant: ToastVariants.error,
      );
      return;
    }

    isActionLoading.value = true;
    update();
    try {
      await _projectRepository.addProjectMembers(
        projectId: projectId,
        employeeIds: selectedEmployeeIds.toList(),
      );
      selectedEmployeeIds.clear();
      AppUtils.showToast(
        label: "Employees added to project",
        vairant: ToastVariants.success,
      );
    } catch (e) {
      AppUtils.showToast(
        label: AppUtils.getFirebaseErrorMessage(message: e.toString()),
        vairant: ToastVariants.error,
      );
    } finally {
      isActionLoading.value = false;
      update();
    }
  }

  Future<void> removeMember(String employeeId) async {
    isActionLoading.value = true;
    update();
    try {
      await _projectRepository.removeProjectMember(
        projectId: projectId,
        employeeId: employeeId,
      );
      allocationControllers[employeeId]?.dispose();
      allocationControllers.remove(employeeId);
      _lastAllocationValues.remove(employeeId);
      AppUtils.showToast(
        label: "Employee removed from project",
        vairant: ToastVariants.success,
      );
    } catch (e) {
      print(e);
      AppUtils.showToast(
        label: AppUtils.getFirebaseErrorMessage(message: e.toString()),
        vairant: ToastVariants.error,
      );
    } finally {
      isActionLoading.value = false;
      update();
    }
  }

  Future<void> updateAllocation(String employeeId) async {
    final controller = allocationControllers[employeeId];
    if (controller == null) return;
    final int? amount = int.tryParse(controller.text.trim());
    if (amount == null) {
      AppUtils.showToast(
        label: "Enter a valid amount",
        vairant: ToastVariants.error,
      );
      return;
    }
    if (amount < 0) {
      AppUtils.showToast(
        label: "Amount cannot be negative",
        vairant: ToastVariants.error,
      );
      return;
    }

    isActionLoading.value = true;
    update();
    try {
      await _projectRepository.updateMemberAllocation(
        projectId: projectId,
        employeeId: employeeId,
        newAmount: amount,
      );
      AppUtils.showToast(
        label: "Allocation updated",
        vairant: ToastVariants.success,
      );
    } catch (e) {
      AppUtils.showToast(
        label: AppUtils.getFirebaseErrorMessage(message: e.toString()),
        vairant: ToastVariants.error,
      );
    } finally {
      isActionLoading.value = false;
      update();
    }
  }

  Future<void> updateProjectBudget() async {
    final int? amount = int.tryParse(projectBudgetController.text.trim());
    if (amount == null) {
      AppUtils.showToast(
        label: "Enter a valid amount",
        vairant: ToastVariants.error,
      );
      return;
    }
    if (amount < 0) {
      AppUtils.showToast(
        label: "Amount cannot be negative",
        vairant: ToastVariants.error,
      );
      return;
    }

    isActionLoading.value = true;
    update();
    try {
      await _projectRepository.updateProjectBudget(
        projectId: projectId,
        newTotalBudget: amount,
      );
      AppUtils.showToast(
        label: "Project budget updated",
        vairant: ToastVariants.success,
      );
    } catch (e) {
      AppUtils.showToast(
        label: AppUtils.getFirebaseErrorMessage(message: e.toString()),
        vairant: ToastVariants.error,
      );
    } finally {
      isActionLoading.value = false;
      update();
    }
  }

  void _syncControllers() {
    final projectModel = project;
    if (projectModel != null) {
      final int? currentBudget =
          int.tryParse(projectBudgetController.text.trim());
      if (currentBudget == null ||
          currentBudget == projectModel.totalBudgetAllocated) {
        projectBudgetController.text =
            projectModel.totalBudgetAllocated.toString();
      }
    }

    for (final member in members) {
      final controller = allocationControllerFor(member.employeeId);
      final int? currentValue = int.tryParse(controller.text.trim());
      final int? lastValue = _lastAllocationValues[member.employeeId];
      if (currentValue == null || currentValue == lastValue) {
        controller.text = member.allocatedAmount.toString();
      }
      _lastAllocationValues[member.employeeId] = member.allocatedAmount;
    }
  }

  @override
  void dispose() {
    for (final controller in allocationControllers.values) {
      controller.dispose();
    }
    allocationControllers.clear();
    projectBudgetController.dispose();
    super.dispose();
  }
}
