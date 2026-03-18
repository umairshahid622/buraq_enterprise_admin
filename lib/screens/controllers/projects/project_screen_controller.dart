import 'package:buraq_enterprise_admin/data/screens/project_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ProjectScreenController extends GetxController {
  ProjectRepository projectRepository;
  ProjectScreenController(this.projectRepository);
  final TextEditingController projectController = TextEditingController();
  
  @override
  void onClose() {
    projectController.dispose();
    super.onClose();
  }
}
