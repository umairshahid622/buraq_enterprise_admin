import 'package:buraq_enterprise_admin/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/data/screens/employee_repository.dart';
import 'package:buraq_enterprise_admin/screens/controllers/common/employee_controller.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text_field.dart';
import 'package:buraq_enterprise_admin/utils/widgets/buttons/app_filled_button.dart';
import 'package:buraq_enterprise_admin/utils/widgets/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class EmployeeScreenWidget extends StatelessWidget {
  EmployeeScreenWidget({super.key});
  final EmployeeController _controller = Get.put(
    EmployeeController(EmployeeRepository()),
  );

  @override
  Widget build(BuildContext context) {
    double screnHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        employeeHeader(context),
        Expanded(
          child: AppScrollableBody(
            child: Padding(
              padding: EdgeInsets.only(top: screnHeight * 0.05),
              child: Column(
                children: [
                  Obx(() {
                    return Column(
                      children: [
                        statusCards(context: context),
                        SizedBox(height: AppConstants.commonVerticalSpacing),
                        ListView.separated(
                          itemCount: _controller.filteredEmployees.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ProfileCard(
                              cardWidget: Column(
                                children: [
                                  Text(
                                    _controller
                                        .filteredEmployees[index]
                                        .firstName,
                                  ),
                                  Text(
                                    _controller
                                        .filteredEmployees[index]
                                        .lastName,
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
  }

  Row statusCards({required BuildContext context}) {
    final employeeLength = _controller.employees.length;
    final activeEmployeeLength = _controller.employees
        .where((e) => e.status == EmployeeStatus.active.name)
        .length;
    final inActiveEmployeeLength = _controller.employees
        .where((e) => e.status == EmployeeStatus.inactive.name)
        .length;

    return Row(
      children: [
        Expanded(
          child: ProfileCard(
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
          child: ProfileCard(
            cardWidget: Column(
              children: [
                AppTextHeading(
                  text: activeEmployeeLength.toString(),
                  color: context.appColors.colorGreen,
                ),
                SizedBox(height: 10),
                AppTextBody(
                  text: EmployeeStatus.active.name.capitalize!,
                  color: context.appColors.secondary,
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: AppConstants.commonHorizontalSpacing),
        Expanded(
          child: ProfileCard(
            cardWidget: Column(
              children: [
                AppTextHeading(
                  text: inActiveEmployeeLength.toString(),
                  color: context.appColors.error,
                ),
                SizedBox(height: 10),
                AppTextBody(
                  text: EmployeeStatus.inactive.name.capitalize!,
                  color: context.appColors.secondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row employeeHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            controller: _controller.searchController,
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
    );
  }
}
