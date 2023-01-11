import 'package:flutter/material.dart';

import '../../../config/localization/l10n/l10n.dart';
import '../../../config/routing/navigation_service.dart';
import '../../../config/routing/routes.dart';
import '../../extensions/num_extensions.dart';
import '../../resources/app_resources.dart';
import '../app_views.dart';

class NotLoggedInWidget extends StatelessWidget {
  const NotLoggedInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppImages.login, width: deviceWidth * 0.8),
          VerticalSpace(AppSize.s16.h),
          CustomText(
            L10n.tr(context).loginFirst,
            fontWeight: FontWeightManager.medium,
            textAlign: TextAlign.center,
            height: AppSize.s1_5.h,
          ),
          VerticalSpace(AppSize.s16.h),
          CustomButton(
            onPressed: () => NavigationService.push(context, Routes.loginScreen),
            text: L10n.tr(context).login,
          ),
        ],
      ),
    );
  }
}
