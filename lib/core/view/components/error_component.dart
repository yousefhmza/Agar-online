import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../config/localization/l10n/l10n.dart';
import '../../extensions/num_extensions.dart';
import '../../resources/app_resources.dart';
import '../app_views.dart';

class ErrorComponent extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorComponent({required this.errorMessage, required this.onRetry, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(AppJson.errorLottie, width: deviceWidth * 0.5, height: deviceWidth * 0.5, fit: BoxFit.cover),
          CustomText(errorMessage, textAlign: TextAlign.center),
          VerticalSpace(AppSize.s32.h),
          CustomButton(
            onPressed: onRetry,
            child: CustomText(L10n.tr(context).retry, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
