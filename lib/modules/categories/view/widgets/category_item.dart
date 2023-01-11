import 'dart:math';
import 'package:flutter/material.dart';

import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../config/routing/navigation_service.dart';
import '../../../../config/routing/routes.dart';
import '../../models/category_model.dart';
import '../../../../core/extensions/num_extensions.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel category;

  const CategoryItem(this.category, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => NavigationService.push(context, Routes.categoryScreen, arguments: {"category": category}),
      child: Column(
        children: [
          Container(
            width: AppSize.s72.w,
            height: AppSize.s72.w,
            padding: EdgeInsets.all(AppPadding.p12.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSize.s8.r),
            ),
            child: Image.network(category.image, color: Colors.primaries[Random().nextInt(Colors.primaries.length)]),
          ),
          VerticalSpace(AppSize.s4.h),
          CustomText(
            category.name,
            maxLines: 2,
            height: AppSize.s1.h,
            overflow: TextOverflow.ellipsis,
            fontSize: FontSize.s10,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
