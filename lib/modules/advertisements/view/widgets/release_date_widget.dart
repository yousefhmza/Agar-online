import '../../../../config/localization/l10n/l10n.dart';
import 'package:flutter/material.dart';

import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../core/extensions/num_extensions.dart';

class ReleaseDateWidget extends StatelessWidget {
  final DateTime createdAt;

  const ReleaseDateWidget({required this.createdAt, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(createdAt.toString());
    return Row(
      children: [
        const CustomIcon(Icons.access_time,
            size: AppSize.s16, color: AppColors.grey),
        HorizontalSpace(AppSize.s4.w),
        CustomText(
            "${DateTime.now().difference(createdAt).inDays} ${L10n.tr(context).days}",
            color: AppColors.grey),
      ],
    );
  }
}
