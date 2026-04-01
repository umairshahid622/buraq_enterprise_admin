
import 'package:buraq_enterprise_admin/screens/controllers/splash/splash_screen_controller.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  late final SplashController splashController;
  @override
  void onInit() {
    super.onInit();
    splashController = Get.find<SplashController>();
  }


  get totalBudget => splashController.projects.fold<int>(0, (previousValue, element) => previousValue + element.totalBudgetAllocated);
  get remainingBudget => splashController.projects.fold<int>(0, (previousValue, element) => previousValue + element.remainingBudget);
  get totalSpent => totalBudget - remainingBudget;

}
