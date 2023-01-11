import 'package:flutter/material.dart';

import 'package:agar_online/core/utils/formatters.dart';
import 'package:agar_online/modules/chat/models/response/chat_model.dart';
import '../../../../core/resources/app_resources.dart';
import '../../../../core/view/app_views.dart';
import '../../../../config/routing/navigation_service.dart';
import '../../../../config/routing/routes.dart';
import '../../../../core/extensions/num_extensions.dart';

class ChatTile extends StatelessWidget {
  final Chat chat;

  const ChatTile(this.chat, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => NavigationService.push(
        context,
        Routes.chatScreen,
        arguments: {
          "other_user_id": chat.otherUser.id,
          "other_user_image": chat.otherUser.image,
          "other_user_name": chat.otherUser.name,
          "ad_id": chat.adId,
        },
      ),
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: CircleAvatar(
        radius: AppSize.s24.r,
        backgroundColor: AppColors.white,
        backgroundImage: NetworkImage(chat.otherUser.image),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomText(
              chat.adTitle,
              fontWeight: FontWeightManager.medium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          HorizontalSpace(AppSize.s4.w),
          CustomText(DateFormatter.chatTime(chat.updatedAt), fontSize: FontSize.s12),
        ],
      ),
      subtitle: CustomText(
        chat.otherUser.name,
        maxLines: 1,
        fontSize: FontSize.s12,
        color: AppColors.grey,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
