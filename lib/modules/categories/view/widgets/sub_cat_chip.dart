import 'package:agar_online/core/extensions/num_extensions.dart';
import 'package:agar_online/modules/categories/models/sub_sub_category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../advertisements/cubits/ads_cubit/ads_cubit.dart';

class SubSubCatChip extends StatelessWidget {
  final SubSubCategory subSubCategory;
  final bool isSelected;
  final String title;

  const SubSubCatChip({
    required this.subSubCategory,
    required this.isSelected,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: AppPadding.p8.w),
      child: CustomButton(
        onPressed: () {
          BlocProvider.of<AdsCubit>(context).filterAdsBody.subSubCategoryId = subSubCategory.id;
          BlocProvider.of<AdsCubit>(context).fetchAdsBySubSubCategoryAndAdType();
        },
        color: isSelected ? null : AppColors.white,
        textColor: isSelected ? null : AppColors.black,
        child: CustomText(
          title,
          fontWeight: FontWeightManager.medium,
          color: isSelected ? AppColors.white : AppColors.black,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
