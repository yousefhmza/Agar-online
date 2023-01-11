import 'package:flutter/material.dart';

import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/widgets/custom_text.dart';

class RadioButtonItem extends StatelessWidget {
  final String title;
  final int value;
  final int groupValue;
  final void Function(int?)? onChanged;

  const RadioButtonItem({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<int>(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primaryRed,
          groupValue: groupValue,
        ),
        CustomText(title, fontSize: FontSize.s12),
      ],
    );
  }
}
