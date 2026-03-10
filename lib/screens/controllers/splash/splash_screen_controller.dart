import 'package:buraq_enterprise_admin/screens/controllers/common/employee_controller.dart';
import 'package:buraq_enterprise_admin/screens/controllers/common/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../core/config/app_session.dart';

class SplashController extends GetxController {
  final _auth = FirebaseAuth.instance;

  late final UserController _userController;
  late final EmployeeController _employeeController;

  @override
  void onInit() {
    super.onInit();

    // Find dependencies
    _userController = Get.find<UserController>();
    _employeeController = Get.find<EmployeeController>();

    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final user = _auth.currentUser;

    if (user != null) {
      await _userController.fetchUserProfile();
      await _employeeController.fetchEmployees();
    }

    await Future.delayed(const Duration(milliseconds: 1500));

    appSession.setReady();
  }
}
