import 'package:buraq_enterprise_admin/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/screens/controllers/employees/employee_manage_controller.dart';
import 'package:buraq_enterprise_admin/utils/app_util.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_card_widget.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_spiner.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text_field.dart';
import 'package:buraq_enterprise_admin/utils/widgets/buttons/app_filled_button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class EmployeeManageScreenWidget extends StatelessWidget {
  const EmployeeManageScreenWidget({super.key, required this.employeeId});

  final String employeeId;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return GetBuilder<EmployeeManageController>(
      init: EmployeeManageController(employeeId: employeeId),
      dispose: (controller) => Get.delete<EmployeeManageController>(),
      builder: (controller) {
        final employee = controller.employee;
        return AppScrollableBody(
          centerContent: employee == null,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.04),
            child: Column(
              children: [
                Obx(() {
                  if (controller.splashController.isEmployeesLoading.value) {
                    return AppSpiner();
                  }

                  if (employee == null) {
                    return AppUtils.noDataFound(
                      context: context,
                      heading: "Employee not found",
                      subHeading: "Please go back and try again",
                    );
                  }

                  return Column(
                    children: [
                      _summaryCard(
                        context: context,
                        name: "${employee.firstName} ${employee.lastName}",
                        status: employee.status,
                        employeeId: employee.empId,
                        allocatedAmount: employee.allocatedAmount,
                        remainingAmount: employee.remaining,
                      ),
                      SizedBox(height: AppConstants.commonVerticalSpacing),
                      _editCard(context: context, controller: controller),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _summaryCard({
    required BuildContext context,
    required String name,
    required String status,
    required String employeeId,
    required int allocatedAmount,
    required int remainingAmount,
  }) {
    final int spentAmount = allocatedAmount - remainingAmount;

    return AppCardWidget(
      cardWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: AppTextHeading(text: name)),
              AppUtils.statusContainer(context: context, status: status),
            ],
          ),
          SizedBox(height: 6),
          AppTextBody(
            text: employeeId,
            fontSize: 14,
            color: context.appColors.secondary,
          ),
          SizedBox(height: 12),
          Row(
            children: [
              AppUtils.expenseCard(context, "Allocated", allocatedAmount),
              SizedBox(width: 10),
              AppUtils.expenseCard(
                context,
                "Spent",
                spentAmount < 0 ? 0 : spentAmount,
              ),
              SizedBox(width: 10),
              AppUtils.expenseCard(
                context,
                "Remaining",
                remainingAmount < 0 ? 0 : remainingAmount,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _editCard({
    required BuildContext context,
    required EmployeeManageController controller,
  }) {
    return AppCardWidget(
      cardWidget: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextHeading(text: "Edit Details"),
            SizedBox(height: 12),
            AppTextField(
              controller: controller.firstNameController,
              labelText: "First Name",
              hintText: "Enter first name",
            ),
            SizedBox(height: 12),
            AppTextField(
              controller: controller.lastNameController,
              labelText: "Last Name",
              hintText: "Enter last name",
            ),
            SizedBox(height: 12),
            AppTextField(
              type: TextFieldType.phoneNumber,
              controller: controller.phoneController,
              labelText: "Phone Number",
              hintText: "0300 1234567",
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.textFieldLabelMargin,
              ),
              child: AppTextHeading(text: "Status", fontSize: 14),
            ),
            SizedBox(height: AppConstants.textFieldLabelMarginVertical),
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                valueListenable: controller.statusNotifier,
                hint: AppTextBody(
                  text: "Select Status",
                  color: context.appColors.secondary,
                ),
                items: [
                  DropdownItem(
                    value: Status.active.name,
                    child: AppTextBody(text: "Active"),
                  ),
                  DropdownItem(
                    value: Status.inactive.name,
                    child: AppTextBody(text: "Inactive"),
                  ),
                ],
                selectedItemBuilder: (context) {
                  final current = controller.status.value;
                  final label = current == Status.inactive.name
                      ? "Inactive"
                      : "Active";
                  return [AppTextBody(text: label), AppTextBody(text: label)];
                },
                onChanged: controller.isSaving.value
                    ? null
                    : (value) => controller.setStatus(value),
                buttonStyleData: ButtonStyleData(
                  elevation: 0,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadius),
                    border: Border.all(color: context.appColors.outline),
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  elevation: 1,
                  decoration: BoxDecoration(
                    border: Border.all(color: context.appColors.outline),
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadius),
                  ),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(Icons.keyboard_arrow_down),
                ),
              ),
            ),
            SizedBox(height: 16),
            Obx(() {
              return AppFilledButton(
                buttonText: "Save Changes",
                isLoading: controller.isSaving.value,
                onPressedCallBack: controller.saveChanges,
              );
            }),
          ],
        ),
      ),
    );
  }
}
