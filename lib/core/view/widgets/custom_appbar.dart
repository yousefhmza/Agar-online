import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../extensions/num_extensions.dart';
import '../../resources/app_colors.dart';
import '../../resources/values_manager.dart';

class CustomAppbar extends StatelessWidget with PreferredSizeWidget {
  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;
  final Color? bgColor;
  final Widget? flexibleSpace;
  final bool isDarkStatusBar;
  final bool extendedHeight;
  final bool hasTitleSpacing;

  const CustomAppbar({
    this.leading,
    this.title,
    this.actions,
    this.bottom,
    this.bgColor,
    this.flexibleSpace,
    this.centerTitle = false,
    this.isDarkStatusBar = true,
    this.extendedHeight = false,
    this.hasTitleSpacing = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: title,
      actions: actions,
      backgroundColor: bgColor,
      elevation: AppSize.s0,
      centerTitle: centerTitle,
      titleSpacing: hasTitleSpacing ? AppSize.s16.w : AppSize.s0,
      toolbarHeight: extendedHeight ? AppSize.s100.h : kToolbarHeight.h,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: isDarkStatusBar ? Brightness.dark : Brightness.light,
        statusBarBrightness: isDarkStatusBar ? Brightness.light : Brightness.dark,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(extendedHeight ? AppSize.s100.h : kToolbarHeight.h);
}
