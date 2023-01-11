import 'package:agar_online/core/extensions/num_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../config/localization/l10n/l10n.dart';
import '../../../../config/routing/navigation_service.dart';
import '../../../resources/app_resources.dart';
import '../custom_text.dart';
import '../custom_text_button.dart';
import 'base_platform_widget.dart';

class AppDialog extends BasePlatformWidget<AlertDialog, CupertinoAlertDialog> {
  final String title;
  final VoidCallback onConfirm;
  final String confirmText;
  final String? description;

  const AppDialog({
    required this.title,
    required this.onConfirm,
    required this.confirmText,
    this.description,
    Key? key,
  }) : super(key: key);

  @override
  CupertinoAlertDialog createCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: CustomText(title, fontWeight: FontWeightManager.medium, fontSize: FontSize.s16),
      content: description != null ? CustomText(description!) : null,
      actions: [
        CustomTextButton(
          text: L10n.tr(context).cancel,
          textColor: AppColors.red,
          onPressed: () => NavigationService.goBack(context),
        ),
        CustomTextButton(
          text: confirmText,
          onPressed: () async {
            await NavigationService.goBack(context);
            onConfirm();
          },
        ),
      ],
    );
  }

  @override
  AlertDialog createMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: CustomText(title, fontWeight: FontWeightManager.medium, fontSize: FontSize.s16),
      titlePadding: EdgeInsets.symmetric(horizontal: AppPadding.p16.w,vertical: AppPadding.p16.h),
      content: description != null ? CustomText(description!) : null,
      contentPadding: EdgeInsets.symmetric(horizontal: AppPadding.p16.w),
      actionsPadding: EdgeInsets.symmetric(horizontal: AppPadding.p16.w).copyWith(top: AppPadding.p16.h),
      actions: [
        CustomTextButton(
            text: L10n.tr(context).cancel,
            textColor: AppColors.red,
            onPressed: () => NavigationService.goBack(context)),
        CustomTextButton(
          text: confirmText,
          onPressed: () {
            NavigationService.goBack(context);
            onConfirm();
          },
        ),
      ],
    );
  }
}
