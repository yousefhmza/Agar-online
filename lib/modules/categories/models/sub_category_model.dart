import 'package:agar_online/core/utils/globals.dart';
import 'package:agar_online/modules/categories/models/base_category_model.dart';
import '../../../config/localization/l10n/l10n.dart';
import '../../../core/utils/constants.dart';
import 'sub_sub_category_model.dart';

class Subcategory extends BaseCategoryModel {
  final int categoryId;
  final List<SubSubCategory> subSubCategories;

  Subcategory({
    required super.id,
    required super.name,
    required super.image,
    required this.categoryId,
    required this.subSubCategories,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
        id: json["id"] ?? 0,
        name: L10n.isAr(globalContext) ? json["name_ar"] ?? "" : json["name_en"] ?? "",
        image: Constants.imagesBaseUrl + json["image"].toString(),
        categoryId: json["cat"] ?? 0,
        subSubCategories: json["property_sub"] != null
            ? List<SubSubCategory>.from(json["property_sub"].map((s) => SubSubCategory.fromJson(s)))
            : [],
      );
}
