import 'package:flutter/material.dart';

import '../../../../config/localization/l10n/l10n.dart';
import '../../../../core/view/components/empty_component.dart';
import '../../../categories/cubit/categories_cubit.dart';
import '../../../categories/cubit/categories_states.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../cubits/ads_cubit/ads_cubit.dart';
import '../../cubits/ads_cubit/ads_states.dart';
import '../widgets/featured_ad_chip.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../widgets/ad_item.dart';

class FeaturedAds extends StatelessWidget {
  const FeaturedAds({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdsCubit adsCubit = BlocProvider.of<AdsCubit>(context);
    final CategoriesCubit categoriesCubit = BlocProvider.of<CategoriesCubit>(context);
    return BlocBuilder<AdsCubit, AdsStates>(
      buildWhen: (prevState, state) =>
          state is GetFeaturedAdsLoadingState ||
          state is GetFeaturedAdsSuccessState ||
          state is GetFeaturedAdsFailureState,
      builder: (context, state) {
        if (state is GetFeaturedAdsFailureState) {
          return ErrorComponent(
            errorMessage: state.failure.message,
            onRetry: () => BlocProvider.of<AdsCubit>(context).fetchFeaturedAds(),
          );
        }
        if (state is GetFeaturedAdsLoadingState) return const LoadingSpinner();
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: AppSize.s86.h,
                child: BlocBuilder<CategoriesCubit, CategoriesStates>(
                  builder: (context, state) => state is GetCategoriesLoadingState
                      ? const LoadingSpinner()
                      : ListView.separated(
                          itemCount: categoriesCubit.categories.length + 1,
                          padding: EdgeInsets.symmetric(horizontal: AppSize.s8.w),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => index == 0
                              ? FeaturedAdChip(isSelected: adsCubit.selectedCategory == null, category: null)
                              : FeaturedAdChip(
                                  isSelected: adsCubit.selectedCategory?.id == categoriesCubit.categories[index - 1].id,
                                  category: categoriesCubit.categories[index - 1],
                                ),
                          separatorBuilder: (context, index) => HorizontalSpace(AppSize.s8.w),
                        ),
                ),
              ),
            ),
            adsCubit.filteredAds.isEmpty
                ? SliverToBoxAdapter(child: EmptyComponent(text: L10n.tr(context).emptyFeaturedAds))
                : SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p8.w),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        childCount: adsCubit.filteredAds.length,
                        (context, index) => AdItem(adsCubit.filteredAds[index]),
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppSize.s8.w,
                        mainAxisSpacing: AppSize.s16.w,
                        childAspectRatio: 0.65,
                      ),
                    ),
                  ),
            VerticalSpace.sliver(AppSize.s100.h),
          ],
        );
      },
    );
  }
}
