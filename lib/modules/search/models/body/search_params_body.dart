import '../../../../core/enum/sort_price.dart';

class SearchParamsBody {
  String? name;
  SortBy? sortBy;
  String? priceFrom;
  String? priceTo;
  int? adTypeId;
  int? cityId;
  int? areaId;
  int? categoryId;
  int? subCategoryId;
  int? subSubCategoryId;

  SearchParamsBody({
    this.name,
    this.sortBy,
    this.priceFrom,
    this.priceTo,
    this.adTypeId,
    this.cityId,
    this.areaId,
    this.categoryId,
    this.subCategoryId,
    this.subSubCategoryId,
  });

  void copyWith({
    String? name,
    SortBy? sortBy,
    String? priceFrom,
    String? priceTo,
    int? adTypeId,
    int? cityId,
    int? areaId,
    int? categoryId,
    int? subCategoryId,
    int? subSubCategoryId,
  }) {
    this.name = name ?? this.name;
    this.sortBy = sortBy ?? this.sortBy;
    this.priceFrom = priceFrom ?? this.priceFrom;
    this.priceTo = priceTo ?? this.priceTo;
    this.adTypeId = adTypeId ?? this.adTypeId;
    this.cityId = cityId ?? this.cityId;
    this.areaId = areaId ?? this.areaId;
    this.categoryId = categoryId ?? this.categoryId;
    this.subCategoryId = subCategoryId ?? this.subCategoryId;
    this.subSubCategoryId = subSubCategoryId ?? this.subSubCategoryId;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "sortBy": sortBy != null ? sortBy!.name : null,
      "priceFrom": priceFrom,
      "priceTo": priceTo,
      "for": adTypeId,
      "city": cityId,
      "area": areaId,
      "type": categoryId,
      "category": subCategoryId,
      "SubCat": subSubCategoryId,
    };
  }
}
