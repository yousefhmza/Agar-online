import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/globals.dart';
import '../../models/response/advertisement_model.dart';
import '../../../favourites/cubits/favourites_cubit.dart';
import '../../../favourites/cubits/favourites_states.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../core/extensions/num_extensions.dart';

class FavouriteIcon extends StatelessWidget {
  final Advertisement ad;
  final bool activeTap;

  const FavouriteIcon({required this.ad, this.activeTap = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavouritesCubit, FavouritesStates>(
      buildWhen: (prevState, state) =>
          state is EditFavouriteLoadingState ||
          state is EditFavouriteSuccessState ||
          state is EditFavouriteFailureState,
      builder: (context, state) {
        return InkWell(
          onTap: activeTap
              ? () => invokeIfAuthenticated(
                    context,
                    callback: () => BlocProvider.of<FavouritesCubit>(context).editFavourite(ad),
                  )
              : () {},
          child: Container(
            padding: EdgeInsets.all(AppPadding.p4.w),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.white),
            child: CustomIcon(
              ad.isFavourite ? Icons.favorite : Icons.favorite_outline,
              color: AppColors.red,
              size: AppSize.s20,
            ),
          ),
        );
      },
    );
  }
}
