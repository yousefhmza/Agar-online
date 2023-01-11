import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class AddAdBody {
  String name;
  String desc;
  int? categoryId;
  int? subCategoryId;
  int? subSubCategoryId;
  int? adTypeId;
  String price;
  bool isFeatured;
  int contact;
  int? cityId;
  int? areaId;
  int? subAreaId;
  String address;
  List<File> images;

  AddAdBody({
    this.name = "",
    this.desc = "",
    this.categoryId,
    this.subCategoryId,
    this.subSubCategoryId,
    this.adTypeId,
    this.price = "",
    this.contact = 3,
    this.isFeatured = false,
    this.cityId,
    this.areaId,
    this.subAreaId,
    this.address = "",
    required this.images,
  });

  Future<FormData> toFormData() async {
    FormData formData = FormData.fromMap({
      "name": name,
      "description": desc,
      "category": categoryId,
      "sub_category": subCategoryId,
      "sub_sub_category": subSubCategoryId,
      "for": adTypeId,
      "price": price,
      "featured": isFeatured ? 1 : 0,
      "contact": contact,
      "city_id": cityId,
      "area_id": areaId,
      "sub_area_id": subAreaId,
      "address": address,
      "main_image": await MultipartFile.fromFile(images[0].path, contentType: MediaType("image", "jpg")),
    });
    for (var image in images) {
      formData.files.add(
        MapEntry("images[]", MultipartFile.fromFileSync(image.path, contentType: MediaType("image", "jpg"))),
      );
    }
    return formData;
  }

  void copyWith({
    String? name,
    String? desc,
    int? categoryId,
    int? subCategoryId,
    int? subSubCategoryId,
    int? adTypeId,
    String? price,
    int? contact,
    bool? isFeatured,
    int? cityId,
    int? areaId,
    int? subAreaId,
    String? address,
    List<File>? images,
  }) {
    this.name = name ?? this.name;
    this.desc = desc ?? this.desc;
    this.categoryId = categoryId ?? this.categoryId;
    this.subCategoryId = subCategoryId ?? this.subCategoryId;
    this.subSubCategoryId = subSubCategoryId ?? this.subSubCategoryId;
    this.adTypeId = adTypeId ?? this.adTypeId;
    this.price = price ?? this.price;
    this.isFeatured = isFeatured ?? this.isFeatured;
    this.contact = contact ?? this.contact;
    this.cityId = cityId ?? this.cityId;
    this.areaId = areaId ?? this.areaId;
    this.subAreaId = subAreaId ?? this.subAreaId;
    this.address = address ?? this.address;
    this.images = images ?? this.images;
  }

  void resetValues() {
    name = "";
    desc = "";
    categoryId = null;
    subCategoryId = null;
    subSubCategoryId = null;
    adTypeId = null;
    price = "0";
    contact = 3;
    isFeatured = false;
    cityId = null;
    areaId = null;
    subAreaId = null;
    address = "";
    images = [];
  }
}
