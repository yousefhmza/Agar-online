import 'package:dio/dio.dart';

import '../../../../core/services/notifications/notification_fcm.dart';

class SignupBody {
  String name;
  String email;
  String phone;
  String password;
  String passwordConfirmation;
  List<int> interests;

  SignupBody({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    required this.interests,
  });

  Future<FormData> toJson() async {
    final FormData formData = FormData.fromMap({
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "fcm_token": await NotificationsFCM.getToken(),
    });
    for (var interest in interests) {
      formData.fields.add(MapEntry("interested[]", interest.toString()));
    }
    return formData;
  }
}
