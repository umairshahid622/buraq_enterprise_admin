
import 'package:buraq_enterprise_admin/data/screens/employee_repository.dart';
import 'package:buraq_enterprise_admin/models/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeController extends GetxController {

  EmployeeController();


  final EmployeeRepository _employeeRepository = EmployeeRepository();
  Stream<int> getActiveProjectsCountStream(String employeeId) {
    return _employeeRepository.activeProjectsCountStream(employeeId);
  }


  final TextEditingController searchController = TextEditingController();

  final RxString searchQuery = ''.obs;

  final RxList<Employee> employees = <Employee>[].obs;

  final RxBool isLoading = true.obs;

  final RxString errorMessage = ''.obs;


  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_onSearchChanged);

  }

  @override
  void onReady() {   
    super.onReady();
    employees.bindStream(_employeeRepository.fetchEmployees());

    ever(employees, (_) {
      if (isLoading.value) {
        isLoading.value = false;
      }
      update();
    });

  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
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
