import 'dart:async';


import '../../../../core/utils/globals.dart';
import '../../../favourites/cubits/favourites_cubit.dart';
import '../../../favourites/cubits/favourites_states.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/localization/l10n/l10n.dart';
import '../../cubit/splash_states.dart';
import '../../../../config/routing/navigation_service.dart';
import '../../../../config/routing/routes.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/services/error/error_handler.dart';
import '../../../../core/utils/alerts.dart';
import '../../../../core/view/app_views.dart';
import '../../cubit/splash_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SplashCubit splashCubit;
  late final FavouritesCubit favouritesCubit;
  StreamSubscription<ConnectivityResult>? _connectivityResult;

  @override
  void initState() {
    splashCubit = BlocProvider.of<SplashCubit>(context);
    favouritesCubit = BlocProvider.of<FavouritesCubit>(context);
    Future.delayed(
      Time.t4000,
      () async {
        final result = await Connectivity().checkConnectivity();
        if (result != ConnectivityResult.none) {
          fetchAndRedirect();
        } else {
          Alerts.showToast(ErrorType.noInternetConnection.getFailure().message);
          _connectivityResult = Connectivity().onConnectivityChanged.listen((result) {
            bool isConnected = (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi);
            if (isConnected) {
              Alerts.showToast(L10n.tr(context).connected);
              fetchAndRedirect();
            } else {
              Alerts.showToast(ErrorType.noInternetConnection.getFailure().message);
            }
          });
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _connectivityResult?.cancel();
  }

  Future<void> fetchAndRedirect() async {
    if (splashCubit.isAuthed) {
      splashCubit.getCurrentUser();
      favouritesCubit.getFavouriteAds();
    } else {
      NavigationService.pushReplacementAll(context, Routes.layoutScreen, arguments: {"from_signup": false});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SplashCubit, SplashStates>(
          listener: (context, state) async {
            if (state is GetCurrentUserSuccessState && currentUser != null && favouritesCubit.favouriteAds != null) {
              NavigationService.pushReplacement(context, Routes.layoutScreen, arguments: {"from_signup": false});
            }
            if (state is GetCurrentUserFailureState) {
              Alerts.showActionSnackBar(
                context,
                actionLabel: L10n.tr(context).retry,
                onActionPressed: () => fetchAndRedirect(),
                message: state.failure.message,
              );
            }
          },
        ),
        BlocListener<FavouritesCubit, FavouritesStates>(
          listener: (context, state) async {
            if (state is GetFavouritesSuccessState && currentUser != null && favouritesCubit.favouriteAds != null) {
              NavigationService.pushReplacement(context, Routes.layoutScreen, arguments: {"from_signup": false});
            }
            if (state is GetFavouritesFailureState) {
              Alerts.showActionSnackBar(
                context,
                actionLabel: L10n.tr(context).retry,
                onActionPressed: () => fetchAndRedirect(),
                message: state.failure.message,
              );
            }
          },
        ),
      ],
      child: StatusBar(
        isLight: true,
        child: Scaffold(
          backgroundColor: AppColors.violet,
          body: Stack(
            children: [
              Center(child: Image.asset(AppImages.violetLogoAnimation, width: AppSize.s250.w, height: AppSize.s250.w)),
              Align(
                alignment: Alignment.bottomCenter,
                child: BlocBuilder<FavouritesCubit, FavouritesStates>(
                  builder: (context, favouritesState) {
                    return BlocBuilder<SplashCubit, SplashStates>(
                      builder: (context, splashState) {
                        return splashState is GetCurrentUserLoadingState || favouritesState is GetFavouritesLoadingState
                            ? Padding(
                                padding: EdgeInsets.all(AppPadding.p16.w),
                                child: SizedBox(
                                  width: AppSize.s24.r,
                                  height: AppSize.s24.r,
                                  child: CircularProgressIndicator(color: AppColors.white, strokeWidth: AppSize.s3.w),
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
