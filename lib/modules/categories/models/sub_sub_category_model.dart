import 'package:agar_online/modules/categories/models/base_category_model.dart';
import '../../../config/localization/l10n/l10n.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/globals.dart';

class SubSubCategory extends BaseCategoryModel {
  SubSubCategory({
    required super.id,
    required super.name,
    required super.image,
  });

  factory SubSubCategory.fromJson(Map<String, dynamic> json) =>
      SubSubCategory(
        id: json["id"] ?? 0,
        name: L10n.isAr(globalContext) ? json["name_ar"] ?? "" : json["name_en"] ?? "",
        image: Constants.imagesBaseUrl + json["image"].toString(),
      );
}
