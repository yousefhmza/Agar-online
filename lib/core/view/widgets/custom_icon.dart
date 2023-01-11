import 'package:flutter/material.dart';

import '../../resources/values_manager.dart';
import '../../extensions/num_extensions.dart';

class CustomIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double size;

  const CustomIcon(
    this.icon, {
    this.color,
    this.size = AppSize.s24,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: color,
      size: size.sp,
    );
  }
}
