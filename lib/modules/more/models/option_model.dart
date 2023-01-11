import 'package:flutter/material.dart';

import '../../../core/resources/app_resources.dart';
import '../../../core/view/widgets/custom_icon.dart';

class Option {
  final String title;
  final Widget trailing;
  final VoidCallback onTap;

  Option({
    required this.title,
    required this.onTap,
    this.trailing = const CustomIcon(Icons.arrow_forward_ios,
        color: AppColors.grey, size: FontSize.s18),
  });
}
