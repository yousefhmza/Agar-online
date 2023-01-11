import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/categories_cubit.dart';
import 'package:agar_online/core/resources/app_resources.dart';
import 'package:agar_online/core/extensions/num_extensions.dart';
import 'package:agar_online/core/enum/category_type.dart';
import '../../cubit/categories_states.dart';
import '../../models/category_model.dart';
import '../../../../core/view/app_views.dart';
import '../components/category_image.dart';
import '../components/sub_category_component.dart';

class CategoryScreen extends StatefulWidget {
  final CategoryModel category;

  const CategoryScreen({required this.category, Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late final CategoriesCubit categoriesCubit;

  @override
  void initState() {
    categoriesCubit = BlocProvider.of<CategoriesCubit>(context);
    categoriesCubit.getSubcategories(widget.category.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: CustomText(widget.category.name, fontSize: FontSize.s18, fontWeight: FontWeightManager.medium),
      ),
      body: BlocBuilder<CategoriesCubit, CategoriesStates>(
        buildWhen: (prevState, state) => state.categoryType == CategoryType.subCategory,
        builder: (context, state) {
          if (state is GetCategoriesFailureState) {
            return ErrorComponent(
              errorMessage: state.failure.message,
              onRetry: () => categoriesCubit.getAllCategories(),
            );
          }

          if (state is GetCategoriesSuccessState) {
            return CustomScrollView(
              slivers: [
                VerticalSpace.sliver(AppSize.s32.h),
                CategoryImage(widget.category.image),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => SubCategoryComponent(state.items[index]),
                    childCount: state.items.length,
                  ),
                ),
              ],
            );
          }
          return const LoadingSpinner();
        },
      ),
    );
  }
}
