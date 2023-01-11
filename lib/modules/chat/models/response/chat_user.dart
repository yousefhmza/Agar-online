import '../../../../core/utils/constants.dart';

class ChatUser {
  final int id;
  final String name;
  final String image;

  ChatUser({
    required this.id,
    required this.name,
    required this.image,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
        id: json["id"] ?? 0,
        name: json["first_name"] ?? "",
        image: Constants.imagesBaseUrl + json["image"].toString(),
      );
}
