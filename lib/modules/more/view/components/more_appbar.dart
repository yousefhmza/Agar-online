import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/globals.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../config/routing/navigation_service.dart';
import '../../../../config/routing/routes.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../config/localization/l10n/l10n.dart';
import '../../../profile/cubits/profile_cubit.dart';
import '../../../profile/cubits/profile_states.dart';

class MoreAppbar extends StatelessWidget {
  final bool isAuthed;

  const MoreAppbar({required this.isAuthed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: isAuthed
          ? InkWell(
              onTap: () => NavigationService.push(context, Routes.editProfileScreen),
              child: Row(
                children: [
                  const CustomIcon(Icons.edit, color: AppColors.white),
                  HorizontalSpace(AppSize.s8.w),
                  CustomText(
                    L10n.tr(context).editProf,
                    color: AppColors.white,
                    fontSize: FontSize.s18,
                    fontWeight: FontWeightManager.medium,
                  ),
                ],
              ),
            )
          : CustomText(
              L10n.tr(context).more,
              fontWeight: FontWeightManager.bold,
              color: AppColors.white,
              fontSize: FontSize.s24,
            ),
      flexibleSpace: SizedBox(
        height: isAuthed ? deviceHeight * 0.2 + deviceWidth * 0.125 : deviceHeight * 0.2,
        child: Stack(
          children: [
            Container(
              height: deviceHeight * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppSize.s32.r)),
                gradient: const LinearGradient(
                  end: AlignmentDirectional.centerEnd,
                  begin: AlignmentDirectional.centerStart,
                  colors: [AppColors.primaryBlue, AppColors.primaryRed],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.25),
                    spreadRadius: AppSize.s1.r,
                    blurRadius: AppSize.s6.r,
                    offset: Offset(0, AppSize.s4.h),
                  )
                ],
              ),
            ),
            if (isAuthed)
              BlocBuilder<ProfileCubit, ProfileStates>(
                buildWhen: (prevState, state) => state is EditProfileSuccessState,
                builder: (context, state) => Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.s100.r),
                    child: CustomNetworkImage(
                      image: currentUser!.avatar,
                      height: deviceWidth * 0.25,
                      width: deviceWidth * 0.25,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }
}
