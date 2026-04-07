import 'package:buraq_enterprise_admin/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/screens/controllers/projects/add_project_screen_controller.dart';
import 'package:buraq_enterprise_admin/screens/controllers/splash/splash_screen_controller.dart';
import 'package:buraq_enterprise_admin/utils/app_util.dart';
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
    final double screnHeight = MediaQuery.of(context).size.height;
    final Widget spacing = SizedBox(height: screnHeight * 0.02);
    return GetBuilder(
      init: AddProjectScreenController(),
      dispose: (controller) => Get.delete<AddProjectScreenController>(),
      builder: (controller) {
        final splashController = Get.find<SplashController>();
        if (splashController.employees.isEmpty) {
          return AppScrollableBody(
            centerContent: true,
            child: AppUtils.noDataFound(
              context: context,
              heading: "No Employee found to allocate the project",
              subHeading: "Add a Employee to get started",
            ),
          );
        }
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
                            controller: controller,
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
                          if (controller.startDateController.text.isEmpty) {
                            AppUtils.showToast(
                              label: "Please select a start date first",
                              vairant: ToastVariants.error,
                            );
                            return;
                          }
                          _selectDate(
                            context: context,
                            controller: controller,

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
                  splashController: splashController,
                ),
                spacing,
                addProjectBtn(controller, context),
              ],
            ),
          ),
        );
      },
    );
  }

  Obx addProjectBtn(
    AddProjectScreenController controller,
    BuildContext context,
  ) {
    return Obx(() {
      return AppFilledButton(
        isEnable: !controller.isLoading.value,
        isLoading: controller.isLoading.value,
        onPressedCallBack: () {
          controller.createProject(context: context);
        },
        buttonText: "Add a Project",
      );
    });
  }

  Widget _multiSelectEmployeesDropdown({
    required BuildContext context,
    required AddProjectScreenController controller,
    required SplashController splashController,
  }) {
    final selectedEmployees = splashController.employees
        .where((e) => controller.selectedEmployeeIds.contains(e.empId))
        .toList();
    final selectedNames = selectedEmployees
        .map((e) => "${e.firstName} ${e.lastName}")
        .join(', ');

    final displayText = selectedNames.isEmpty
        ? "Select Employees"
        : selectedNames;

    return FormField<List<String>>(
      validator: (value) {
        if (controller.selectedEmployeeIds.isEmpty) {
          return 'Please select at least one employee';
        }
        return null;
      },
      builder: (FormFieldState<List<String>> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: AppTextBody(
                  text: displayText,
                  color: context.appColors.secondary,
                ),
                items: splashController.employees.isEmpty
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
                    : splashController.employees.map((employee) {
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
                                  state.didChange(
                                    controller.selectedEmployeeIds,
                                  );
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
                  return splashController.employees.map((_) {
                    return AppTextBody(text: displayText);
                  }).toList();
                },
                buttonStyleData: ButtonStyleData(
                  elevation: 0,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius,
                    ),
                    border: Border.all(
                      color: state.hasError
                          ? Colors.red
                          : context.appColors.outline,
                    ),
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  offset: const Offset(0, -5),
                  maxHeight: 280,
                  elevation: 1,
                  decoration: BoxDecoration(
                    border: Border.all(color: context.appColors.outline),
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius,
                    ),
                  ),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(Icons.keyboard_arrow_down),
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                child: AppTextBody(
                  text: state.errorText!,
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate({
    required BuildContext context,
    required AddProjectScreenController controller,
    required TextEditingController dateController,
  }) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: dateController.text.isEmpty
          ? DateTime.now()
          : DateTime.parse(dateController.text),
      firstDate: controller.startDateController.text.isNotEmpty
          ? DateTime.parse(controller.startDateController.text)
          : DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      dateController.text = AppUtils.dateFormatter(selectedDate.toString());
    }
  }
}
