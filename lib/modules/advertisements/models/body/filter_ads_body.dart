class FilterAdsBody {
  int? adTypeId;
  int? subSubCategoryId;

  FilterAdsBody({this.adTypeId, this.subSubCategoryId});

  Map<String, dynamic> toJson() {
    return {"sub_category": subSubCategoryId, "type_id": adTypeId};
  }
}
