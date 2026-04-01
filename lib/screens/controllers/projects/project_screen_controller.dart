import 'package:buraq_enterprise_admin/models/project_model.dart';
import 'package:buraq_enterprise_admin/screens/controllers/splash/splash_screen_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';


class ProjectScreenController extends GetxController {
  final TextEditingController projectSearchController = TextEditingController();
  late final SplashController splashController;
  // final ProjectRepository projectRepository = ProjectRepository();
  // final RxList<ProjectModel> projects = <ProjectModel>[].obs;

  // RxBool isLoading = true.obs;
  
  final RxString searchQuery = ''.obs;

  @override
  void onReady() {
    super.onReady();    
    
  }

  @override
  void onInit() {
    super.onInit();
    splashController = Get.find<SplashController>();
  }


  void onSearchChanged(String query) {
    searchQuery.value = query.trim().toLowerCase();
  }


  List<ProjectModel> get filteredProjects {
    if (searchQuery.value.isEmpty) {
      return splashController.projects;
    }

    final query = searchQuery.value.toLowerCase();

    return splashController.projects.where((project) {
      return project.projectName.toLowerCase().contains(query) ||
          project.projectId.toLowerCase().contains(query);
    }).toList();
  }
  

  @override
  void onClose() {
    projectSearchController.dispose();
    super.onClose();
  }
}
