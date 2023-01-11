import '../../../config/localization/l10n/l10n.dart';
import '../../resources/app_colors.dart';
import 'package:flutter/material.dart';

import '../../extensions/num_extensions.dart';
import '../../resources/font_manager.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final double? height;
  final int? maxLines;
  final TextDecoration? decoration;

  const CustomText(
    this.text, {
    this.color,
    this.fontSize = FontSize.s14,
    this.fontWeight = FontWeightManager.regular,
    this.textAlign,
    this.height,
    this.overflow,
    this.maxLines,
    this.decoration,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: TextStyle(
        color: color ?? AppColors.black,
        fontSize: fontSize.sp,
        fontFamily: L10n.isAr(context) ? FontConstants.arabicFontFamily : FontConstants.englishFontFamily,
        fontWeight: fontWeight,
        height: height?.h,
        decoration: decoration,
      ),
    );
  }
}
