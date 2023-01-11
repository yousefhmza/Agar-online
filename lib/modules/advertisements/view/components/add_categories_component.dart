import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:agar_online/modules/ad_type/cubit/ad_type_cubit.dart';
import 'package:agar_online/config/localization/l10n/l10n.dart';
import 'package:agar_online/core/enum/category_type.dart';
import 'package:agar_online/core/extensions/num_extensions.dart';
import 'package:agar_online/modules/advertisements/view/widgets/category_drop_down_field.dart';
import 'package:agar_online/modules/categories/cubit/categories_cubit.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../cubits/add_ads_cubit/add_ads_cubit.dart';

class AddCategoriesComponent extends StatefulWidget {
  const AddCategoriesComponent({Key? key}) : super(key: key);

  @override
  State<AddCategoriesComponent> createState() => _AddCategoriesComponentState();
}

class _AddCategoriesComponentState extends State<AddCategoriesComponent> {
  late final AddAdsCubit addAdsCubit;
  late final CategoriesCubit categoriesCubit;
  late final AdTypesCubit adTypesCubit;

  @override
  void initState() {
    addAdsCubit = BlocProvider.of<AddAdsCubit>(context);
    categoriesCubit = BlocProvider.of<CategoriesCubit>(context);
    adTypesCubit = BlocProvider.of<AdTypesCubit>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      categoriesCubit.resetSubCategories();
      categoriesCubit.resetSubSubCategories();
      categoriesCubit.getAllCategories();
      if (addAdsCubit.addAdBody.categoryId != null) categoriesCubit.getSubcategories(addAdsCubit.addAdBody.categoryId!);
      if (addAdsCubit.addAdBody.categoryId != null && addAdsCubit.addAdBody.subCategoryId != null) {
        categoriesCubit.getSubSubcategories(addAdsCubit.addAdBody.subCategoryId!);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CategoriesDropDownField(
          categoryType: CategoryType.category,
          failureMessage: L10n.tr(context).getCategoriesFailure,
          retryAction: () => categoriesCubit.getAllCategories(),
          value: addAdsCubit.addAdBody.categoryId,
          hintText: L10n.tr(context).category,
          onChanged: (value) {
            addAdsCubit.addAdBody.subCategoryId = null;
            addAdsCubit.addAdBody.subSubCategoryId = null;
            addAdsCubit.addAdBody.adTypeId = null;
            addAdsCubit.addAdBody.copyWith(categoryId: value);
            categoriesCubit.getSubcategories(addAdsCubit.addAdBody.categoryId!);
            categoriesCubit.resetSubSubCategories();
            adTypesCubit.getAdTypes(addAdsCubit.addAdBody.categoryId!);
          },
        ),
        VerticalSpace(AppSize.s16.h),
        CategoriesDropDownField(
          categoryType: CategoryType.subCategory,
          failureMessage: L10n.tr(context).getSubCategoriesFailure,
          retryAction: () => categoriesCubit.getSubcategories(addAdsCubit.addAdBody.categoryId!),
          value: addAdsCubit.addAdBody.subCategoryId,
          hintText: L10n.tr(context).subCategory,
          onChanged: (value) {
            addAdsCubit.addAdBody.subSubCategoryId = null;
            addAdsCubit.addAdBody.copyWith(subCategoryId: value);
            categoriesCubit.getSubSubcategories(addAdsCubit.addAdBody.subCategoryId!);
          },
        ),
        VerticalSpace(AppSize.s16.h),
        CategoriesDropDownField(
          categoryType: CategoryType.subSubCategory,
          failureMessage: L10n.tr(context).getSubSubCategoriesFailure,
          retryAction: () => categoriesCubit.getSubSubcategories(addAdsCubit.addAdBody.subCategoryId!),
          value: addAdsCubit.addAdBody.subSubCategoryId,
          hintText: L10n.tr(context).subSubCategory,
          onChanged: (value) => addAdsCubit.addAdBody.copyWith(subSubCategoryId: value),
        ),
      ],
    );
  }
}
