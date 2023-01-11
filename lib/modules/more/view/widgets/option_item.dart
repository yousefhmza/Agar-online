import 'package:flutter/material.dart';

import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../models/option_model.dart';

class OptionItem extends StatelessWidget {
  final Option option;

  const OptionItem(this.option, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: option.onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppPadding.p8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [CustomText(option.title), option.trailing],
        ),
      ),
    );
  }
}
