import 'package:buraq_enterprise_admin/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_admin/core/constants/app_constants.dart';
import 'package:buraq_enterprise_admin/screens/controllers/home/home_screen_controller.dart';
import 'package:buraq_enterprise_admin/utils/app_util.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_card_widget.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_admin/utils/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreenWidget extends StatelessWidget {
  const HomeScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomeScreenController(),
      builder: (controller) {
        final splashController = controller.splashController;
        return AppScrollableBody(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppCardWidget(
                      cardWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.appColors.primary.withValues(
                                alpha: 0.25,
                              ),
                            ),
                            child: Icon(
                              Icons.folder_outlined,
                              color: context.appColors.primary,
                            ),
                          ),
                          SizedBox(height: 15),
                          AppTextHeading(text: splashController.projects.length.toString()),
                          SizedBox(height: 15),
                          AppTextBody(text: "Active Projects"),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: AppConstants.commonHorizontalSpacing),
                  Expanded(
                    child: AppCardWidget(
                      cardWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.appColors.secondary.withValues(
                                alpha: 0.25,
                              ),
                            ),
                            child: Icon(
                              Icons.people_sharp,
                              color: context.appColors.secondary,
                            ),
                          ),
                          SizedBox(height: 15),
                          AppTextHeading(text: splashController.employees.length.toString()),
                          SizedBox(height: 15),
                          AppTextBody(text: "Total Employees"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppConstants.commonHorizontalSpacing),
              Row(
                children: [
                  Expanded(
                    child: AppCardWidget(
                      cardWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.appColors.colorGreen.withValues(
                                alpha: 0.25,
                              ),
                            ),
                            child: Icon(
                              Icons.attach_money,
                              color: context.appColors.colorGreen,
                            ),
                          ),
                          SizedBox(height: 15),
                          AppTextHeading(text: AppUtils.formatPKR(controller.totalBudget)),
                          SizedBox(height: 15),
                          AppTextBody(text: "Total Budget"),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: AppConstants.commonHorizontalSpacing),
                  Expanded(
                    child: AppCardWidget(
                      cardWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.appColors.error.withValues(
                                alpha: 0.25,
                              ),
                            ),
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Icon(
                                Icons.double_arrow_rounded,
                                color: context.appColors.error,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          AppTextHeading(text: AppUtils.formatPKR(controller.totalSpent)),
                          SizedBox(height: 15),
                          AppTextBody(text: "Total Spent"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}
