import 'package:agar_online/core/utils/globals.dart';
import 'package:agar_online/modules/chat/models/response/chat_user.dart';

class Chat {
  final int id;
  final ChatUser thisUser;
  final ChatUser otherUser;
  final int adId;
  final String adTitle;
  final String createdAt;
  final String updatedAt;

  Chat({
    required this.id,
    required this.thisUser,
    required this.otherUser,
    required this.adId,
    required this.adTitle,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json["chat_id"] ?? json["id"],
        thisUser: json["from_user_id"] == currentUser?.id
            ? ChatUser.fromJson(json["from_user"])
            : ChatUser.fromJson(json["to_user"]),
        otherUser: json["from_user_id"] == currentUser?.id
            ? ChatUser.fromJson(json["to_user"])
            : ChatUser.fromJson(json["from_user"]),
        adId: json["property"]?["id"] ?? json["property_id"],
        adTitle: json["property"]?["name"] ?? "",
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );
}
