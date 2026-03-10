import 'package:buraq_enterprise_admin/screens/controllers/projects/project_screen_controller.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text_field.dart';
import 'package:buraq_enterprise_admin/utils/widgets/buttons/app_filled_button.dart';
import 'package:flutter/material.dart';

class ProjectScreenWidget extends StatelessWidget {
  ProjectScreenWidget({super.key});
  final ProjectScreenController _controller = ProjectScreenController();

  @override
  Widget build(BuildContext context) {
    return AppScrollableBody(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _controller.projectController,
                  hintText: "Search project...",
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              SizedBox(width: 20),
              AppFilledButton(
                buttonWidth: 60,
                buttonText: "+",
                fontSize: 20,
                onPressedCallBack: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
