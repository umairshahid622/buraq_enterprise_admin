import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/data/screens/employee_repository.dart';
import 'package:buraq_enterprise_admin/models/employee_model.dart';
import 'package:buraq_enterprise_admin/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeController extends GetxController {
  final EmployeeRepository _employeeRepository;

  EmployeeController(this._employeeRepository);

  // ---------------------------
  // Controllers
  // ---------------------------
  final TextEditingController searchController = TextEditingController();

  // ---------------------------
  // Reactive State
  // ---------------------------
  final RxString searchQuery = ''.obs;

  final RxList<Employee> employees = <Employee>[].obs;

  final RxBool isLoading = false.obs;

  final RxString errorMessage = ''.obs;

  // ---------------------------
  // Lifecycle
  // ---------------------------
  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_onSearchChanged);

  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // ---------------------------
  // Fetch Employees
  // ---------------------------
  Future<List<Employee>> fetchEmployees() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _employeeRepository.fetchEmployees();

      employees.assignAll(result);

      return result;
    } catch (e) {
      final String msg = AppUtils.getFirebaseErrorMessage(
        message: e.toString(),
      );

      print("Errror While Fetching the EMployee: $e");

      AppUtils.showToast(
        label: msg,
        vairant: ToastVariants.error,
      );

      errorMessage.value = msg;

      return [];
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------
  // Search Handling
  // ---------------------------
  void _onSearchChanged() {
    searchQuery.value = searchController.text.trim();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    searchController.text = query;
  }

  // ---------------------------
  // Filtered List (Computed)
  // ---------------------------
  List<Employee> get filteredEmployees {
    if (searchQuery.value.isEmpty) {
      return employees;
    }

    final query = searchQuery.value.toLowerCase();

    return employees.where((e) {
      return e.firstName.toLowerCase().contains(query) ||
          e.empId.toLowerCase().contains(query);
    }).toList();
  }
}
