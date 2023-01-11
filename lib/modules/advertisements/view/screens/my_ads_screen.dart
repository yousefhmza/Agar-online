import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/view/components/empty_component.dart';
import '../../cubits/ads_cubit/ads_cubit.dart';
import '../../cubits/ads_cubit/ads_states.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../config/localization/l10n/l10n.dart';
import '../widgets/my_ad_item.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({Key? key}) : super(key: key);

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  late final AdsCubit adsCubit;

  @override
  void initState() {
    adsCubit = BlocProvider.of<AdsCubit>(context);
    adsCubit.fetchMyAds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: CustomText(L10n.tr(context).myAds, fontSize: FontSize.s18, fontWeight: FontWeightManager.medium),
      ),
      body: BlocBuilder<AdsCubit, AdsStates>(
        buildWhen: (prevState, state) =>
            state is GetMyAdsFailureState ||
            state is GetMyAdsLoadingState ||
            state is GetMyAdsSuccessState ||
            state is DeleteAdSuccessState,
        builder: (context, state) {
          if (state is GetMyAdsFailureState) {
            return ErrorComponent(
              errorMessage: state.failure.message,
              onRetry: () => BlocProvider.of<AdsCubit>(context).fetchMyAds(),
            );
          }
          if (state is GetMyAdsLoadingState) return const LoadingSpinner();
          return adsCubit.myAds.isNotEmpty
              ? ListView.separated(
                  padding: EdgeInsets.all(AppPadding.p16.w),
                  itemBuilder: (context, index) => MyAdItem(adsCubit.myAds[index]),
                  separatorBuilder: (context, index) => VerticalSpace(AppSize.s16.h),
                  itemCount: adsCubit.myAds.length,
                )
              : EmptyComponent(text: L10n.tr(context).noMyAds);
        },
      ),
    );
  }
}
