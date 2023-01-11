import 'package:agar_online/core/services/outsource_services.dart';

import '../../models/slider_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/num_extensions.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';

class SliderItem extends StatelessWidget {
  final SliderModel slider;

  const SliderItem(this.slider, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => OutsourceServices.launch(slider.url),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: deviceHeight * 0.22,
          margin: EdgeInsets.symmetric(horizontal: AppSize.s16.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSize.s16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.25),
                spreadRadius: AppSize.s1.r,
                blurRadius: AppSize.s6.r,
                offset: Offset(0, AppSize.s4.h),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.s16.r),
            child: CustomNetworkImage(height: deviceHeight * 0.22, width: deviceWidth, image: slider.image),
          ),
        ),
      ),
    );
  }
}
