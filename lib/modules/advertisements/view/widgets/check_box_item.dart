import 'package:flutter/material.dart';

import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';

class CheckBoxItem extends StatelessWidget {
  final String title;
  final bool value;
  final void Function(bool?)? onChanged;

  const CheckBoxItem({required this.value, required this.title, required this.onChanged, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primaryRed,
        ),
        CustomText(title, fontSize: FontSize.s12),
      ],
    );
  }
}
