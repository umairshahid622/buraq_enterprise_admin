import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/screens/controllers/employees/add_employee_controller.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text_field.dart';
import 'package:buraq_enterprise_admin/utils/widgets/buttons/app_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEmployeeScreenWidget extends StatelessWidget {
  const AddEmployeeScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double spacing = screenHeight * 0.02;
    return GetBuilder<AddEmployeeController>(
      init: AddEmployeeController(),
      dispose: (state) => Get.delete<AddEmployeeController>(),
      builder: (controller) {
        return AppScrollableBody(
          centerContent: true,
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                AppTextField(
                  labelText: "First Name",
                  hintText: "Enter employee's first name",
                  controller: controller.firstNameController,
                ),
                SizedBox(height: spacing),
                AppTextField(
                  labelText: "Last Name",
                  hintText: "Enter employee's last name",
                  controller: controller.lastNameController,
                ),
                SizedBox(height: spacing),
                AppTextField(
                  type: TextFieldType.phoneNumber,
                  labelText: "Phone Number",
                  hintText: "Enter employee's phone number",
                  controller: controller.phoneNumberController,
                ),
                SizedBox(height: spacing),
                AppTextField(
                  type: TextFieldType.amount,
                  labelText: "Allocate Amount",
                  hintText: "Enter allocated amount",
                  controller: controller.allocateAmountController,
                ),
                SizedBox(height: spacing),
                getCreatProfileButton(context: context, controller: controller),
              ],
            ),
          ),
        );
      },
    );
  }

  Obx getCreatProfileButton({
    required BuildContext context,
    required AddEmployeeController controller,
  }) {
    return Obx(() {
      return AppFilledButton(
        isEnable: !controller.isLoading.value,
        isLoading: controller.isLoading.value,
        onPressedCallBack: controller.createEmployee,
        buttonText: 'Create Profile',
      );
    });
  }
}
