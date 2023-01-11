import 'package:flutter/material.dart';

import '../../../../core/utils/globals.dart';
import '../../../splash/cubit/splash_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../config/localization/l10n/l10n.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.p16.w),
        child: BlocProvider.of<SplashCubit>(context).isAuthed
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VerticalSpace(AppSize.s16.h),
                  Center(
                    child: InkWell(
                      onTap: () {},
                      customBorder: const CircleBorder(),
                      child: SizedBox(
                        height: deviceWidth * 0.25,
                        width: deviceWidth * 0.25,
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
                  ),
                  VerticalSpace(AppSize.s16.h),
                  CustomTextField(
                    readOnly: true,
                    hintText: L10n.tr(context).name,
                    initialValue: currentUser!.name,
                    prefix: const CustomIcon(Icons.person),
                  ),
                  VerticalSpace(AppSize.s16.h),
                  CustomTextField(
                    readOnly: true,
                    hintText: L10n.tr(context).mobileNumber,
                    initialValue: currentUser!.phone,
                    prefix: const CustomIcon(Icons.phone_android),
                  ),
                  VerticalSpace(AppSize.s16.h),
                  CustomTextField(
                    readOnly: true,
                    hintText: L10n.tr(context).email,
                    initialValue: currentUser!.email,
                    prefix: const CustomIcon(Icons.email),
                  ),
                  VerticalSpace(AppSize.s16.h),
                  CustomText(L10n.tr(context).interests, fontSize: FontSize.s16, fontWeight: FontWeightManager.bold),
                  VerticalSpace(AppSize.s8.h),
                  Wrap(
                    spacing: AppSize.s8.w,
                    runSpacing: AppSize.s8.w,
                    children: List.generate(
                      currentUser!.interests.length,
                      (index) => Container(
                        padding: EdgeInsets.symmetric(horizontal: AppPadding.p16.w, vertical: AppPadding.p8.w),
                        decoration: const ShapeDecoration(
                          shape: StadiumBorder(),
                          gradient: LinearGradient(
                            begin: AlignmentDirectional.centerStart,
                            end: AlignmentDirectional.centerEnd,
                            colors: [AppColors.primaryBlue, AppColors.primaryRed],
                          ),
                        ),
                        child: CustomText(currentUser!.interests[index].name, color: AppColors.white),
                      ),
                    ),
                  )
                ],
              )
            : const NotLoggedInWidget(),
      ),
    );
  }
}
