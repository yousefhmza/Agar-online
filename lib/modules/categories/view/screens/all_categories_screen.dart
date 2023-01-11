import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/categories_cubit.dart';
import '../../cubit/categories_states.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../config/localization/l10n/l10n.dart';
import '../widgets/category_item.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  late final CategoriesCubit _categoriesCubit;

  @override
  void initState() {
    _categoriesCubit = BlocProvider.of<CategoriesCubit>(context);
    if (_categoriesCubit.categories.isEmpty) _categoriesCubit.getAllCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: CustomText(L10n.tr(context).categories, fontSize: FontSize.s18, fontWeight: FontWeightManager.medium),
      ),
      body: BlocBuilder<CategoriesCubit, CategoriesStates>(
        buildWhen: (prevState, state) =>
            state is GetCategoriesFailureState ||
            state is GetCategoriesSuccessState ||
            state is GetCategoriesLoadingState,
        builder: (context, state) {
          if (state is GetCategoriesFailureState) {
            return ErrorComponent(
              errorMessage: state.failure.message,
              onRetry: () => _categoriesCubit.getAllCategories(),
            );
          }
          if (state is GetCategoriesLoadingState) return const LoadingSpinner();

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(AppPadding.p16.w),
            itemCount: _categoriesCubit.categories.length,
            itemBuilder: (context, index) => CategoryItem(_categoriesCubit.categories[index]),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.65,
              mainAxisSpacing: AppSize.s8.h,
              crossAxisSpacing: AppSize.s16.w,
            ),
          );
        },
      ),
    );
  }
}
