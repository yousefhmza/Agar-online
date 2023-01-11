import 'package:flutter/material.dart';

import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../core/extensions/num_extensions.dart';

class CategoryImage extends StatelessWidget {
  final String image;

  const CategoryImage(this.image, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Card(
        elevation: AppSize.s4.h,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s16.r),
        ),
        margin: EdgeInsets.all(AppPadding.p16.w).copyWith(top: AppSize.s0),
        child: Padding(
          padding: EdgeInsets.all(AppPadding.p8.w),
          child:
              CustomNetworkImage(width: double.infinity, height: AppSize.s125.h, image: image, fit: BoxFit.fitHeight),
        ),
      ),
    );
  }
}
