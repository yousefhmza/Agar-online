import '../../../../config/localization/l10n/l10n.dart';
import '../../../categories/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../cubits/ads_cubit/ads_cubit.dart';

class FeaturedAdChip extends StatelessWidget {
  final bool isSelected;
  final CategoryModel? category;
  final VoidCallback? onPressed;

  const FeaturedAdChip(
      {required this.isSelected,
      required this.category,
      this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomButton(
        onPressed: onPressed ??
            () =>
                BlocProvider.of<AdsCubit>(context).filterFeaturedAds(category),
        color: isSelected ? null : AppColors.white,
        textColor: isSelected ? null : AppColors.black,
        child: CustomText(
          category?.name ?? L10n.tr(context).all,
          fontWeight: FontWeightManager.medium,
          color: isSelected ? AppColors.white : AppColors.black,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
