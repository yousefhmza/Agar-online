import '../../../../core/view/components/empty_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/num_extensions.dart';
import '../../cubits/favourites_cubit.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/utils/alerts.dart';
import '../../../../core/view/app_views.dart';
import '../../cubits/favourites_states.dart';
import '../widgets/favourite_item.dart';
import '../../../../config/localization/l10n/l10n.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  late final FavouritesCubit favouritesCubit;

  @override
  void initState() {
    favouritesCubit = BlocProvider.of<FavouritesCubit>(context);
    favouritesCubit.getFavouriteAds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: CustomText(L10n.tr(context).favourite, fontSize: FontSize.s18, fontWeight: FontWeightManager.medium),
      ),
      body: BlocConsumer<FavouritesCubit, FavouritesStates>(
        listener: (context, state) {
          if (state is EditFavouriteFailureState) Alerts.showSnackBar(context, state.failure.message);
        },
        buildWhen: (prevState, state) =>
            state is GetFavouritesLoadingState ||
            state is GetFavouritesFailureState ||
            state is GetFavouritesSuccessState ||
            state is EditFavouriteSuccessState && favouritesCubit.favouriteAds!.isEmpty,
        builder: (context, state) {
          if (state is GetFavouritesLoadingState) return const LoadingSpinner();
          if (state is GetFavouritesFailureState) {
            return ErrorComponent(
              errorMessage: state.failure.message,
              onRetry: () => favouritesCubit.getFavouriteAds(),
            );
          }
          return favouritesCubit.favouriteAds!.isNotEmpty
              ? AnimatedList(
                  key: favouritesCubit.animatedListKey,
                  padding: EdgeInsets.all(AppPadding.p16.w),
                  initialItemCount: favouritesCubit.favouriteAds!.length,
                  itemBuilder: (context, index, animation) => FavouriteItem(
                    favouritesCubit.favouriteAds![index],
                    animation: animation,
                  ),
                )
              : EmptyComponent(text: L10n.tr(context).noFavouriteAdsYet);
        },
      ),
    );
  }
}
