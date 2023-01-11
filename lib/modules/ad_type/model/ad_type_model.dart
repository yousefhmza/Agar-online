import '../../../config/localization/l10n/l10n.dart';
import '../../../config/routing/navigation_service.dart';

class AdType {
  final int id;
  final String name;

  AdType({
    required this.id,
    required this.name,
  });

  factory AdType.fromJson(Map<String, dynamic> json) => AdType(
        id: json["id"] ?? 0,
        name:
            L10n.isAr(NavigationService.navigationKey.currentContext!) ? json["name_ar"] ?? "" : json["name_en"] ?? "",
      );
}
