import 'package:agar_online/core/enum/category_type.dart';
import 'package:agar_online/core/extensions/num_extensions.dart';
import 'package:agar_online/modules/advertisements/view/widgets/category_drop_down_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:agar_online/modules/categories/cubit/categories_cubit.dart';
import '../../../../config/localization/l10n/l10n.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../ad_type/cubit/ad_type_cubit.dart';
import '../../cubits/edit_ad_cubit/edit_ad_cubit.dart';

class EditCategoriesComponent extends StatefulWidget {
  const EditCategoriesComponent({Key? key}) : super(key: key);

  @override
  State<EditCategoriesComponent> createState() => _EditCategoriesComponentState();
}

class _EditCategoriesComponentState extends State<EditCategoriesComponent> {
  late final EditAdCubit editAdCubit;
  late final CategoriesCubit categoriesCubit;
  late final AdTypesCubit adTypesCubit;


  @override
  void initState() {
    editAdCubit = BlocProvider.of<EditAdCubit>(context);
    categoriesCubit = BlocProvider.of<CategoriesCubit>(context);
    adTypesCubit = BlocProvider.of<AdTypesCubit>(context);
    categoriesCubit.getAllCategories();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (editAdCubit.editAdBody!.categoryId != null) {
        categoriesCubit.getSubcategories(editAdCubit.editAdBody!.categoryId!);
      }
      if (editAdCubit.editAdBody!.categoryId != null && editAdCubit.editAdBody!.subCategoryId != null) {
        categoriesCubit.getSubSubcategories(editAdCubit.editAdBody!.subCategoryId!);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final EditAdCubit editAdCubit = BlocProvider.of<EditAdCubit>(context);
    return Column(
      children: [
        CategoriesDropDownField(
          categoryType: CategoryType.category,
          failureMessage: L10n.tr(context).getCategoriesFailure,
          retryAction: () => categoriesCubit.getAllCategories(),
          value: categoriesCubit.categories.isNotEmpty ? editAdCubit.editAdBody!.categoryId : null,
          hintText: L10n.tr(context).category,
          onChanged: (value) {
            editAdCubit.editAdBody!.subCategoryId = null;
            editAdCubit.editAdBody!.subSubCategoryId = null;
            editAdCubit.editAdBody!.adTypeId = null;
            editAdCubit.editAdBody!.copyWith(categoryId: value);
            categoriesCubit.getSubcategories(editAdCubit.editAdBody!.categoryId!);
            categoriesCubit.resetSubSubCategories();
            adTypesCubit.getAdTypes(editAdCubit.editAdBody!.categoryId!);
          },
        ),
        VerticalSpace(AppSize.s16.h),
        CategoriesDropDownField(
          categoryType: CategoryType.subCategory,
          failureMessage: L10n.tr(context).getSubCategoriesFailure,
          retryAction: () => categoriesCubit.getSubcategories(editAdCubit.editAdBody!.categoryId!),
          value: editAdCubit.editAdBody!.subCategoryId,
          hintText: L10n.tr(context).subCategory,
          onChanged: (value) {
            editAdCubit.editAdBody!.subSubCategoryId = null;
            editAdCubit.editAdBody!.copyWith(subCategoryId: value);
            categoriesCubit.getSubSubcategories(editAdCubit.editAdBody!.subCategoryId!);
          },
        ),
        VerticalSpace(AppSize.s16.h),
        CategoriesDropDownField(
          categoryType: CategoryType.subSubCategory,
          failureMessage: L10n.tr(context).getSubSubCategoriesFailure,
          retryAction: () => categoriesCubit.getSubSubcategories(editAdCubit.editAdBody!.subCategoryId!),
          value: editAdCubit.editAdBody!.subSubCategoryId,
          hintText: L10n.tr(context).subSubCategory,
          onChanged: (value) => editAdCubit.editAdBody!.copyWith(subSubCategoryId: value),
        ),
      ],
    );
  }
}
