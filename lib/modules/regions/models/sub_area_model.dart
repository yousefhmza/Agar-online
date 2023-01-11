import '../../../../config/localization/l10n/l10n.dart';
import '../../../../config/routing/navigation_service.dart';
import 'region_model.dart';

class SubArea extends RegionModel {
  SubArea({
    required super.id,
    required super.name,
  });

  factory SubArea.fromJson(Map<String, dynamic> json) => SubArea(
        id: json["id"] ?? 0,
        name:
            L10n.isAr(NavigationService.navigationKey.currentContext!) ? json["name_ar"] ?? "" : json["name_en"] ?? "",
      );
}
