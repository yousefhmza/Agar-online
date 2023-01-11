import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../cubit/layout_cubit.dart';

class FAB extends StatelessWidget {
  const FAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSize.s64.w,
      height: AppSize.s64.w,
      child: FloatingActionButton(
        onPressed: () => BlocProvider.of<LayoutCubit>(context).setCurrentIndex(2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s24.r)),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.s24.r),
            gradient: const LinearGradient(
              begin: AlignmentDirectional.centerStart,
              end: AlignmentDirectional.centerEnd,
              colors: <Color>[AppColors.primaryBlue, AppColors.primaryRed],
            ),
          ),
          child: const CustomIcon(Icons.add_circle_sharp, size: AppSize.s32),
        ),
      ),
    );
  }
}
