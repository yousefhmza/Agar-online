import 'package:flutter/material.dart';

import 'package:agar_online/core/extensions/num_extensions.dart';
import '../../../../core/resources/app_resources.dart';

class SliderIndicator extends StatelessWidget {
  final bool isCurrent;

  const SliderIndicator({required this.isCurrent, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Time.t150,
      margin: EdgeInsets.symmetric(horizontal: AppPadding.p2.w),
      width: isCurrent ? AppSize.s8.w : AppSize.s6.w,
      height: isCurrent ? AppSize.s8.w : AppSize.s6.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCurrent ? AppColors.white : AppColors.grey,
      ),
    );
  }
}
