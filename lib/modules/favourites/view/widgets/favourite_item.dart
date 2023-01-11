import '../../cubits/favourites_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../config/localization/l10n/l10n.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../advertisements/models/response/advertisement_model.dart';
import '../../../advertisements/view/widgets/favourite_icon.dart';
import '../../../advertisements/view/widgets/ad_type_box.dart';
import '../../../advertisements/view/widgets/price_box.dart';
import '../../../advertisements/view/widgets/release_date_widget.dart';

class FavouriteItem extends StatelessWidget {
  final Advertisement ad;
  final Animation<double> animation;

  const FavouriteItem(this.ad, {required this.animation, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      key: ValueKey(ad.id),
      sizeFactor: animation,
      child: Card(
        margin: EdgeInsets.only(bottom: AppPadding.p16.w),
        elevation: AppSize.s4.h,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s32.r)),
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
                      borderRadius: BorderRadius.circular(AppSize.s32.r),
                      child: CustomNetworkImage(image: ad.image, height: double.infinity, width: double.infinity),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppPadding.p8.w, vertical: AppPadding.p16.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FavouriteIcon(ad: ad, activeTap: false),
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
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      VerticalSpace(AppSize.s8.h),
                      PriceBox(ad.price),
                      VerticalSpace(AppSize.s8.h),
                      ReleaseDateWidget(createdAt: ad.createdAt),
                      const Spacer(),
                      InkWell(
                        onTap: () => BlocProvider.of<FavouritesCubit>(context).removeAdFromFavourites(ad.id),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const CustomIcon(Icons.delete, color: AppColors.grey),
                            HorizontalSpace(AppSize.s2.w),
                            CustomText(L10n.tr(context).remove, color: AppColors.grey),
                            HorizontalSpace(AppSize.s8.w),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
