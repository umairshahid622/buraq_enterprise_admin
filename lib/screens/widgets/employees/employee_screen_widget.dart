import 'package:buraq_enterprise_admin/screens/controllers/employees/employee_screen_controller.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text_field.dart';
import 'package:buraq_enterprise_admin/utils/widgets/buttons/app_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmployeeScreenWidget extends StatelessWidget {
   EmployeeScreenWidget({super.key});
  final EmployeeScreenController _controller = EmployeeScreenController();


  @override
  Widget build(BuildContext context) {
    return AppScrollableBody(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _controller.employeeSearchController,
                  hintText: "Search employee...",
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              SizedBox(width: 20),
              AppFilledButton(
                buttonWidth: 60,
                buttonText: "+",
                fontSize: 20,
                onPressedCallBack: () {
                  context.go('/employees/add-employee');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
