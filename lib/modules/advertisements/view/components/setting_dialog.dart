import 'package:agar_online/config/localization/l10n/l10n.dart';
import 'package:agar_online/config/routing/navigation_service.dart';
import 'package:agar_online/core/extensions/num_extensions.dart';
import 'package:agar_online/core/resources/app_resources.dart';
import 'package:agar_online/core/view/app_views.dart';
import 'package:agar_online/modules/advertisements/models/response/setting_model.dart';
import 'package:flutter/material.dart';

class SettingDialog extends StatelessWidget {
  final SettingModel settingModel;

  const SettingDialog(this.settingModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s24.r),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(AppImages.vodCash, width: AppSize.s100.w, height: AppSize.s100.h),
          CustomText(
            L10n.tr(context).settingText(settingModel.vodafoneCashNumber, settingModel.cost),
            fontWeight: FontWeightManager.bold,
            fontSize: FontSize.s16,
            textAlign: TextAlign.center,
          ),
          VerticalSpace(AppSize.s16.h),
          CustomButton(
            width: double.infinity,
            text: L10n.tr(context).confirm,
            onPressed: () => NavigationService.goBack(context),
          )
        ],
      ),
    );
  }
}
