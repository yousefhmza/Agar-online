import 'package:flutter/material.dart';

import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../core/extensions/num_extensions.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String sentAt;
  final bool sentByMe;

  const MessageBubble({
    required this.text,
    required this.sentAt,
    required this.sentByMe,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: sentByMe ? AlignmentDirectional.centerStart : AlignmentDirectional.centerEnd,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: deviceWidth * 0.75),
        child: Card(
          color: sentByMe ? AppColors.messageBubble.withOpacity(0.1) : AppColors.white,
          margin: EdgeInsets.symmetric(vertical: AppPadding.p8.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s8.r),
          ),
          elevation: sentByMe ? AppSize.s0 : AppSize.s4.h,
          child: Padding(
            padding: EdgeInsets.all(AppPadding.p8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(text, color: AppColors.black),
                VerticalSpace(AppSize.s8.h),
                CustomText(sentAt, color: AppColors.grey, fontSize: FontSize.s10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
