import 'package:flutter/material.dart';

import '../../../../core/extensions/num_extensions.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../widgets/sub_sub_category_item.dart';
import '../widgets/subcategory_title.dart';

class SubCategoryComponent extends StatelessWidget {
  final dynamic subcategory;

  const SubCategoryComponent(this.subcategory, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return subcategory.subSubCategories.length != 0
        ? SizedBox(
            height: AppSize.s200.h,
            child: Column(
              children: [
                SubcategoryTitle(subcategory.name),
                Expanded(
                  child: ListView.separated(
                    itemCount: subcategory.subSubCategories.length,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p16.w),
                    itemBuilder: (context, index) => SubSubCategoryItem(
                      subcategory.categoryId,
                      subcategory.name,
                      subcategory.subSubCategories[index],
                      subcategory.subSubCategories,
                    ),
                    separatorBuilder: (context, index) => HorizontalSpace(AppSize.s16.w),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
