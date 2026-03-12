import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/data/auth/auth_repository.dart';
import 'package:buraq_enterprise_admin/screens/controllers/common/user_controller.dart';
import 'package:buraq_enterprise_admin/utils/app_util.dart';
import 'package:get/get.dart';

class ProfileWidgetController extends GetxController {
  RxBool isLoading = false.obs;
  final AuthRepository _authRepository;
  ProfileWidgetController(this._authRepository);

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _authRepository.signOut();
      isLoading.value = false;
      Get.find<UserController>().clearUser();
    } catch (e) {
      isLoading.value = false;
      AppUtils.showToast(
        context: Get.context!,
        label: "Something went wrong",
        vairant: ToastVariants.error,
      );
    }
  }
}
