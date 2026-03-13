import 'package:buraq_enterprise_admin/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/screens/controllers/common/employee_controller.dart';
import 'package:buraq_enterprise_admin/utils/app_util.dart';
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
  final EmployeeController _controller = Get.find<EmployeeController>();

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
                            final String firstName =
                                _controller.filteredEmployees[index].firstName;
                            final String lastName =
                                _controller.filteredEmployees[index].lastName;
                            final status =
                                _controller.filteredEmployees[index].status;
                            final employeeId =
                                _controller.filteredEmployees[index].empId;
                            final employeePhone =
                                _controller.filteredEmployees[index].phone;

                            return ProfileCard(
                              cardWidget: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  text: '$firstName $lastName',
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              statusContainer(
                                                context: context,
                                                status: status,
                                                fontSize: 13,
                                              ),
                                            ],
                                          ),
                                          AppTextBody(
                                            text: employeeId,
                                            color: context.appColors.secondary,
                                            fontSize: 14,
                                          ),
                                          SizedBox(height: 10),
                                          contactRow(context, employeePhone, 14,Icons.phone),
                                          contactRow(context, employeePhone, 14,Icons.business_center_outlined),
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
  }

  Row contactRow(BuildContext context, String employeePhone, double fontSize, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: context.appColors.secondary, size: fontSize),
        SizedBox(width: 5,),
        AppTextBody(
          text: employeePhone,
          color: context.appColors.secondary,
          fontSize: fontSize,
        ),
      ],
    );
  }

  Container statusContainer({
    required BuildContext context,
    required String status,
    double? fontSize,
  }) {
    final Color bgColor;
    final Color textColor;
    if (status == EmployeeStatus.active.name) {
      bgColor = context.appColors.colorGreen.withValues(alpha: 0.20);
      textColor = context.appColors.colorGreen;
    } else if (status == EmployeeStatus.inactive.name) {
      bgColor = context.appColors.error.withValues(alpha: 0.20);
      textColor = context.appColors.error;
    } else {
      bgColor = context.appColors.secondary.withValues(alpha: 0.20);
      textColor = context.appColors.secondary;
    }
    if (status.isEmpty) {
      return Container();
    }
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: textColor, width: 1),
      ),

      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: AppTextBody(text: status, color: textColor, fontSize: fontSize),
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
