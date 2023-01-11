import '../../../config/localization/l10n/l10n.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/globals.dart';
import 'package:agar_online/modules/categories/models/base_category_model.dart';

class CategoryModel extends BaseCategoryModel {
  CategoryModel({
    required super.id,
    required super.name,
    required super.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"] ?? 0,
        name: L10n.isAr(globalContext) ? json["name_ar"] ?? "" : json["name_en"] ?? "",
        image: Constants.imagesBaseUrl + json["image"].toString(),
      );
}
