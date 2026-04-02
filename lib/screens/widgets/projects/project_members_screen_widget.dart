import 'package:buraq_enterprise_admin/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/models/employee_model.dart';
import 'package:buraq_enterprise_admin/screens/controllers/projects/project_members_controller.dart';
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

class ProjectMembersScreenWidget extends StatelessWidget {
  const ProjectMembersScreenWidget({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return GetBuilder<ProjectMembersController>(
      init: ProjectMembersController(projectId: projectId),
      dispose: (controller) => Get.delete<ProjectMembersController>(),
      builder: (controller) {
        final project = controller.project;
        final int totalBudget = project?.totalBudgetAllocated ?? 0;
        final int remainingBudget = project?.remainingBudget ?? 0;
        final int allocatedBudget = totalBudget - remainingBudget;
        final availableEmployees = controller.availableEmployees;

        return Column(
          children: [
            Expanded(
              child: AppScrollableBody(
                centerContent: project == null,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.04),
                  child: Column(
                    children: [
                      Obx(() {
                        if (controller
                                .splashController
                                .isProjectsLoading
                                .value ||
                            controller.isMembersLoading.value) {
                          return AppSpiner();
                        }

                        if (project == null) {
                          return AppUtils.noDataFound(
                            context: context,
                            heading: "Project not found",
                            subHeading: "Please go back and try again",
                          );
                        }

                        return Column(
                          children: [
                            _summaryCard(
                              context: context,
                              totalBudget: totalBudget,
                              allocatedBudget: allocatedBudget,
                              remainingBudget: remainingBudget,
                              memberCount: controller.members.length,
                            ),
                            SizedBox(
                              height: AppConstants.commonVerticalSpacing,
                            ),
                            _addMemberSection(
                              context: context,
                              controller: controller,
                              availableEmployees: availableEmployees,
                            ),
                            SizedBox(
                              height: AppConstants.commonVerticalSpacing,
                            ),
                            controller.members.isEmpty
                                ? AppTextHeading(
                                    text: "No employees assigned yet",
                                    fontSize: 16,
                                  )
                                : ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: controller.members.length,
                                    itemBuilder: (context, index) {
                                      final member = controller.members[index];
                                      final employee = controller.getEmployee(
                                        member.employeeId,
                                      );
                                      return _memberCard(
                                        context: context,
                                        controller: controller,
                                        employee: employee,
                                        employeeId: member.employeeId,
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height:
                                            AppConstants.commonVerticalSpacing,
                                      );
                                    },
                                  ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _summaryCard({
    required BuildContext context,
    required int totalBudget,
    required int allocatedBudget,
    required int remainingBudget,
    required int memberCount,
  }) {
    return AppCardWidget(
      cardWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextHeading(text: "Project Budget"),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTextBody(text: "Total"),
              AppTextHeading(
                text: AppUtils.formatPKR(totalBudget),
                fontSize: 16,
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTextBody(text: "Allocated"),
              AppTextHeading(
                text: AppUtils.formatPKR(allocatedBudget),
                fontSize: 16,
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTextBody(text: "Remaining"),
              AppTextHeading(
                text: AppUtils.formatPKR(remainingBudget),
                fontSize: 16,
                color: context.appColors.colorGreen,
              ),
            ],
          ),
          SizedBox(height: 10),
          AppTextBody(
            text: "$memberCount Employees Assigned",
            color: context.appColors.secondary,
          ),
        ],
      ),
    );
  }

  Widget _addMemberSection({
    required BuildContext context,
    required ProjectMembersController controller,
    required List<Employee> availableEmployees,
  }) {
    return AppCardWidget(
      cardWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextHeading(text: "Add Employee"),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: availableEmployees.isEmpty
                    ? AppTextBody(
                        text: "All employees are already assigned",
                        color: context.appColors.secondary,
                      )
                    : FormField<List<String>>(
                        builder: (FormFieldState<List<String>> state) {
                          final selectedEmployees = availableEmployees
                              .where(
                                (e) => controller.selectedEmployeeIds.contains(
                                  e.empId,
                                ),
                              )
                              .toList();
                          final selectedNames = selectedEmployees
                              .map((e) => "${e.firstName} ${e.lastName}")
                              .join(', ');
                          final displayText = selectedNames.isEmpty
                              ? "Select Employees"
                              : selectedNames;

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
                                  items: availableEmployees.map((employee) {
                                    return DropdownItem<String>(
                                      value: employee.empId,
                                      enabled: false,
                                      child: StatefulBuilder(
                                        builder: (context, menuSetState) {
                                          final isSelected = controller
                                              .isEmployeeSelected(
                                                employee.empId,
                                              );
                                          return InkWell(
                                            onTap: () {
                                              controller.toggleEmployee(
                                                employee.empId,
                                              );
                                              state.didChange(
                                                controller.selectedEmployeeIds
                                                    .toList(),
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
                                                          "${employee.firstName} ${employee.lastName} (${employee.empId})",
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.check,
                                                    size: 16,
                                                    color: isSelected
                                                        ? context
                                                              .appColors
                                                              .primary
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
                                    return availableEmployees.map((_) {
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
                                        color: context.appColors.outline,
                                      ),
                                    ),
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    offset: const Offset(0, -5),
                                    maxHeight: 280,
                                    elevation: 1,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: context.appColors.outline,
                                      ),
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
                            ],
                          );
                        },
                      ),
              ),
              SizedBox(width: 12),
              availableEmployees.isEmpty
                  ? SizedBox.shrink()
                  : Obx(() {
                      return AppFilledButton(
                        buttonText: "Add",
                        buttonWidth: 90,
                        buttonHeight: 56,
                        isLoading: controller.isActionLoading.value,
                        onPressedCallBack: controller.addMember,
                      );
                    }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _memberCard({
    required BuildContext context,
    required ProjectMembersController controller,
    required Employee? employee,
    required String employeeId,
  }) {
    final String name = employee == null
        ? "Unknown Employee"
        : "${employee.firstName} ${employee.lastName}";

    return AppCardWidget(
      cardWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: AppTextHeading(text: name)),
              IconButton(
                onPressed: controller.isActionLoading.value
                    ? null
                    : () => controller.removeMember(employeeId),
                icon: Icon(
                  Icons.delete_outline,
                  color: context.appColors.error,
                ),
              ),
            ],
          ),
          AppTextBody(
            text: employeeId,
            color: context.appColors.secondary,
            fontSize: 14,
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(left: AppConstants.textFieldLabelMargin),
            child: AppTextHeading(text: "Allocated Amount", fontSize: 14),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  type: TextFieldType.amount,
                  controller: controller.allocationControllerFor(employeeId),
                  hintText: "0",
                  prefixIcon: const Icon(Icons.payments_outlined),
                ),
              ),
              SizedBox(width: 12),
              Obx(() {
                return AppFilledButton(
                  buttonText: "Save",
                  buttonWidth: 90,
                  buttonHeight: 48,
                  isLoading: controller.isActionLoading.value,
                  onPressedCallBack: () =>
                      controller.updateAllocation(employeeId),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
