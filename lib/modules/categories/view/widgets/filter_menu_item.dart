import 'package:flutter/material.dart';

import 'package:agar_online/core/extensions/num_extensions.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';

class FilterMenuItem<T> extends PopupMenuItem<T> {
  FilterMenuItem({required T? value, required bool isSelected, required String text, VoidCallback? onTap, Key? key})
      : super(
          value: value,
          padding: EdgeInsets.zero,
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(AppPadding.p16.w),
            width: double.infinity,
            color: isSelected ? AppColors.primaryRed.withOpacity(0.2) : AppColors.transparent,
            child: CustomText(text, fontWeight: FontWeightManager.medium),
          ),
          key: key,
        );
}
