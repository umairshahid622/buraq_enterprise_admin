import 'package:buraq_enterprise_admin/data/screens/employee_repository.dart';
import 'package:buraq_enterprise_admin/data/screens/project_repository.dart';
import 'package:buraq_enterprise_admin/models/employee_model.dart';
import 'package:buraq_enterprise_admin/models/project_model.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  final EmployeeRepository employeeRepository = EmployeeRepository();
  final ProjectRepository projectRepository = ProjectRepository();

  RxList<Employee> employees = <Employee>[].obs;
  RxList<ProjectModel> projects = <ProjectModel>[].obs;


  RxBool isEmployeesLoading = true.obs;
  RxBool isProjectsLoading = true.obs;

  @override
  void onReady() {
    super.onReady();
    employees.bindStream(employeeRepository.fetchEmployees());
    projects.bindStream(projectRepository.fetchProjects());

    ever(employees, (_){
      isEmployeesLoading.value = false;
      update();
    });
    ever(projects, (_){
      isProjectsLoading.value = false;
      update();
    });
  }

  get totalEmployees => employees.length;
  get totalProjects => projects.length;
}
