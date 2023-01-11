import 'package:flutter/material.dart';

import '../../extensions/num_extensions.dart';
import '../../resources/app_resources.dart';
import '../app_views.dart';

class AppBottomSheet extends StatelessWidget {
  final Widget child;
  final bool expandable;

  const AppBottomSheet({required this.child, required this.expandable, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.p16.w).copyWith(
        bottom: MediaQuery.of(context).viewInsets.bottom + AppPadding.p16.w,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSize.s32.r)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: AppSize.s4.h,
              width: AppSize.s100.w,
              decoration: const ShapeDecoration(color: AppColors.grey, shape: StadiumBorder()),
            ),
            VerticalSpace(AppSize.s16.h),
            Flexible(child: SingleChildScrollView(child: child)),
          ],
        ),
      ),
    );
  }
}
