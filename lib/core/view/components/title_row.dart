import 'package:flutter/material.dart';

import '../../extensions/num_extensions.dart';
import '../../resources/font_manager.dart';
import '../../resources/values_manager.dart';
import '../widgets/custom_text.dart';
import '../../../config/localization/l10n/l10n.dart';

class TitleRow extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final bool withPadding;

  const TitleRow({required this.title, this.onTap, this.withPadding = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: withPadding ? EdgeInsets.symmetric(horizontal: AppPadding.p16.w) : EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(title, fontSize: FontSize.s16, fontWeight: FontWeightManager.bold),
          InkWell(
            onTap: onTap,
            child: CustomText(L10n.tr(context).viewAll),
          )
        ],
      ),
    );
  }
}
