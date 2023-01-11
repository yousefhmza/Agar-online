import 'package:agar_online/core/extensions/num_extensions.dart';
import 'package:agar_online/modules/advertisements/models/response/advertisement_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/localization/l10n/l10n.dart';
import '../../../../config/routing/navigation_service.dart';
import '../../../../config/routing/routes.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/services/outsource_services.dart';
import '../../../../core/utils/alerts.dart';
import '../../../../core/utils/globals.dart';
import '../../../../core/view/app_views.dart';
import '../../../block/cubits/block_cubit.dart';
import '../../../block/cubits/block_states.dart';

class AdDetailsActions extends StatelessWidget {
  final Advertisement ad;

  const AdDetailsActions(this.ad, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.p16.w),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              onPressed: () => OutsourceServices.launch("tel://+2${ad.adOwner.phoneNumber}"),
              child: const CustomIcon(Icons.call, color: AppColors.white, size: FontSize.s18),
            ),
          ),
          HorizontalSpace(AppSize.s16.w),
          Expanded(
            child: CustomButton(
              onPressed: () => OutsourceServices.launch("https://wa.me/+2${ad.adOwner.phoneNumber}"),
              color: AppColors.white,
              child: const CustomIcon(Icons.whatsapp, color: AppColors.green),
            ),
          ),
          HorizontalSpace(AppSize.s16.w),
          Expanded(
            child: CustomButton(
              onPressed: () => invokeIfAuthenticated(
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
              color: AppColors.white,
              child: const CustomIcon(Icons.chat, color: AppColors.grey),
            ),
          ),
          if (currentUser != null) HorizontalSpace(AppSize.s16.w),
          if (currentUser != null)
            BlocListener<BlockCubit, BlockStates>(
              listener: (context, state) {
                if (state is SetBlockLoadingState) Alerts.showLoadingDialog(context);
                if (state is SetBlockFailureState) {
                  NavigationService.goBack(context);
                  Alerts.showSnackBar(context, state.failure.message);
                }
                if (state is SetBlockSuccessState) {
                  NavigationService.goBack(context);
                  NavigationService.goBack(context);
                  Alerts.showToast(state.message);
                }
              },
              child: Expanded(
                child: CustomButton(
                  onPressed: () => Alerts.showAppDialog(
                    context,
                    title: L10n.tr(context).blockUser,
                    onConfirm: () => BlocProvider.of<BlockCubit>(context).blockUser(ad.adOwner.id),
                    confirmText: L10n.tr(context).confirm,
                  ),
                  color: AppColors.white,
                  child: const CustomIcon(Icons.block, color: AppColors.red),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
