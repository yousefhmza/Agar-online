import 'package:agar_online/core/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../cubits/ads_cubit/ads_states.dart';
import 'package:agar_online/core/utils/alerts.dart';
import 'package:agar_online/modules/advertisements/view/components/ad_details_actions.dart';
import 'package:agar_online/modules/advertisements/view/components/report_ad_component.dart';
import '../../cubits/ads_cubit/ads_cubit.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../config/localization/l10n/l10n.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../widgets/favourite_icon.dart';
import '../widgets/price_box.dart';
import '../widgets/release_date_widget.dart';
import '../widgets/ad_item.dart';

class AdDetailsScreen extends StatefulWidget {
  final int id;

  const AdDetailsScreen({required this.id, Key? key}) : super(key: key);

  @override
  State<AdDetailsScreen> createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  late final AdsCubit adsCubit;
  final PageController pageController = PageController();

  @override
  void initState() {
    adsCubit = BlocProvider.of<AdsCubit>(context);
    adsCubit.fetchAdDetails(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatusBar(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const CustomAppbar(),
        body: BlocBuilder<AdsCubit, AdsStates>(
          buildWhen: (prevState, state) =>
              state is GetAdDetailsSuccessState ||
              state is GetAdDetailsFailureState ||
              state is GetAdDetailsLoadingState,
          builder: (context, state) {
            if (state is GetAdDetailsFailureState) {
              return ErrorComponent(
                errorMessage: state.failure.message,
                onRetry: () => adsCubit.fetchAdDetails(widget.id),
              );
            }
            if (state is GetAdDetailsSuccessState) {
              return Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Card(
                      margin: EdgeInsets.zero,
                      elevation: AppSize.s4.h,
                      color: AppColors.white,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppSize.s32.r)),
                      ),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          PageView.builder(
                            itemBuilder: (context, index) => CustomNetworkImage(image: state.ad.images[index].image),
                            itemCount: state.ad.images.length,
                            controller: pageController,
                          ),
                          if (state.ad.images.isNotEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: AppPadding.p16.w, vertical: AppPadding.p8.h),
                              decoration: BoxDecoration(
                                color: AppColors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.vertical(top: Radius.circular(AppSize.s16.r)),
                              ),
                              child: SmoothPageIndicator(
                                controller: pageController,
                                count: state.ad.images.length,
                                effect: ColorTransitionEffect(
                                  activeDotColor: AppColors.white,
                                  dotWidth: AppSize.s8.w,
                                  dotHeight: AppSize.s8.w,
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(AppPadding.p16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomText(
                                  state.ad.name,
                                  fontSize: FontSize.s16,
                                  fontWeight: FontWeightManager.medium,
                                ),
                              ),
                              HorizontalSpace(AppSize.s8.w),
                              FavouriteIcon(ad: state.ad),
                              HorizontalSpace(AppSize.s8.w),
                              const CustomIcon(Icons.location_on, color: AppColors.primaryRed),
                              CustomText(
                                "${state.ad.city.name}, ${state.ad.cityArea.name}",
                                color: AppColors.primaryRed,
                              ),
                            ],
                          ),
                          VerticalSpace(AppSize.s16.h),
                          Row(
                            children: [
                              PriceBox(state.ad.price),
                              HorizontalSpace(AppSize.s8.w),
                              ReleaseDateWidget(createdAt: state.ad.createdAt),
                            ],
                          ),
                          VerticalSpace(AppSize.s16.h),
                          CustomText(L10n.tr(context).description, fontWeight: FontWeightManager.bold),
                          VerticalSpace(AppSize.s8.h),
                          CustomText(state.ad.description),
                          VerticalSpace(AppSize.s16.h),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CustomIcon(Icons.report, color: AppColors.red),
                              InkWell(
                                onTap: () => invokeIfAuthenticated(
                                  context,
                                  callback: () =>
                                      Alerts.showBottomSheet(context, child: ReportComponent(), expandable: false),
                                ),
                                child: CustomText(
                                  L10n.tr(context).reportAd,
                                  color: AppColors.red,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              HorizontalSpace(AppSize.s12.w),
                              const CustomIcon(Icons.report_problem, color: AppColors.red),
                              InkWell(
                                onTap: () => invokeIfAuthenticated(
                                  context,
                                  callback: () => Alerts.showBottomSheet(
                                    context,
                                    child: ReportComponent(advertiserId: state.ad.adOwner.id),
                                    expandable: false,
                                  ),
                                ),
                                child: CustomText(
                                  L10n.tr(context).reportUser,
                                  color: AppColors.red,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                          VerticalSpace(AppSize.s16.h),
                          CustomText(
                            L10n.tr(context).similarAds,
                            fontSize: FontSize.s16,
                            fontWeight: FontWeightManager.bold,
                          ),
                          VerticalSpace(AppSize.s16.h),
                          SizedBox(
                            height: deviceHeight * 0.35,
                            child: ListView.separated(
                              itemCount: state.ad.similarAds.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => AdItem(state.ad.similarAds[index], toRelated: true),
                              separatorBuilder: (context, index) => HorizontalSpace(AppSize.s16.w),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(flex: 1, child: AdDetailsActions(state.ad)),
                ],
              );
            }
            return const LoadingSpinner();
          },
        ),
      ),
    );
  }
}
