import 'package:flutter/material.dart';

import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../core/extensions/num_extensions.dart';

class AdTypeBox extends StatelessWidget {
  final String type;

  const AdTypeBox(this.type, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s4.r),
        color: AppColors.grey.withOpacity(0.5),
      ),
      padding: EdgeInsets.symmetric(vertical: AppPadding.p4.w, horizontal: AppPadding.p8.w),
      child: CustomText(
        type,
        fontSize: FontSize.s12,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        color: AppColors.white,
      ),
    );
  }
}
