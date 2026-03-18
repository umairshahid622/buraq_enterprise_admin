import 'package:buraq_enterprise_admin/data/auth/auth_repository.dart';
import 'package:buraq_enterprise_admin/data/screens/employee_repository.dart';
import 'package:buraq_enterprise_admin/data/screens/project_repository.dart';
import 'package:buraq_enterprise_admin/screens/controllers/common/employee_controller.dart';
import 'package:buraq_enterprise_admin/screens/controllers/common/theme_controller.dart';
import 'package:buraq_enterprise_admin/screens/controllers/common/user_controller.dart';
import 'package:buraq_enterprise_admin/screens/controllers/projects/project_screen_controller.dart';
import 'package:buraq_enterprise_admin/screens/controllers/splash/splash_screen_controller.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ThemeController>(ThemeController(), permanent: true);

    Get.put<UserController>(UserController(AuthRepository()), permanent: true);

    Get.put<EmployeeController>(
      EmployeeController(EmployeeRepository()),
      permanent: true,
    );
    Get.put<ProjectScreenController>(
      ProjectScreenController(ProjectRepository()),
      permanent: true,
    );

    Get.put<SplashController>(SplashController(), permanent: true);
  }
}
