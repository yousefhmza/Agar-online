import 'package:flutter/material.dart';

import '../../resources/font_manager.dart';
import 'custom_text.dart';
import '../../extensions/num_extensions.dart';
import '../../resources/app_colors.dart';
import '../../resources/values_manager.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? color;
  final Color? textColor;
  final Widget? child;
  final double? width;
  final double? height;

  const CustomButton({
    Key? key,
    required this.onPressed,
    this.text = "",
    this.color,
    this.textColor,
    this.child,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        type: MaterialType.transparency,
        child: Ink(
          decoration: onPressed != null
              ? ShapeDecoration(
                  color: color,
                  gradient: color == null
                      ? const LinearGradient(
                          begin: AlignmentDirectional.centerStart,
                          end: AlignmentDirectional.centerEnd,
                          colors: [AppColors.primaryBlue, AppColors.primaryRed],
                        )
                      : null,
                  shape: const StadiumBorder(),
                )
              : const ShapeDecoration(color: AppColors.buttonGrey, shape: StadiumBorder()),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(AppSize.s100.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppPadding.p12.h, horizontal: AppPadding.p24.w),
              child: text.isNotEmpty
                  ? CustomText(
                      text,
                      fontWeight: FontWeightManager.bold,
                      color: textColor ?? AppColors.white,
                      fontSize: FontSize.s16,
                      textAlign: TextAlign.center,
                    )
                  : child,
            ),
          ),
        ),
      ),
    );
  }
}
