class MessageBody {
  int propertyId;
  String message;
  int toUserId;
  int chatId;

  MessageBody({
    required this.propertyId,
    required this.message,
    required this.toUserId,
    required this.chatId,
  });

  Map<String, dynamic> toJson() {
    return {
      "property_id": propertyId,
      "message": message,
      "to_user_id": toUserId,
      "chat_id": chatId,
    };
  }
}
