import '../../../../core/extensions/num_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../config/localization/l10n/l10n.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';

class AdStatusWidget extends StatelessWidget {
  final bool isApproved;

  const AdStatusWidget({required this.isApproved, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isApproved
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomIcon(Icons.check_circle,
                  color: AppColors.green, size: AppSize.s18),
              HorizontalSpace(AppSize.s4.w),
              CustomText(L10n.tr(context).accepted, color: AppColors.green)
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomIcon(Icons.lock_clock,
                  color: AppColors.pending, size: AppSize.s18),
              HorizontalSpace(AppSize.s4.w),
              CustomText(L10n.tr(context).pending, color: AppColors.pending)
            ],
          );
  }
}
