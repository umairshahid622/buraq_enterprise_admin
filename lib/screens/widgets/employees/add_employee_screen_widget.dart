import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/screens/controllers/employees/add_employee_controller.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text_field.dart';
import 'package:buraq_enterprise_admin/utils/widgets/buttons/app_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class AddEmployeeScreenWidget extends StatelessWidget {
  AddEmployeeScreenWidget({super.key});
  final AddEmployeeController _controller = AddEmployeeController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double spacing = screenHeight * 0.02;
    return AppScrollableBody(
      centerContent: true,
      child: Form(
        key: _controller.formKey,
        child: Column(
          children: [
            AppTextField(
              labelText: "First Name",
              hintText: "Enter employee's first name",
              controller: _controller.firstNameController,
            ),
            SizedBox(height: spacing),
            AppTextField(
              labelText: "Last Name",
              hintText: "Enter employee's last name",
              controller: _controller.lastNameController,
            ),
            SizedBox(height: spacing),
            AppTextField(
              type: TextFieldType.phoneNumber,
              labelText: "Phone Number",
              hintText: "Enter employee's phone number",
              controller: _controller.phoneNumberController,
            ),
            SizedBox(height: spacing),
            getCreatProfileButton(context: context),
          ],
        ),
      ),
    );
  }

  Obx getCreatProfileButton({required BuildContext context}) {
    return Obx(() {
      return AppFilledButton(
        isEnable: !_controller.isLoading.value,
        isLoading: _controller.isLoading.value,
        onPressedCallBack: () {
          _controller.createEmployee(context: context);
        },
        buttonText: 'Create Profile',
      );
    });
  }
}
