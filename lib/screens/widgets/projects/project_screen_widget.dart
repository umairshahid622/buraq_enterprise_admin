import 'package:buraq_enterprise_admin/screens/controllers/projects/project_screen_controller.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text_field.dart';
import 'package:buraq_enterprise_admin/utils/widgets/buttons/app_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ProjectScreenWidget extends StatelessWidget {
  ProjectScreenWidget({super.key});
  // final ProjectScreenController _controller = Get.put<ProjectScreenController>(ProjectScreenController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectScreenController>(
      init: ProjectScreenController(),
      builder: (controller) {
        return Column(
          children: [
            projectHeader(controller, context),
            Expanded(
              child: AppScrollableBody(
                child: Column(
                  children: [
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final project = controller.projects[index];
                        return Container(child: AppTextBody(text:"${project.projectName}"));
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 10);
                      },
                      itemCount: controller.projects.length,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Row projectHeader(ProjectScreenController controller, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            controller: controller.projectController,
            hintText: "Search project...",
            prefixIcon: const Icon(Icons.search),
          ),
        ),
        SizedBox(width: 20),
        AppFilledButton(
          buttonWidth: 60,
          buttonText: "+",
          fontSize: 20,
          onPressedCallBack: () {
            context.go('/projects/add-project');
          },
        ),
      ],
    );
  }
}
