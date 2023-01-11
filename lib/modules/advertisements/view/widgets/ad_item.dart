import 'package:agar_online/core/utils/globals.dart';

import '../../../../core/services/outsource_services.dart';
import 'package:flutter/material.dart';

import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../config/routing/navigation_service.dart';
import '../../../../config/routing/routes.dart';
import 'price_box.dart';
import '../../../../core/extensions/num_extensions.dart';
import 'ad_action.dart';
import '../../models/response/advertisement_model.dart';

class AdItem extends StatelessWidget {
  final Advertisement ad;
  final bool toRelated;

  const AdItem(this.ad, {this.toRelated = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toRelated
          ? () => NavigationService.pushReplacement(context, Routes.adDetailsScreen, arguments: {"id": ad.id})
          : () => NavigationService.push(context, Routes.adDetailsScreen, arguments: {"id": ad.id}),
      child: Container(
        width: deviceWidth * 0.45,
        clipBehavior: Clip.antiAlias,
        foregroundDecoration: BoxDecoration(
          border: Border.all(color: AppColors.grey.withOpacity(0.5), width: AppSize.s1_5.w),
          borderRadius: BorderRadius.circular(AppSize.s24.r),
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSize.s24.r),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 6,
                  child: CustomNetworkImage(width: double.infinity, image: ad.image),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSize.s8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(ad.name, maxLines: 2, overflow: TextOverflow.ellipsis),
                        const Spacer(),
                        PriceBox(ad.price),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      if (ad.canContactByPhone)
                        AdAction(
                          icon: Icons.phone,
                          color: AppColors.deepBlue,
                          onTap: () => OutsourceServices.launch("tel://+2${ad.adOwner.phoneNumber}"),
                        ),
                      if (ad.canContactByPhone)
                        AdAction(
                          icon: Icons.whatsapp,
                          color: AppColors.green,
                          onTap: () => OutsourceServices.launch("https://wa.me/+2${ad.adOwner.phoneNumber}"),
                        ),
                      if (ad.canContactByChat)
                        AdAction(
                          icon: Icons.chat_outlined,
                          color: AppColors.red,
                          onTap: () => invokeIfAuthenticated(
                            context,
                            callback: () => NavigationService.push(
                              context,
                              Routes.chatScreen,
                              arguments: {
                                "other_user_id": ad.adOwner.id,
                                "other_user_image": ad.adOwner.image,
                                "other_user_name": ad.adOwner.firstName,
                                "ad_id": ad.id,
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(AppPadding.p12.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppPadding.p8.w, vertical: AppPadding.p4.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSize.s8.r),
                ),
                child: CustomText(ad.city.name),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
