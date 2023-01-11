import 'package:flutter/material.dart';

import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../config/localization/l10n/l10n.dart';

class PriceBox extends StatelessWidget {
  final int price;

  const PriceBox(this.price, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.p4.w),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(AppSize.s4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomIcon(Icons.local_offer, size: AppSize.s16, color: AppColors.red),
          HorizontalSpace(AppSize.s4.w),
          CustomText("$price ${L10n.tr(context).egp}", maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
