
import 'package:buraq_enterprise_admin/models/employee_model.dart';
import 'package:buraq_enterprise_admin/screens/controllers/splash/splash_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeController extends GetxController {

  EmployeeController();

  

  final TextEditingController searchController = TextEditingController();

  final RxString searchQuery = ''.obs;


  final RxString errorMessage = ''.obs;

  late final SplashController splashController;

  @override
  void onInit() {
    super.onInit();
    splashController = Get.find<SplashController>();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onReady() {   
    super.onReady();
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
      // return employees;
      return splashController.employees;
    }

    final query = searchQuery.value.toLowerCase();

    // return employees.where((e) {
    //   return e.firstName.toLowerCase().contains(query) ||
    //       e.empId.toLowerCase().contains(query);
    // }).toList();
    return splashController.employees.where((e) {
      return e.firstName.toLowerCase().contains(query) ||
          e.empId.toLowerCase().contains(query);
    }).toList();
  }
}
