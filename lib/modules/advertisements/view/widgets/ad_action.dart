import 'package:flutter/material.dart';

import '../../../../core/extensions/num_extensions.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';

class AdAction extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final Color color;

  const AdAction(
      {required this.icon, required this.color, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(
                  color: AppColors.grey.withOpacity(0.5),
                  width: AppSize.s1_2.h),
              vertical: BorderSide(
                  color: AppColors.grey.withOpacity(0.5),
                  width: AppSize.s0_5.w),
            ),
          ),
          child: CustomIcon(icon, color: color, size: AppSize.s20),
        ),
      ),
    );
  }
}
