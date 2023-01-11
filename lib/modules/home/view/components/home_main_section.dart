import 'package:agar_online/modules/categories/cubit/categories_cubit.dart';
import 'package:agar_online/modules/home/view/components/specific_category_ads.dart';
import 'package:agar_online/modules/home/view/components/top_slider_component.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routing/navigation_service.dart';
import '../../../../config/routing/routes.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../advertisements/view/widgets/ad_item.dart';
import '../../../categories/view/widgets/category_item.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../cubits/home_cubit.dart';
import '../../cubits/home_states.dart';
import '../widgets/slider_item.dart';
import '../../../../config/localization/l10n/l10n.dart';

class HomeMainSection extends StatefulWidget {
  final TabController tabController;

  const HomeMainSection({required this.tabController, Key? key}) : super(key: key);

  @override
  State<HomeMainSection> createState() => _HomeMainSectionState();
}

class _HomeMainSectionState extends State<HomeMainSection> {
  late final HomeCubit homeCubit;
  late final CategoriesCubit categoriesCubit;

  @override
  void initState() {
    homeCubit = BlocProvider.of<HomeCubit>(context);
    categoriesCubit = BlocProvider.of<CategoriesCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (prevState, state) =>
          state is GetHomeDataSuccessState || state is GetHomeDataFailureState || state is GetHomeDataLoadingState,
      builder: (context, state) {
        if (state is GetHomeDataFailureState) {
          return ErrorComponent(
            errorMessage: state.failure.message,
            onRetry: () => BlocProvider.of<HomeCubit>(context).getHomeData(),
          );
        }
        if (state is GetHomeDataLoadingState) return const LoadingSpinner();

        return SingleChildScrollView(
          child: Column(
            children: [
              VerticalSpace(AppSize.s16.h),
              TopSliderComponent(homeCubit.homeData.topSliders),
              VerticalSpace(AppSize.s16.h),
              TitleRow(
                title: L10n.tr(context).categories,
                onTap: () => NavigationService.push(context, Routes.allCategoriesScreen),
              ),
              VerticalSpace(AppSize.s16.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: AppPadding.p16.w),
                itemCount: homeCubit.homeData.categories.length,
                itemBuilder: (context, index) => CategoryItem(homeCubit.homeData.categories[index]),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.65,
                  mainAxisSpacing: AppSize.s8.h,
                  crossAxisSpacing: AppSize.s16.w,
                ),
              ),
              VerticalSpace(AppSize.s16.h),
              TitleRow(title: L10n.tr(context).featuredAds, onTap: () => widget.tabController.animateTo(1)),
              VerticalSpace(AppSize.s16.h),
              SizedBox(
                height: deviceHeight * 0.35,
                child: ListView.separated(
                  itemCount: homeCubit.homeData.featuredAds.length,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p16.w),
                  itemBuilder: (context, index) => AdItem(homeCubit.homeData.featuredAds[index]),
                  separatorBuilder: (context, index) => HorizontalSpace(AppSize.s16.w),
                ),
              ),
              VerticalSpace(AppSize.s32.h),
              TitleRow(
                title: L10n.tr(context).latestAds,
                onTap: () => NavigationService.push(context, Routes.latestAdsScreen),
              ),
              VerticalSpace(AppSize.s16.h),
              SizedBox(
                height: deviceHeight * 0.35,
                child: ListView.separated(
                  itemCount: homeCubit.homeData.latestAds.length,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p16.w),
                  itemBuilder: (context, index) => AdItem(homeCubit.homeData.latestAds[index]),
                  separatorBuilder: (context, index) => HorizontalSpace(AppSize.s16.w),
                ),
              ),
              VerticalSpace(AppSize.s32.h),
              SizedBox(
                height: deviceHeight * 0.24,
                width: deviceWidth,
                child: CarouselSlider.builder(
                  itemCount: homeCubit.homeData.bottomSliders.length,
                  itemBuilder: (context, index, pageViewIndex) => SliderItem(homeCubit.homeData.bottomSliders[index]),
                  options: CarouselOptions(autoPlay: true, viewportFraction: 1.0, autoPlayInterval: Time.t3000),
                ),
              ),
              VerticalSpace(AppSize.s16.h),
              SpecificCategoryAds(title: L10n.tr(context).cars, categoryId: 2, ads: homeCubit.homeData.cars),
              VerticalSpace(AppSize.s16.h),
              SpecificCategoryAds(
                title: L10n.tr(context).realEstate,
                categoryId: 3,
                ads: homeCubit.homeData.realEstate,
              ),
              VerticalSpace(AppSize.s100.h),
            ],
          ),
        );
      },
    );
  }
}
