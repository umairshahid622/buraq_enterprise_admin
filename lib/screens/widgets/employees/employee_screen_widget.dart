import 'package:buraq_enterprise_admin/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/screens/controllers/employees/employee_controller.dart';
import 'package:buraq_enterprise_admin/screens/controllers/splash/splash_screen_controller.dart';
import 'package:buraq_enterprise_admin/utils/app_util.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_spiner.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text_field.dart';
import 'package:buraq_enterprise_admin/utils/widgets/buttons/app_filled_button.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class EmployeeScreenWidget extends StatelessWidget {
  const EmployeeScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double screnHeight = MediaQuery.of(context).size.height;
    
    return GetBuilder<EmployeeController>(
      init: EmployeeController(),
      builder: (controller) {
        return Column(
          children: [
            employeeHeader(context, controller, controller.splashController),
            Expanded(
              child: AppScrollableBody(
                centerContent: controller.splashController.employees.isEmpty,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: screnHeight * 0.05),
                  child: Column(
                    children: [
                      Obx(() {
                        if (controller.splashController.isEmployeesLoading.value) {
                          return AppSpiner();
                        }
                        if (controller.splashController.employees.isEmpty &&
                            !controller.splashController.isEmployeesLoading.value) {
                          return AppUtils.noDataFound(
                            context: context,
                            heading: "No Employees Found",
                            subHeading: "Add Employees to get started",
                          );
                        }
                        return Column(
                          children: [
                            statusCards(
                              context: context,
                              employeeController: controller,
                              splashController: controller.splashController,
                            ),
                            SizedBox(
                              height: AppConstants.commonVerticalSpacing,
                            ),
                            controller.filteredEmployees.isEmpty
                                ? AppTextHeading(
                                    text:
                                        "No employees found based on your search",
                                    fontSize: 16,
                                  )
                                : SizedBox.shrink(),

                            ListView.separated(
                              itemCount: controller.filteredEmployees.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final employee =
                                    controller.filteredEmployees[index];
                                final String firstName = employee.firstName;
                                final String lastName = employee.lastName;
                                final String status = employee.status;
                                final String employeeId = employee.empId;
                                final String employeePhone = employee.phone;
                                final int allocatedAmount =
                                    employee.allocatedAmount;
                                final int spentAmount =
                                    int.tryParse(
                                      '${allocatedAmount - employee.remaining}',
                                    ) ??
                                    0;

                                return AppCardWidget(
                                  cardWidget: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppUtils.getNameInitalsContainer(
                                        colorScheme: context.appColors,
                                        firstName: firstName,
                                        lastName: '',
                                        size: 44,
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: AppConstants
                                                .commonHorizontalSpacing,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: AppTextBody(
                                                      text:
                                                          '$firstName $lastName',
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  AppUtils.statusContainer(
                                                    context: context,
                                                    status: status,
                                                    fontSize: 13,
                                                  ),
                                                ],
                                              ),
                                              AppTextBody(
                                                text: employeeId,
                                                color:
                                                    context.appColors.secondary,
                                                fontSize: 14,
                                              ),
                                              SizedBox(height: 10),
                                              contactRow(
                                                context,
                                                employeePhone,
                                                14,
                                                Icons.phone,
                                              ),
                                              StreamBuilder<int>(
                                                stream: controller.splashController
                                                    .getActiveProjectsCountStream(
                                                      employeeId,
                                                    ),
                                                builder: (context, snapshot) {
                                                  String projectsText =
                                                      "Loading...";
                                                  if (snapshot.hasData) {
                                                    projectsText =
                                                        "${snapshot.data} Active Projects";
                                                  } else if (snapshot
                                                      .hasError) {
                                                    projectsText = "Error";
                                                  }

                                                  return contactRow(
                                                    context,
                                                    projectsText,
                                                    14,
                                                    Icons
                                                        .business_center_outlined,
                                                  );
                                                },
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  AppUtils.expenseCard(
                                                    context,
                                                    "Allocated",
                                                    allocatedAmount,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        AppConstants
                                                            .commonHorizontalSpacing /
                                                        2,
                                                  ),
                                                  AppUtils.expenseCard(
                                                    context,
                                                    "Spent",
                                                    spentAmount,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.more_vert,
                                        color: context.appColors.secondary,
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: AppConstants.commonVerticalSpacing,
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

  Row contactRow(
    BuildContext context,
    String employeePhone,
    double fontSize,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: context.appColors.secondary, size: fontSize),
        SizedBox(width: 5),
        AppTextBody(
          text: employeePhone,
          color: context.appColors.secondary,
          fontSize: fontSize,
        ),
      ],
    );
  }

  Row statusCards({
    required BuildContext context,
    required EmployeeController employeeController,
    required SplashController splashController,
  }) {
    final employeeLength = splashController.employees.length;
    final activeEmployeeLength = splashController.employees
        .where((e) => e.status == Status.active.name)
        .length;
    final inActiveEmployeeLength = splashController.employees
        .where((e) => e.status == Status.inactive.name)
        .length;

    return Row(
      children: [
        Expanded(
          child: AppCardWidget(
            cardWidget: Column(
              children: [
                AppTextHeading(text: employeeLength.toString()),
                SizedBox(height: 10),
                AppTextBody(text: "Total", color: context.appColors.secondary),
              ],
            ),
          ),
        ),
        SizedBox(width: AppConstants.commonHorizontalSpacing),
        Expanded(
          child: AppCardWidget(
            cardWidget: Column(
              children: [
                AppTextHeading(
                  text: activeEmployeeLength.toString(),
                  color: context.appColors.colorGreen,
                ),
                SizedBox(height: 10),
                AppTextBody(
                  text: Status.active.name.capitalize!,
                  color: context.appColors.secondary,
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: AppConstants.commonHorizontalSpacing),
        Expanded(
          child: AppCardWidget(
            cardWidget: Column(
              children: [
                AppTextHeading(
                  text: inActiveEmployeeLength.toString(),
                  color: inActiveEmployeeLength <= 0
                      ? context.appColors.colorGreen
                      : context.appColors.error,
                ),
                SizedBox(height: 10),
                AppTextBody(
                  text: Status.inactive.name.capitalize!,
                  color: context.appColors.secondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row employeeHeader(BuildContext context, EmployeeController controller, SplashController splashController) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            enabled: !splashController.isEmployeesLoading.value,
            controller: controller.searchController,
            hintText: "Search employee ...",
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
    );
  }
}
