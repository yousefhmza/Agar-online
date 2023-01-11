import 'package:agar_online/core/utils/constants.dart';

class AdOwner {
  final int id;
  final String phoneNumber;
  final String firstName;
  final String image;

  AdOwner({
    required this.id,
    required this.phoneNumber,
    required this.firstName,
    required this.image,
  });

  factory AdOwner.fromJson(Map<String, dynamic> json) => AdOwner(
        id: json["id"] ?? 0,
        phoneNumber: json["phone"] ?? "",
        firstName: json["first_name"] ?? "",
        image: Constants.imagesBaseUrl + json["image"].toString(),
      );
}
