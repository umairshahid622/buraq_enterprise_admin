import 'package:buraq_enterprise_admin/screens/controllers/projects/add_project_screen_controller.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class AddProjectScreenWidget extends StatelessWidget {
  const AddProjectScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double screnHeight = MediaQuery.of(context).size.height;
    final Widget spacing = SizedBox(height: screnHeight * 0.025);
    return GetBuilder(
      init: AddProjectScreenController(),
      dispose: (controller) => controller.dispose(),
      builder: (controller) {
        return AppScrollableBody(
          centerContent: true,
          child: Column(
            children: [
              AppTextField(
                controller: controller.projectNameController,
                hintText: "Enter Project Title",
                labelText: "Project Title",
              ),
              spacing,
              AppTextField(
                  controller: controller.projectDiscriptionController,
                hintText: "Enter Project Discription",
                labelText: "Project Discription",
              ),
              AppTextField(
                controller: controller.startDateController,
                readOnly: true,
                onTapCallBack: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}
