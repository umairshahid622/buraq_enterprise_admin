import 'package:buraq_enterprise_admin/data/screens/project_repository.dart';
import 'package:buraq_enterprise_admin/models/project_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/state_manager.dart';

class ProjectScreenController extends GetxController {
  final TextEditingController projectController = TextEditingController();
  final ProjectRepository projectRepository = ProjectRepository();

  final RxList<ProjectModel> projects = <ProjectModel>[].obs;


  

  @override
  void onInit() {   
    super.onInit();
    projects.bindStream(projectRepository.fetchProjects());
    ever(projects, (_) {
      update();
    });
  }
  @override
  void onClose() {
    projectController.dispose();
    super.onClose();
  }
}
