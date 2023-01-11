import '../../../../config/routing/navigation_service.dart';
import '../../../../core/utils/alerts.dart';
import '../../cubits/ads_cubit/ads_cubit.dart';
import '../../cubits/ads_cubit/ads_states.dart';
import 'ad_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routing/routes.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import 'ad_type_box.dart';
import 'price_box.dart';
import 'release_date_widget.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../models/response/advertisement_model.dart';
import '../../../../config/localization/l10n/l10n.dart';

class MyAdItem extends StatelessWidget {
  final Advertisement ad;

  const MyAdItem(this.ad, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdsCubit adsCubit = BlocProvider.of<AdsCubit>(context);
    return Card(
      margin: EdgeInsets.zero,
      elevation: AppSize.s4.h,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s24.r)),
      clipBehavior: Clip.antiAlias,
      color: AppColors.white,
      child: SizedBox(
        height: deviceHeight * 0.21,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.s24.r),
                    child: CustomNetworkImage(image: ad.image, height: double.infinity, width: double.infinity),
                  ),
                  Container(
                    padding: EdgeInsets.all(AppPadding.p8.w),
                    height: AppSize.s64.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BlocConsumer<AdsCubit, AdsStates>(
                          listenWhen: (prevState, state) => state is DeleteAdFailureState && state.adId == ad.id,
                          listener: (context, state) {
                            if (state is DeleteAdFailureState) {
                              Alerts.showActionSnackBar(
                                context,
                                message: state.failure.message,
                                actionLabel: L10n.tr(context).retry,
                                onActionPressed: () => adsCubit.deleteAd(ad.id),
                              );
                            }
                          },
                          builder: (context, state) {
                            return state is DeleteAdLoadingState && state.adId == ad.id
                                ? const LoadingSpinner(hasSmallRadius: true)
                                : InkWell(
                                    onTap: () => Alerts.showAppDialog(
                                      context,
                                      title: L10n.tr(context).deleteConfirmation,
                                      confirmText: L10n.tr(context).delete,
                                      onConfirm: () => adsCubit.deleteAd(ad.id),
                                    ),
                                    child: const CustomIcon(Icons.delete, color: AppColors.red),
                                  );
                          },
                        ),
                        HorizontalSpace(AppSize.s8.w),
                        if (ad.adType.name.isNotEmpty) Expanded(child: AdTypeBox(ad.adType.name)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(AppPadding.p8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      ad.name,
                      fontWeight: FontWeightManager.medium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    VerticalSpace(AppSize.s8.h),
                    PriceBox(ad.price),
                    VerticalSpace(AppSize.s8.h),
                    ReleaseDateWidget(createdAt: ad.createdAt),
                    VerticalSpace(AppSize.s8.h),
                    const Spacer(),
                    Row(
                      children: [
                        const CustomIcon(Icons.edit, color: AppColors.primaryRed, size: AppSize.s18),
                        HorizontalSpace(AppSize.s4.w),
                        InkWell(
                          onTap: () => NavigationService.push(context, Routes.editAdScreen, arguments: {"ad": ad}),
                          child: CustomText(L10n.tr(context).edit, color: AppColors.primaryRed),
                        ),
                        const Spacer(),
                        AdStatusWidget(isApproved: ad.isApproved),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
