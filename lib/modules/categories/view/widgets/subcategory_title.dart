import 'package:flutter/material.dart';

import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../core/extensions/num_extensions.dart';

class SubcategoryTitle extends StatelessWidget {
  final String title;

  const SubcategoryTitle(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppPadding.p8.w),
      decoration: const ShapeDecoration(shape: StadiumBorder(), color: AppColors.white),
      child: CustomText(title, textAlign: TextAlign.center, fontSize: FontSize.s16,fontWeight: FontWeightManager.medium),
    );
  }
}
