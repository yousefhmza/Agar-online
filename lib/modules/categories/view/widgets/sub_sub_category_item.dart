import '../../models/sub_sub_category_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../config/routing/navigation_service.dart';
import '../../../../config/routing/routes.dart';
import '../../../../core/extensions/num_extensions.dart';

class SubSubCategoryItem extends StatelessWidget {
  final int categoryId;
  final String subCategoryName;
  final SubSubCategory subSubCategory;
  final List<SubSubCategory> allSubSubCategories; // all sub-sub-categories in this sub category

  const SubSubCategoryItem(
    this.categoryId,
    this.subCategoryName,
    this.subSubCategory,
    this.allSubSubCategories, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => NavigationService.push(
        context,
        Routes.subSubCategoryScreen,
        arguments: {
          "category_id": categoryId,
          "sub_category_name": subCategoryName,
          "sub_sub_category": subSubCategory,
          "all_sub_sub_categories": allSubSubCategories
        },
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: AppSize.s90.w,
              width: AppSize.s90.w,
              clipBehavior: Clip.antiAlias,
              foregroundDecoration: const ShapeDecoration(shape: CircleBorder()),
              decoration: const ShapeDecoration(color: AppColors.white, shape: CircleBorder()),
              child: CustomNetworkImage(image: subSubCategory.image),
            ),
            VerticalSpace(AppSize.s8.h),
            SizedBox(
              width: AppSize.s48.w * 2,
              child: CustomText(
                subSubCategory.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
