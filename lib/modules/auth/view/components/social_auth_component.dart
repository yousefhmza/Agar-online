import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:agar_online/config/localization/l10n/l10n.dart';
import 'package:agar_online/core/extensions/num_extensions.dart';
import 'package:agar_online/core/resources/app_resources.dart';
import 'package:agar_online/core/utils/alerts.dart';
import 'package:agar_online/core/view/app_views.dart';
import 'package:agar_online/modules/auth/cubits/social_auth_cubit/social_auth_cubit.dart';
import 'package:agar_online/modules/auth/cubits/social_auth_cubit/social_auth_states.dart';
import '../../../../config/routing/navigation_service.dart';
import '../../../../config/routing/routes.dart';
import '../../../favourites/cubits/favourites_cubit.dart';

class SocialAuthComponent extends StatelessWidget {
  const SocialAuthComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAuthCubit, SocialAuthStates>(
      listener: (context, state) {
        if (state is SocialAuthFailureState) Alerts.showSnackBar(context, state.failure.message);
        if (state is SocialAuthSuccessState) {
          BlocProvider.of<FavouritesCubit>(context).getFavouriteAds();
          NavigationService.pushReplacementAll(context, Routes.layoutScreen, arguments: {"from_signup": true});
        }
      },
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(L10n.tr(context).orContinueVia),
            VerticalSpace(AppSize.s8.h),
            state is SocialAuthLoadingState
                ? Padding(
                    padding: EdgeInsets.only(top: AppPadding.p12.h),
                    child: const LoadingSpinner(),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => BlocProvider.of<SocialAuthCubit>(context).facebookSignIn(),
                        child: Container(
                          padding: EdgeInsets.all(AppPadding.p8.w),
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.white),
                          child: Image.asset(AppImages.facebook, width: AppSize.s32.w, height: AppSize.s32.w),
                        ),
                      ),
                      HorizontalSpace(AppSize.s32.w),
                      GestureDetector(
                        onTap: () => BlocProvider.of<SocialAuthCubit>(context).googleSignIn(),
                        child: Container(
                          padding: EdgeInsets.all(AppPadding.p8.w),
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.white),
                          child: Image.asset(AppImages.google, width: AppSize.s32.w, height: AppSize.s32.w),
                        ),
                      ),
                    ],
                  ),
          ],
        );
      },
    );
  }
}
