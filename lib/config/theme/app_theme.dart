import 'dart:ui';

import 'package:flutter/material.dart';

import '../localization/cubit/l10n_cubit.dart';
import '../../core/extensions/num_extensions.dart';
import '../../core/resources/font_manager.dart';
import '../../core/resources/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/resources/values_manager.dart';

ThemeData appTheme(BuildContext context) {
  final L10nCubit l10nCubit = BlocProvider.of<L10nCubit>(context);
  final isAr =
      l10nCubit.appLocale == null ? window.locale.languageCode == "ar" : l10nCubit.appLocale!.languageCode == "ar";
  return ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.lightGrey,

    /// appbar
    appBarTheme: const AppBarTheme(
      elevation: AppSize.s0,
      backgroundColor: AppColors.transparent,
      iconTheme: IconThemeData(color: AppColors.black),
    ),

    /// tabbar
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: AppColors.black,
      unselectedLabelStyle: TextStyle(
        fontFamily: isAr ? FontConstants.arabicFontFamily : FontConstants.englishFontFamily,
        fontWeight: FontWeightManager.bold,
      ),
      labelStyle: TextStyle(
        fontFamily: isAr ? FontConstants.arabicFontFamily : FontConstants.englishFontFamily,
        fontWeight: FontWeightManager.bold,
      ),
      indicator: const ShapeDecoration(
        shape: StadiumBorder(),
        gradient: LinearGradient(
          begin: AlignmentDirectional.centerStart,
          end: AlignmentDirectional.centerEnd,
          colors: [AppColors.primaryBlue, AppColors.primaryRed],
        ),
      ),
    ),

    /// bottom navigation bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryRed,
      selectedLabelStyle: TextStyle(
        color: AppColors.primaryRed,
        fontWeight: FontWeightManager.bold,
        fontFamily: isAr ? FontConstants.arabicFontFamily : FontConstants.englishFontFamily,
      ),
      unselectedLabelStyle: TextStyle(
        color: AppColors.black,
        fontFamily: isAr ? FontConstants.arabicFontFamily : FontConstants.englishFontFamily,
      ),
    ),

    /// circular progress indicator
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.primaryRed),

    /// text fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      iconColor: AppColors.black,
      hintStyle: TextStyle(
        color: AppColors.hintText,
        fontSize: FontSize.s14.sp,
        fontFamily: isAr ? FontConstants.arabicFontFamily : FontConstants.englishFontFamily,
      ),
      contentPadding: EdgeInsets.all(AppPadding.p12.w),
      errorStyle: TextStyle(
        fontSize: FontSize.s12.sp,
        fontFamily: isAr ? FontConstants.arabicFontFamily : FontConstants.englishFontFamily,
      ),
      errorMaxLines: 2,
      border: InputBorder.none,
      disabledBorder: InputBorder.none,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(AppSize.s32.r),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.red),
        borderRadius: BorderRadius.circular(AppSize.s32.r),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(AppSize.s32.r),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(AppSize.s32.r),
      ),
    ),
  );
}
