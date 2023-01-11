import 'package:agar_online/core/extensions/num_extensions.dart';
import 'package:agar_online/modules/categories/cubit/categories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routing/navigation_service.dart';
import '../../../../config/routing/routes.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../advertisements/models/response/advertisement_model.dart';
import '../../../advertisements/view/widgets/ad_item.dart';

class SpecificCategoryAds extends StatelessWidget {
  final String title;
  final int categoryId;
  final List<Advertisement> ads;

  const SpecificCategoryAds({
    required this.title,
    required this.categoryId,
    required this.ads,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CategoriesCubit categoriesCubit = BlocProvider.of<CategoriesCubit>(context);
    return Column(
      children: [
        TitleRow(
          title: title,
          onTap: () {
            if (categoriesCubit.categories.any((category) => category.id == categoryId)) {
              NavigationService.push(
                context,
                Routes.categoryScreen,
                arguments: {"category": categoriesCubit.categories.firstWhere((category) => category.id == categoryId)},
              );
            }
          },
        ),
        VerticalSpace(AppSize.s16.h),
        SizedBox(
          height: deviceHeight * 0.35,
          child: ListView.separated(
            itemCount: ads.length,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppPadding.p16.w),
            itemBuilder: (context, index) => AdItem(ads[index]),
            separatorBuilder: (context, index) => HorizontalSpace(AppSize.s16.w),
          ),
        ),
      ],
    );
  }
}
