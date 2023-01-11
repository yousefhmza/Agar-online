import '../../../config/localization/l10n/l10n.dart';
import '../../../config/routing/navigation_service.dart';
import 'region_model.dart';

class Area extends RegionModel {
  Area({
    required super.id,
    required super.name,
  });

  factory Area.fromJson(Map<String, dynamic> json) => Area(
        id: json["id"] ?? 0,
        name:
            L10n.isAr(NavigationService.navigationKey.currentContext!) ? json["name_ar"] ?? "" : json["name_en"] ?? "",
      );
}
