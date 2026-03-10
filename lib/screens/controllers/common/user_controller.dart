import 'package:buraq_enterprise_admin/data/auth/auth_repository.dart';
import 'package:buraq_enterprise_admin/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final AuthRepository _authRepo;

  UserController(this._authRepo);

  final Rx<UserModel?> _user = Rx<UserModel?>(null);

  final RxBool isLoading = false.obs;

  /// Public getter
  UserModel? get user => _user.value;

  bool get isLoggedIn => user != null;

  @override
  void onInit() {
    super.onInit();
    initializeApp();
  }

  // -------------------------------
  // Load user on app start
  // -------------------------------
  Future<void> initializeApp() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      await fetchUserProfile();
    } else {
      clearUser();
    }
  }

  // -------------------------------
  // Fetch profile
  // -------------------------------
  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;

      final data = await _authRepo.getUserData();

      if (data != null) {
        _user.value = UserModel.fromMap(data);
      } else {
        _user.value = null;
      }
    } catch (e) {
      _user.value = null;

      Get.log('Fetch User Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser({required String firstName, required String lastName}) async {
    try {
      isLoading.value = true;
      await _authRepo.updateUser(firstName: firstName, lastName: lastName);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------
  // Clear user (Logout)
  // -------------------------------
  void clearUser() {
    _user.value = null;
  }
}
