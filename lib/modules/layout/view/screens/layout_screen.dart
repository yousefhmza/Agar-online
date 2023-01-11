import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:agar_online/core/services/notifications/notification_fcm.dart';
import 'package:agar_online/modules/advertisements/cubits/add_ads_cubit/add_ads_cubit.dart';
import 'package:agar_online/modules/advertisements/cubits/add_ads_cubit/add_ads_states.dart';
import 'package:agar_online/core/utils/alerts.dart';
import 'package:agar_online/core/utils/globals.dart';
import '../../../advertisements/cubits/ads_cubit/ads_cubit.dart';
import '../../../advertisements/view/components/setting_dialog.dart';
import '../../../categories/cubit/categories_cubit.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../home/cubits/home_cubit.dart';
import '../components/fab.dart';
import '../widgets/active_icon.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../cubit/layout_cubit.dart';
import '../../cubit/layout_states.dart';
import '../../../../config/localization/l10n/l10n.dart';

class LayoutScreen extends StatefulWidget {
  final bool fromSignup;

  const LayoutScreen({required this.fromSignup, Key? key}) : super(key: key);

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  late final LayoutCubit layoutCubit;

  @override
  void initState() {
    layoutCubit = BlocProvider.of<LayoutCubit>(context);
    layoutCubit.setCurrentIndex(0);
    BlocProvider.of<HomeCubit>(context).getHomeData();
    BlocProvider.of<AdsCubit>(context).fetchFeaturedAds();
    BlocProvider.of<CategoriesCubit>(context).getAllCategories();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.fromSignup) {
        Alerts.showTransparentDialog(
          context,
          title: "${L10n.tr(context).welcome}, ${currentUser?.name}",
          autoPop: true,
        );
      }
      NotificationsFCM.handleNotificationsFromTermination();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddAdsCubit, AddAdsStates>(
          listener: (context, state) {
            if (state is GetAdSettingsFailureState) {
              Alerts.showActionSnackBar(
                context,
                message: state.failure.message,
                actionLabel: L10n.tr(context).retry,
                onActionPressed: () => BlocProvider.of<AddAdsCubit>(context).getAdSetting(),
              );
            }
            if (state is GetAdSettingsSuccessState) {
              showDialog(
                context: context,
                builder: (_) => SettingDialog(state.settingModel),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<LayoutCubit, LayoutStates>(
        buildWhen: (prevState, state) => state is LayoutSetIndexState,
        builder: (context, state) {
          return StatusBar(
            child: Scaffold(
              extendBody: true,
              // extendBodyBehindAppBar: true,
              body: layoutCubit.bottomTabsScreens[layoutCubit.currentIndex],
              bottomNavigationBar: SizedBox(
                height: AppSize.s90.h,
                child: Stack(
                  alignment: const FractionalOffset(0.5, 1.0),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSize.s24.r)),
                        boxShadow: [BoxShadow(color: AppColors.grey.withOpacity(0.5), blurRadius: 6)],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSize.s24.r)),
                        child: BottomNavigationBar(
                          currentIndex: layoutCubit.currentIndex,
                          onTap: layoutCubit.setCurrentIndex,
                          items: [
                            BottomNavigationBarItem(
                              label: L10n.tr(context).home,
                              icon: const CustomIcon(Icons.home, color: AppColors.grey),
                              activeIcon: const ActiveIcon(Icons.home),
                            ),
                            BottomNavigationBarItem(
                              label: L10n.tr(context).profile,
                              icon: const CustomIcon(Icons.account_circle, color: AppColors.grey),
                              activeIcon: const ActiveIcon(Icons.account_circle),
                            ),
                            const BottomNavigationBarItem(
                              label: "",
                              icon: CustomIcon(Icons.account_circle, color: AppColors.white),
                              activeIcon: CustomIcon(Icons.account_circle, color: AppColors.white),
                            ),
                            BottomNavigationBarItem(
                              label: L10n.tr(context).chat,
                              icon: const CustomIcon(Icons.message, color: AppColors.grey),
                              activeIcon: const ActiveIcon(Icons.message),
                            ),
                            BottomNavigationBarItem(
                              label: L10n.tr(context).more,
                              icon: const CustomIcon(Icons.more, color: AppColors.grey),
                              activeIcon: const ActiveIcon(Icons.more),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Positioned(top: 0, child: FAB()),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
