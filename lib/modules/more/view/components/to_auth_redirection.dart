import 'package:flutter/material.dart';


import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../config/localization/l10n/l10n.dart';
import '../../../../config/routing/navigation_service.dart';
import '../../../../config/routing/routes.dart';
import '../../../../core/extensions/num_extensions.dart';

class ToAuthRedirection extends StatelessWidget {
  const ToAuthRedirection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            onPressed: () =>
                NavigationService.push(context, Routes.loginScreen),
            text: L10n.tr(context).login,
          ),
        ),
        HorizontalSpace(AppSize.s16.w),
        Expanded(
          child: CustomButton(
            onPressed: () => NavigationService.push(
                context, Routes.signupScreen,
                arguments: {"from_login": false}),
            color: AppColors.white,
            textColor: AppColors.black,
            text: L10n.tr(context).signup,
          ),
        ),
      ],
    );
  }
}
