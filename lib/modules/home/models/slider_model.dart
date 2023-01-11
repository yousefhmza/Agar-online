import '../../../core/utils/constants.dart';

class SliderModel {
  final String image;
  final String url;

  SliderModel({required this.image, required this.url});

  factory SliderModel.fromJson(Map<String, dynamic> json) => SliderModel(
        image: Constants.imagesBaseUrl + json["image"],
        url: json["url"] ?? Constants.empty,
      );
}
