import '../../../../core/utils/constants.dart';

class AdImage {
  final int id;
  final String image;

  AdImage({
    required this.id,
    required this.image,
  });

  factory AdImage.fromJson(Map<String, dynamic> json) => AdImage(
        id: json["id"] ?? 0,
        image: Constants.imagesBaseUrl + json["image"],
      );
}
