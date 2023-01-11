import 'package:agar_online/core/enum/category_type.dart';

import '../../../../core/enum/region_type.dart';
import '../../../categories/cubit/categories_cubit.dart';
import '../../../categories/cubit/categories_states.dart';
import '../../../regions/cubit/regions_cubit.dart';
import '../../../regions/cubit/regions_states.dart';
import '../../models/body/search_params_body.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/non_null_extensions.dart';
import '../../cubit/search_cubit.dart';
import '../../../../core/extensions/num_extensions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/localization/l10n/l10n.dart';
import '../../../../config/routing/navigation_service.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({Key? key}) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late final SearchCubit searchCubit;
  late final RegionsCubit regionsCubit;
  late final CategoriesCubit categoriesCubit;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    searchCubit = BlocProvider.of<SearchCubit>(context);
    regionsCubit = BlocProvider.of<RegionsCubit>(context);
    categoriesCubit = BlocProvider.of<CategoriesCubit>(context);
    if (categoriesCubit.categories.isEmpty) categoriesCubit.getAllCategories();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      regionsCubit.getCities();
      searchCubit.searchParamsBody.categoryId != null
          ? categoriesCubit.getSubcategories(searchCubit.searchParamsBody.categoryId!)
          : categoriesCubit.resetSubCategories();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(L10n.tr(context).filterBy, fontWeight: FontWeightManager.bold, fontSize: FontSize.s16),
              InkWell(
                onTap: () => setState(() => searchCubit.searchParamsBody = SearchParamsBody()),
                child: CustomText(L10n.tr(context).reset, color: AppColors.primaryRed),
              ),
            ],
          ),
          VerticalSpace(AppSize.s16.h),
          CustomText(
            L10n.tr(context).price,
            fontSize: FontSize.s16,
            fontWeight: FontWeightManager.medium,
            color: AppColors.primaryRed,
          ),
          VerticalSpace(AppSize.s8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextField(
                  initialValue: searchCubit.searchParamsBody.priceFrom,
                  hintText: L10n.tr(context).from,
                  onChanged: (value) => searchCubit.searchParamsBody.copyWith(priceFrom: value),
                ),
              ),
              HorizontalSpace(AppSize.s16.w),
              Expanded(
                child: CustomTextField(
                  initialValue: searchCubit.searchParamsBody.priceTo,
                  hintText: L10n.tr(context).to,
                  onChanged: (value) => searchCubit.searchParamsBody.copyWith(priceTo: value),
                  keyBoardType: TextInputType.number,
                  formatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) => int.tryParse(value.toString()).orZero <
                          int.tryParse(searchCubit.searchParamsBody.priceFrom.toString()).orZero
                      ? L10n.tr(context).priceToValidator
                      : null,
                ),
              ),
            ],
          ),
          VerticalSpace(AppSize.s16.h),
          CustomText(
            L10n.tr(context).city,
            fontSize: FontSize.s16,
            fontWeight: FontWeightManager.medium,
            color: AppColors.primaryRed,
          ),
          VerticalSpace(AppSize.s8.h),
          BlocBuilder<RegionsCubit, RegionsStates>(
            buildWhen: (_, state) => state.regionType == RegionType.city,
            builder: (context, state) {
              return CustomDropDownField<int?>(
                key: UniqueKey(),
                hintText: L10n.tr(context).city,
                value: searchCubit.searchParamsBody.cityId,
                iconSize: state is GetRegionLoadingState ? AppSize.s0 : AppSize.s24,
                hasLoadingSuffix: state is GetRegionLoadingState ? true : false,
                onChanged: (value) {
                  searchCubit.searchParamsBody.copyWith(cityId: value);
                  searchCubit.searchParamsBody.areaId = null;
                  regionsCubit.getCityAreas(searchCubit.searchParamsBody.cityId!);
                },
                items: List.generate(
                  state.regions.length,
                  (index) => DropdownMenuItem<int>(
                    value: state.regions[index].id,
                    child: CustomText(state.regions[index].name),
                  ),
                ),
              );
            },
          ),
          VerticalSpace(AppSize.s16.h),
          CustomText(
            L10n.tr(context).cityArea,
            fontSize: FontSize.s16,
            fontWeight: FontWeightManager.medium,
            color: AppColors.primaryRed,
          ),
          VerticalSpace(AppSize.s8.h),
          BlocBuilder<RegionsCubit, RegionsStates>(
            buildWhen: (_, state) => state.regionType == RegionType.cityArea,
            builder: (context, state) {
              return CustomDropDownField<int?>(
                key: UniqueKey(),
                hintText: L10n.tr(context).cityArea,
                value: searchCubit.searchParamsBody.areaId,
                iconSize: state is GetRegionLoadingState ? AppSize.s0 : AppSize.s24,
                hasLoadingSuffix: state is GetRegionLoadingState ? true : false,
                onChanged: (value) => searchCubit.searchParamsBody.copyWith(areaId: value),
                items: List.generate(
                  state.regions.length,
                  (index) => DropdownMenuItem<int>(
                    value: state.regions[index].id,
                    child: CustomText(state.regions[index].name),
                  ),
                ),
              );
            },
          ),
          VerticalSpace(AppSize.s16.h),
          CustomText(
            L10n.tr(context).category,
            fontSize: FontSize.s16,
            fontWeight: FontWeightManager.medium,
            color: AppColors.primaryRed,
          ),
          VerticalSpace(AppSize.s8.h),
          BlocBuilder<CategoriesCubit, CategoriesStates>(
            buildWhen: (_, state) => state.categoryType == CategoryType.category,
            builder: (context, state) {
              return CustomDropDownField<int?>(
                key: UniqueKey(),
                hintText: L10n.tr(context).category,
                value: searchCubit.searchParamsBody.categoryId,
                iconSize: state is GetCategoriesLoadingState ? AppSize.s0 : AppSize.s24,
                hasLoadingSuffix: state is GetCategoriesLoadingState ? true : false,
                onChanged: (value) {
                  searchCubit.searchParamsBody.copyWith(categoryId: value);
                  categoriesCubit.getSubcategories(searchCubit.searchParamsBody.categoryId!);
                },
                items: List.generate(
                  categoriesCubit.categories.length,
                  (index) => DropdownMenuItem<int>(
                    value: categoriesCubit.categories[index].id,
                    child: CustomText(categoriesCubit.categories[index].name),
                  ),
                ),
              );
            },
          ),
          VerticalSpace(AppSize.s16.h),
          CustomText(
            L10n.tr(context).subCategory,
            fontSize: FontSize.s16,
            fontWeight: FontWeightManager.medium,
            color: AppColors.primaryRed,
          ),
          VerticalSpace(AppSize.s8.h),
          BlocBuilder<CategoriesCubit, CategoriesStates>(
            buildWhen: (_, state) => state.categoryType == CategoryType.subCategory,
            builder: (context, state) {
              return CustomDropDownField<int?>(
                key: UniqueKey(),
                hintText: L10n.tr(context).subCategory,
                value: searchCubit.searchParamsBody.subCategoryId,
                iconSize: state is GetCategoriesLoadingState ? AppSize.s0 : AppSize.s24,
                hasLoadingSuffix: state is GetCategoriesLoadingState ? true : false,
                onChanged: (value) => searchCubit.searchParamsBody.copyWith(subCategoryId: value),
                items: state is GetCategoriesSuccessState
                    ? List.generate(
                        state.items.length,
                        (index) => DropdownMenuItem<int>(
                          value: state.items[index].id,
                          child: CustomText(state.items[index].name),
                        ),
                      )
                    : [],
              );
            },
          ),
          VerticalSpace(AppSize.s16.h),
          CustomButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                NavigationService.goBack(context);
                searchCubit.getSearch();
              }
            },
            text: L10n.tr(context).search,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
