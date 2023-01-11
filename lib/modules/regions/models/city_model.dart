import '../../../config/localization/l10n/l10n.dart';
import '../../../config/routing/navigation_service.dart';
import 'region_model.dart';

class City extends RegionModel {
  City({
    required super.id,
    required super.name,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"] ?? 0,
        name:
            L10n.isAr(NavigationService.navigationKey.currentContext!) ? json["name_ar"] ?? "" : json["name_en"] ?? "",
      );
}
