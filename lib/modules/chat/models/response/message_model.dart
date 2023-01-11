import 'package:agar_online/core/utils/globals.dart';

import '../../../../core/utils/formatters.dart';

class Message {
  // final int id;
  final String text;
  final int fromUserId;
  final int toUserId;
  final String sentAt;
  final bool sentByMe;

  Message({
    // required this.id,
    required this.text,
    required this.fromUserId,
    required this.toUserId,
    required this.sentAt,
    required this.sentByMe,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        // id: json["id"],
        text: json["message"] ?? "",
        fromUserId: json["from_user_id"] ?? 0,
        toUserId: json["to_user_id"] ?? 0,
        sentAt: DateFormatter.chatTime(json["updated_at"]),
        sentByMe: json["from_user_id"] == currentUser?.id,
      );
}
