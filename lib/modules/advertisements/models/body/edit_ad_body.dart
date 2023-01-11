import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class EditAdBody {
  int id;
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
  List<dynamic> images;

  EditAdBody({
    required this.id,
    required this.name,
    required this.desc,
    required this.categoryId,
    required this.subCategoryId,
    required this.subSubCategoryId,
    required this.adTypeId,
    required this.price,
    required this.contact,
    required this.isFeatured,
    required this.cityId,
    required this.areaId,
    required this.subAreaId,
    required this.address,
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
      if (images[0] is File)
        "main_image": await MultipartFile.fromFile(images[0].path, contentType: MediaType("image", "jpg")),
    });
    for (var image in images) {
      if (image is File) {
        formData.files.add(
          MapEntry("images[]", MultipartFile.fromFileSync(image.path, contentType: MediaType("image", "jpg"))),
        );
      }
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
}
