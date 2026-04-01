import 'package:buraq_enterprise_admin/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
import 'package:buraq_enterprise_admin/core/constants/app_enum.dart';
import 'package:buraq_enterprise_admin/screens/controllers/projects/project_screen_controller.dart';
import 'package:buraq_enterprise_admin/utils/app_util.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_card_widget.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_spiner.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text_field.dart';
import 'package:buraq_enterprise_admin/utils/widgets/buttons/app_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ProjectScreenWidget extends StatelessWidget {
  const ProjectScreenWidget({super.key});
  // final ProjectScreenController _controller = Get.put<ProjectScreenController>(ProjectScreenController());

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return GetBuilder<ProjectScreenController>(
      init: ProjectScreenController(),
      builder: (controller) {
        return Column(
          children: [
            projectHeader(controller, context),
            Expanded(
              child: AppScrollableBody(
                centerContent: controller.projects.isEmpty,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.05),
                  child: Column(
                    children: [
                      Obx(() {
                        if (controller.isLoading.value) {
                          return AppSpiner();
                        }

                        if (controller.projects.isEmpty) {
                          return AppUtils.noDataFound(context: context, heading: "No projects found", subHeading: "Add a project to get started");        
                        }

                        return Column(
                          children: [
                            statusCards(
                              context: context,
                              controller: controller,
                            ),
                            SizedBox(
                              height: AppConstants.commonVerticalSpacing,
                            ),
                            controller.filteredProjects.isEmpty
                                ? AppTextHeading(
                                    text:
                                        "No Project found based on your search",
                                    fontSize: 16,
                                  )
                                : SizedBox.shrink(),
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                final project =
                                    controller.filteredProjects[index];
                                final String projectName = project.projectName;
                                final String projectDiscription =
                                    project.projectDiscription;
                                final String startDate = AppUtils.dateFormatter(
                                  project.startDate.toString(),
                                );
                                final String endDate = AppUtils.dateFormatter(
                                  project.endDate.toString(),
                                );
                                final String status = project.status;
                                final String projectId = project.projectId;
                                final List<String> employeeIds =
                                    project.employeeIds;

                                final int totalBudget =
                                    project.totalBudgetAllocated;
                                final int remainingBudget =
                                    project.remainingBudget;
                                final spentBudget =
                                    totalBudget - remainingBudget;
                                final int daysRemaining = AppUtils.calculateDaysRemaining(project.endDate);

                                final double progressValue =
                                    AppUtils.calculatePercentage(
                                      spentBudget,
                                      totalBudget,
                                    );

                                return AppCardWidget(
                                  cardWidget: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      projectCardHeader(
                                        projectName,
                                        context,
                                        status,
                                      ),
                                      AppTextBody(text: projectDiscription),
                                      AppTextBody(
                                        text: projectId,
                                        fontSize: 14,
                                      ),
                                      SizedBox(height: screenHeight * 0.02),
                                      projectCardDateAndEmployee(
                                        context,
                                        startDate,
                                        endDate,
                                        employeeIds,
                                      ),
                                      SizedBox(height: screenHeight * 0.02),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppTextBody(text: "Budget Used"),
                                          AppTextHeading(
                                            text:
                                                "${progressValue.toString()} %",
                                            fontSize: 16,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 7),
                                      LinearProgressIndicator(
                                        borderRadius: BorderRadius.circular(12),
                                        value: progressValue / 100,
                                        minHeight: 6.5,
                                      ),
                                      SizedBox(height: 7),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppTextBody(
                                            text:
                                                "${AppUtils.formatPKR(spentBudget)} spent",
                                          ),
                                          AppTextBody(
                                            text:
                                                "${AppUtils.formatPKR(remainingBudget)} left",
                                            color: context.appColors.colorGreen,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: screenHeight * 0.02),
                                      Row(
                                        children: [
                                          AppUtils.expenseCard(
                                            context,
                                            "Total Budget",
                                            totalBudget,
                                          ),
                                          SizedBox(width: 10),
                                          AppUtils.expenseCard(
                                            context,
                                            "Days Remaining",
                                            daysRemaining,
                                            showCurrency: false,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                    return SizedBox(height: 10);
                                  },
                              itemCount: controller.filteredProjects.length,
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

  Row statusCards({
    required BuildContext context,
    required ProjectScreenController controller,
  }) {
    final activeProjectsLength = controller.projects
        .where((e) => e.status == Status.active.name)
        .length;
    final totalBudget = controller.projects.fold<int>(
      0,
      (previousValue, element) => previousValue + element.totalBudgetAllocated,
    );

    final remainingBudget = controller.projects.fold<int>(
      0,
      (previousValue, element) => previousValue + element.remainingBudget,
    );

    final spentBudget = totalBudget - remainingBudget;

    final double headingFontSize = 18;

    return Row(
      children: [
        Expanded(
          child: AppCardWidget(
            cardWidget: Column(
              children: [
                AppTextHeading(
                  text: activeProjectsLength.toString(),
                  fontSize: headingFontSize,
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
                  text: AppUtils.formatPKR(totalBudget),
                  fontSize: headingFontSize,
                ),
                SizedBox(height: 10),
                AppTextBody(text: "Budget", color: context.appColors.secondary),
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
                  text: AppUtils.formatPKR(spentBudget),
                  fontSize: headingFontSize,
                ),
                SizedBox(height: 10),
                AppTextBody(text: "Spent", color: context.appColors.secondary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row projectCardDateAndEmployee(
    BuildContext context,
    String startDate,
    String endDate,
    List<String> employeeIds,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text.rich(
          TextSpan(
            children: <InlineSpan>[
              WidgetSpan(
                child: Icon(
                  Icons.calendar_month_outlined,
                  color: context.appColors.secondary,
                  size: 18,
                ),
              ),
              WidgetSpan(
                child: AppTextBody(
                  text: ' $startDate - $endDate',
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: <InlineSpan>[
              WidgetSpan(
                child: Icon(
                  Icons.people_sharp,
                  color: context.appColors.secondary,
                  size: 18,
                ),
              ),
              WidgetSpan(
                child: AppTextBody(
                  text: ' ${employeeIds.length} Employees',
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row projectCardHeader(
    String projectName,
    BuildContext context,
    String status,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(child: AppTextHeading(text: projectName)),
              SizedBox(width: 10),
              AppUtils.statusContainer(context: context, status: status),
            ],
          ),
        ),
        SizedBox(width: 10),
        Icon(Icons.arrow_forward, color: context.appColors.secondary, size: 20),
      ],
    );
  }

  Row projectHeader(ProjectScreenController controller, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            enabled: !controller.isLoading.value,
            controller: controller.projectSearchController,
            hintText: "Search project...",
            onTextChangeCallBack: (value) {
              controller.onSearchChanged(value);
            },
            prefixIcon: const Icon(Icons.search),
          ),
        ),
        SizedBox(width: 20),
        AppFilledButton(
          buttonWidth: 60,
          buttonText: "+",
          fontSize: 20,
          onPressedCallBack: () {
            context.go('/projects/add-project');
          },
        ),
      ],
    );
  }
}
