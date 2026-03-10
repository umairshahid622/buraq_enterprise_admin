import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ProjectScreenController extends GetxController {
  final TextEditingController projectController = TextEditingController();
  
  @override
  void onClose() {
    projectController.dispose();
    super.onClose();
  }
}
