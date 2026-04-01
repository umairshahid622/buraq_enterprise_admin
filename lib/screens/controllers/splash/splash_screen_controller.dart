import 'package:buraq_enterprise_admin/data/screens/employee_repository.dart';
import 'package:buraq_enterprise_admin/data/screens/project_repository.dart';
import 'package:buraq_enterprise_admin/models/employee_model.dart';
import 'package:buraq_enterprise_admin/models/project_model.dart';
import 'package:buraq_enterprise_admin/screens/controllers/common/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../core/config/app_session.dart';

class SplashController extends GetxController {
  final _auth = FirebaseAuth.instance;

  // repository
  final EmployeeRepository employeeRepository = EmployeeRepository();
  final ProjectRepository projectRepository = ProjectRepository();

  final RxList<Employee> employees = <Employee>[].obs;    
  RxList<ProjectModel> projects = <ProjectModel>[].obs;
  
  late final UserController _userController;
  
  final EmployeeRepository _employeeRepository = EmployeeRepository();
  Stream<int> getActiveProjectsCountStream(String employeeId) {
    return _employeeRepository.activeProjectsCountStream(employeeId);    
  }


  RxBool isEmployeesLoading = true.obs;
  RxBool isProjectsLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    _userController = Get.find<UserController>();

    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final user = _auth.currentUser;

    if (user != null) {
      await _userController.fetchUserProfile();

      employees.bindStream(employeeRepository.fetchEmployees());
      projects.bindStream(projectRepository.fetchProjects());

    ever(employees, (_){
      if (isEmployeesLoading.value) {
        isEmployeesLoading.value = false;
      }
      update();
    });
    ever(projects, (_){
      if (isProjectsLoading.value) {
        isProjectsLoading.value = false;
      }
      update();
    });
    }

    await Future.delayed(const Duration(milliseconds: 1500));

    appSession.setReady();
  }
}
