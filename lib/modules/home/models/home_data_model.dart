import 'package:agar_online/core/utils/helpers.dart';

import 'slider_model.dart';
import '../../advertisements/models/response/advertisement_model.dart';
import '../../categories/models/category_model.dart';

class HomeData {
  final List<SliderModel> topSliders;
  final List<CategoryModel> categories;
  final List<SliderModel> bottomSliders;
  final List<Advertisement> featuredAds;
  final List<Advertisement> latestAds;
  final List<Advertisement> cars;
  final List<Advertisement> realEstate;

  HomeData({
    required this.topSliders,
    required this.categories,
    required this.bottomSliders,
    required this.featuredAds,
    required this.latestAds,
    required this.cars,
    required this.realEstate,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        topSliders: List<SliderModel>.from(json["sliders"]?.map((slider) => SliderModel.fromJson(slider)) ?? []),
        categories:
            List<CategoryModel>.from(json["Category"]?.map((category) => CategoryModel.fromJson(category)) ?? []),
        bottomSliders: List<SliderModel>.from(json["sliders2"]?.map((slider) => SliderModel.fromJson(slider)) ?? []),
        featuredAds: Helpers.getNotBlockedAds(json["properties_features"] ?? []),
        latestAds: Helpers.getNotBlockedAds(json["latest_properties"] ?? []),
        cars: Helpers.getNotBlockedAds(json["car_properties"] ?? []),
        realEstate: Helpers.getNotBlockedAds(json["Realstate_properties"] ?? []),
      );
}
