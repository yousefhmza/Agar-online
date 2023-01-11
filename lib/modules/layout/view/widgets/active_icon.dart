import 'package:flutter/material.dart';

import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';

class ActiveIcon extends StatelessWidget {
  final IconData icon;

  const ActiveIcon(this.icon, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) => const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: <Color>[AppColors.primaryBlue, AppColors.primaryRed],
      ).createShader(bounds),
      child: CustomIcon(icon),
    );
  }
}
