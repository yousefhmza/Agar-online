import '../../extensions/num_extensions.dart';
import 'package:flutter/material.dart';

import '../../resources/app_resources.dart';
import '../app_views.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final double textSize;
  final FontWeight fontWeight;
  final Color? textColor;

  const CustomTextButton({
    this.onPressed,
    required this.text,
    this.textColor,
    this.fontWeight = FontWeightManager.medium,
    this.textSize = FontSize.s16,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: CustomText(
        text,
        color: textColor,
        fontSize: textSize.sp,
        fontWeight: fontWeight,
      ),
    );
  }
}
