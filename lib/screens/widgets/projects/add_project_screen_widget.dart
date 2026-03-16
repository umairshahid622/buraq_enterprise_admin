import 'package:buraq_enterprise_admin/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/screens/controllers/common/employee_controller.dart';
import 'package:buraq_enterprise_admin/screens/controllers/projects/add_project_screen_controller.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text_field.dart';
import 'package:buraq_enterprise_admin/utils/widgets/buttons/app_filled_button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProjectScreenWidget extends StatelessWidget {
  const AddProjectScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final EmployeeController employeeController =
        Get.find<EmployeeController>();
    final double screnHeight = MediaQuery.of(context).size.height;
    final Widget spacing = SizedBox(height: screnHeight * 0.02);
    return GetBuilder(
      init: AddProjectScreenController(),
      dispose: (controller) => controller.dispose(),
      builder: (controller) {
        return AppScrollableBody(
          centerContent: true,
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                spacing,
                Row(
                  children: [
                    Flexible(
                      child: AppTextField(
                        controller: controller.startDateController,
                        readOnly: true,
                        hintText: "Start Date",
                        labelText: "Start Date",
                        prefixIcon: const Icon(Icons.calendar_month),
                        onTapCallBack: () {
                          _selectDate(
                            context: context,
                            dateController: controller.startDateController,
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                    Flexible(
                      child: AppTextField(
                        controller: controller.endDateController,
                        readOnly: true,
                        hintText: "End Date",
                        labelText: "End Date",
                        prefixIcon: const Icon(Icons.calendar_month),
                        onTapCallBack: () {
                          _selectDate(
                            context: context,
                            dateController: controller.endDateController,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                spacing,
                AppTextField(
                  type: TextFieldType.amount,
                  labelText: "Budget of Project",
                  hintText: "Enter allocated amount",
                  controller: controller.totalBudgetAllocatedController,
                ),
                spacing,
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.textFieldLabelMargin,
                  ),
                  child: AppTextHeading(
                    text: "Select the Employees for the project",
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                _multiSelectEmployeesDropdown(
                  context: context,
                  controller: controller,
                  employeeController: employeeController,
                ),
                spacing,
                AppFilledButton(onPressedCallBack: (){
                  controller.createProject(context: context);
                }, buttonText: "Add a Project")
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _multiSelectEmployeesDropdown({
    required BuildContext context,
    required AddProjectScreenController controller,
    required EmployeeController employeeController,
  }) {
    final selectedEmployees = employeeController.employees
        .where((e) => controller.selectedEmployeeIds.contains(e.empId))
        .toList();
    final selectedNames = selectedEmployees
        .map((e) => "${e.firstName} ${e.lastName}")
        .join(', ');

    final displayText = selectedNames.isEmpty
        ? "Select Employees"
        : selectedNames;

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,

        hint: AppTextBody(
          text: displayText,
          color: context.appColors.secondary,
        ),
        items: employeeController.employees.isEmpty
            ? [
                DropdownItem<String>(
                  value: '',
                  enabled: false,
                  child: AppTextBody(
                    text: "No employees available",
                    color: context.appColors.secondary,
                  ),
                ),
              ]
            : employeeController.employees.map((employee) {
                return DropdownItem<String>(
                  value: employee.empId,
                  enabled: false,
                  child: StatefulBuilder(
                    builder: (context, menuSetState) {
                      final isSelected = controller.isEmployeeSelected(
                        employee.empId,
                      );
                      return InkWell(
                        onTap: () {
                          controller.toggleEmployee(employee.empId);
                          menuSetState(() {});
                        },
                        child: SizedBox(
                          height: 56,
                          child: Row(
                            children: [
                              Expanded(
                                child: AppTextBody(
                                  text:
                                      "${employee.firstName} ${employee.lastName}",
                                  fontSize: 14,
                                ),
                              ),
                              Icon(
                                Icons.check,
                                size: 16,
                                color: isSelected
                                    ? context.appColors.primary
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
        onChanged: (_) {},
        selectedItemBuilder: (context) {
          return employeeController.employees.map((_) {
            return AppTextBody(text: displayText);
          }).toList();
        },
        buttonStyleData: ButtonStyleData(
          elevation: 0,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(color: context.appColors.outline),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          offset: Offset(0, -5),
          maxHeight: 280,
          elevation: 1,
          decoration: BoxDecoration(
            border: Border.all(color: context.appColors.outline),
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down),
        ),
      ),
    );
  }

  Future<void> _selectDate({
    required BuildContext context,
    required TextEditingController dateController,
  }) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: dateController.text.isEmpty
          ? DateTime.now()
          : DateTime.parse(dateController.text),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      dateController.text = selectedDate.toString().split(" ")[0];
    }
  }
}
