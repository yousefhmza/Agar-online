import '../../modules/advertisements/models/response/advertisement_model.dart';

class Helpers {
  static List<Advertisement> getNotBlockedAds(List ads) {
    final List<Advertisement> notBlockedAds = [];
    for (var ad in ads) {
      if (ad["block"] != "true") notBlockedAds.add(Advertisement.fromJson(ad));
    }
    return notBlockedAds;
  }
}
