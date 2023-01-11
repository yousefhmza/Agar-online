import 'package:flutter/material.dart';

import '../../extensions/num_extensions.dart';
import '../../resources/app_resources.dart';
import '../widgets/custom_text.dart';

class EmptyComponent extends StatelessWidget {
  final String asset;
  final String text;

  const EmptyComponent({this.asset = AppImages.empty, required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(asset, width: deviceWidth * 0.5, height: deviceWidth * 0.5, fit: BoxFit.cover),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.p16.w),
            child: CustomText(
              text,
              fontWeight: FontWeightManager.medium,
              textAlign: TextAlign.center,
              height: AppSize.s1_5.h,
            ),
          ),
        ],
      ),
    );
  }
}
