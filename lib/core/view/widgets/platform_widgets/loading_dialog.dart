import 'package:agar_online/core/extensions/num_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../config/localization/l10n/l10n.dart';
import '../../../resources/app_resources.dart';
import '../../app_views.dart';
import 'base_platform_widget.dart';


class LoadingDialog extends BasePlatformWidget<WillPopScope, WillPopScope> {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  WillPopScope createCupertinoWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: CupertinoAlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(radius: AppSize.s12.r),
            VerticalSpace(AppSize.s8.h),
            CustomText(L10n.tr(context).loading, color: AppColors.white),
          ],
        ),
      ),
    );
  }

  @override
  WillPopScope createMaterialWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            VerticalSpace(AppSize.s16.h),
            CustomText(L10n.tr(context).loading),
          ],
        ),
      ),
    );
  }
}
