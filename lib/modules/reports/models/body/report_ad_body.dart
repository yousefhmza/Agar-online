import 'package:dio/dio.dart';

class ReportAdBody {
  String name;
  String phone;
  String email;
  String message;

  ReportAdBody({
    this.name = "",
    this.phone = "",
    this.email = "",
    this.message = "",
  });

  void copyWith({
    String? name,
    String? phone,
    String? email,
    String? message,
  }) {
    this.name = name ?? this.name;
    this.phone = phone ?? this.phone;
    this.email = email ?? this.email;
    this.message = message ?? this.message;
  }

  FormData toFormData() {
    final formData = FormData.fromMap({
      "name": name,
      "phone": phone,
      "email": email,
      "message": message,
    });
    return formData;
  }
}
