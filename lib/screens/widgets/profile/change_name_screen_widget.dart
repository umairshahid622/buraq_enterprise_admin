import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/screens/controllers/profile/change_name_controller.dart';
import 'package:buraq_enterprise_admin/utils/app_util.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text_field.dart';
import 'package:buraq_enterprise_admin/utils/widgets/buttons/app_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ChangeNameScreenWidget extends StatelessWidget {
  const ChangeNameScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final spacing = height * 0.02;
    return GetBuilder<ChangeNameController>(
      init: ChangeNameController(),
      dispose: (controller) => Get.delete<ChangeNameController>(),
      builder: (controller) {
        return AppScrollableBody(
          centerContent: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppTextHeading(text: "Change Admin Name", fontSize: 22),
              SizedBox(height: spacing),
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    AppTextField(
                      controller: controller.firstNameController,
                      labelText: "First Name",
                      hintText: "Enter Your First Name",
                      prefixIcon: const Icon(Icons.account_circle_outlined),
                    ),
                    SizedBox(height: spacing),
                    AppTextField(
                      controller: controller.lastNameController,
                      labelText: "Last Name",
                      hintText: "Enter Your Last Name",
                      prefixIcon: const Icon(Icons.account_circle_outlined),
                    ),
                    SizedBox(height: spacing),
                    buildChangeNameButton(controller, context),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildChangeNameButton(
    ChangeNameController controller,
    BuildContext context,
  ) {
    return Obx(() {
      return AppFilledButton(
        isLoading: controller.isLoading.value,
        isEnable: !controller.isLoading.value,
        onPressedCallBack: () async {
          await controller.saveChanges();
          if (!context.mounted) return;
          await controller.saveChanges();
          AppUtils.showToast(            
            label: "Name changed successfully",
            vairant: ToastVariants.success,
          );
          context.pop();
        },
        buttonText: "Save Changes",
      );
    });
  }
}
