import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class ProfileBody {
  String name;
  String email;
  String phone;
  String address;
  File? avatar;
  List<int> interests;

  ProfileBody({
    this.name = "",
    this.email = "",
    this.phone = "",
    this.address = "",
    this.avatar,
    required this.interests,
  });

  void copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    File? avatar,
    List<int>? interests,
  }) {
    this.name = name ?? this.name;
    this.email = email ?? this.email;
    this.phone = phone ?? this.phone;
    this.address = address ?? this.address;
    this.avatar = avatar ?? this.avatar;
    this.interests = interests ?? this.interests;
  }

  Future<FormData> toJson() async {
    final FormData formData = FormData.fromMap({
      "name": name,
      "email": email,
      "phone": phone,
      "address": address,
      if (avatar != null) "avatar": await MultipartFile.fromFile(avatar!.path, contentType: MediaType('image', 'jpg')),
    });
    for (var interest in interests) {
      formData.fields.add(MapEntry("interested[]", interest.toString()));
    }
    return formData;
  }
}
