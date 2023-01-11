import 'dart:async';

import 'package:agar_online/config/routing/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../extensions/num_extensions.dart';
import '../resources/app_resources.dart';
import '../view/app_views.dart';
import '../view/components/app_bottom_sheet.dart';
import '../view/widgets/platform_widgets/app_dialog.dart';
import '../view/widgets/platform_widgets/loading_dialog.dart';

class Alerts {
  static void showSnackBar(
    BuildContext context,
    String message, {
    bool forError = true,
    Duration duration = Time.t2000,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: forError ? AppColors.red : AppColors.violet,
        content: CustomText(message, color: AppColors.white, fontSize: FontSize.s14),
      ),
    );
  }

  static void showActionSnackBar(
    BuildContext context, {
    required String message,
    required String actionLabel,
    required VoidCallback onActionPressed,
    Duration duration = Time.longTime,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: AppColors.snackBar,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(AppPadding.p16.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s8.r)),
        action: SnackBarAction(label: actionLabel, onPressed: onActionPressed, textColor: AppColors.white),
        content: CustomText(message, color: AppColors.white, fontSize: FontSize.s14),
      ),
    );
  }

  static void showToast(
    String message, [
    Toast length = Toast.LENGTH_SHORT,
    ToastGravity toastGravity = ToastGravity.BOTTOM,
  ]) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: length,
      gravity: toastGravity,
      timeInSecForIosWeb: 3,
      fontSize: FontSize.s16.sp,
      backgroundColor: AppColors.lightGrey,
      textColor: AppColors.black,
    );
  }

  static void showAppDialog(
    BuildContext context, {
    required String title,
    required VoidCallback onConfirm,
    required String confirmText,
    String? description,
  }) {
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: title,
        description: description,
        confirmText: confirmText,
        onConfirm: onConfirm,
      ),
    );
  }

  static void showTransparentDialog(BuildContext context, {required String title, required bool autoPop}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        if (autoPop && context.owner != null) Timer(Time.t3000, () => NavigationService.goBack(context));
        return Dialog(
          backgroundColor: AppColors.transparent,
          elevation: AppSize.s0,
          child: CustomText(
            title,
            color: AppColors.white,
            textAlign: TextAlign.center,
            fontSize: FontSize.s18,
            fontWeight: FontWeightManager.bold,
          ),
        );
      },
    );
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog(context: context, barrierDismissible: false, builder: (context) => const LoadingDialog());
  }

  static void showBottomSheet(
    BuildContext context, {
    required Widget child,
    required bool expandable,
    bool enableDrag = true,
    bool isDismissible = true,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppSize.s32.r))),
      constraints: BoxConstraints(maxHeight: deviceHeight * 0.8),
      builder: (context) => AppBottomSheet(expandable: expandable, child: child),
    );
  }
}
