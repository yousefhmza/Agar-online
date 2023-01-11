import '../../../../core/extensions/num_extensions.dart';
import '../../../../core/view/app_views.dart';
import '../../cubits/ads_cubit/ads_cubit.dart';
import '../../cubits/ads_cubit/ads_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/localization/l10n/l10n.dart';
import '../../../../core/resources/font_manager.dart';
import '../../../../core/resources/values_manager.dart';
import '../widgets/ad_item.dart';

class LatestAdsScreen extends StatefulWidget {
  const LatestAdsScreen({Key? key}) : super(key: key);

  @override
  State<LatestAdsScreen> createState() => _LatestAdsScreenState();
}

class _LatestAdsScreenState extends State<LatestAdsScreen> {
  late final AdsCubit adsCubit;

  @override
  void initState() {
    adsCubit = BlocProvider.of<AdsCubit>(context);
    adsCubit.fetchLatestAds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: CustomText(L10n.tr(context).latestAds,
            fontSize: FontSize.s18, fontWeight: FontWeightManager.medium),
      ),
      body: BlocBuilder<AdsCubit, AdsStates>(
        buildWhen: (_, state) =>
            state is GetLatestAdsFailureState ||
            state is GetLatestAdsSuccessState ||
            state is GetLatestAdsLoadingState,
        builder: (context, state) {
          if (state is GetLatestAdsFailureState) {
            return ErrorComponent(
                errorMessage: state.failure.message,
                onRetry: () => adsCubit.fetchLatestAds());
          }
          if (state is GetLatestAdsSuccessState) {
            return GridView.builder(
              padding: EdgeInsets.all(AppPadding.p16.w),
              itemCount: state.ads.length,
              itemBuilder: (context, index) => AdItem(state.ads[index]),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSize.s8.w,
                mainAxisSpacing: AppSize.s16.w,
                childAspectRatio: 0.65,
              ),
            );
          }
          return const LoadingSpinner();
        },
      ),
    );
  }
}
