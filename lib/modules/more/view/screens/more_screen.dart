import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:agar_online/core/services/outsource_services.dart';
import 'package:agar_online/core/utils/constants.dart';
import 'package:agar_online/modules/favourites/cubits/favourites_cubit.dart';
import '../../../profile/cubits/profile_cubit.dart';
import '../../../profile/cubits/profile_states.dart';
import '../../../../core/utils/alerts.dart';
import '../../../../core/utils/globals.dart';
import '../../../auth/cubits/login_cubit/login_cubit.dart';
import '../../../auth/cubits/login_cubit/login_states.dart';
import '../../../home/cubits/home_cubit.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../config/localization/cubit/l10n_cubit.dart';
import '../../../../config/localization/cubit/l10n_states.dart';
import '../../../../config/routing/navigation_service.dart';
import '../../../../config/routing/routes.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../categories/cubit/categories_cubit.dart';
import '../../../layout/cubit/layout_cubit.dart';
import '../components/more_appbar.dart';
import '../components/options_container.dart';
import '../components/to_auth_redirection.dart';
import '../../../splash/cubit/splash_cubit.dart';

import '../../../../config/localization/l10n/l10n.dart';
import '../../models/option_model.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({Key? key}) : super(key: key);

  List<Option> options(BuildContext context) => [
        Option(
          title: L10n.tr(context).categories,
          onTap: () => NavigationService.push(context, Routes.allCategoriesScreen),
        ),
        Option(
          title: L10n.tr(context).myAds,
          onTap: () => invokeIfAuthenticated(
            context,
            callback: () => NavigationService.push(context, Routes.myAdsScreen),
          ),
        ),
        Option(
          title: L10n.tr(context).favourite,
          onTap: () => invokeIfAuthenticated(
            context,
            callback: () => NavigationService.push(context, Routes.favouritesScreen),
          ),
        ),
        Option(
          title: L10n.tr(context).helpCenter,
          onTap: () => invokeIfAuthenticated(
            context,
            callback: () => NavigationService.push(context, Routes.helpCenterScreen),
          ),
        ),
        Option(
          title: L10n.tr(context).privacyPolicy,
          onTap: () => OutsourceServices.launch(Constants.privacyPolicyUrl),
        ),
        Option(
          title: L10n.tr(context).arabic,
          onTap: () {},
          trailing: SizedBox(
            height: AppSize.s20.h,
            width: AppSize.s32.w,
            child: BlocBuilder<L10nCubit, L10nStates>(
              builder: (context, state) {
                return Switch.adaptive(
                  value: L10n.isAr(context),
                  activeColor: AppColors.primaryRed,
                  onChanged: (value) async {
                    await BlocProvider.of<L10nCubit>(context).setAppLocale(value);
                    BlocProvider.of<HomeCubit>(context).getHomeData();
                    BlocProvider.of<CategoriesCubit>(context).getAllCategories();
                    BlocProvider.of<SplashCubit>(context).getCurrentUser();
                  },
                );
              },
            ),
          ),
        ),
        if (BlocProvider.of<SplashCubit>(context).isAuthed)
          Option(
            title: L10n.tr(context).logout,
            trailing: const CustomIcon(Icons.logout, color: AppColors.primaryRed),
            onTap: () => Alerts.showAppDialog(
              context,
              title: L10n.tr(context).logoutConfirm,
              onConfirm: () => BlocProvider.of<LoginCubit>(context).logout(),
              confirmText: L10n.tr(context).logout,
            ),
          ),
      ];

  @override
  Widget build(BuildContext context) {
    final SplashCubit splashCubit = BlocProvider.of<SplashCubit>(context);
    return BlocListener<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is LogoutSuccessState) {
          Alerts.showToast(L10n.tr(context).logoutSuccess);
          BlocProvider.of<FavouritesCubit>(context).favouriteAds = null;
          BlocProvider.of<LayoutCubit>(context).setCurrentIndex(0);
        }
        if (state is LogoutFailureState) Alerts.showToast(state.failure.message);
      },
      child: Column(
        children: [
          MoreAppbar(isAuthed: splashCubit.isAuthed),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSize.s16.w),
              child: Column(
                children: [
                  BlocBuilder<ProfileCubit, ProfileStates>(
                    buildWhen: (prevState, state) => state is EditProfileSuccessState,
                    builder: (context, state) => CustomText(
                      splashCubit.isAuthed ? currentUser!.name : L10n.tr(context).welcome,
                      fontWeight: FontWeightManager.bold,
                      fontSize: FontSize.s20,
                    ),
                  ),
                  if (!splashCubit.isAuthed) VerticalSpace(AppSize.s16.h),
                  if (!splashCubit.isAuthed) const ToAuthRedirection(),
                  VerticalSpace(AppSize.s16.h),
                  OptionsContainer(options(context), isAuthed: splashCubit.isAuthed),
                  VerticalSpace(AppSize.s90.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
