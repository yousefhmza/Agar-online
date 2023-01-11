import 'package:agar_online/core/services/notifications/notification_fcm.dart';

class LoginBody {
  String phone;
  String password;

  LoginBody({required this.phone, required this.password});

  Future<Map<String, dynamic>> toJson() async {
    return {
      "phone": phone,
      "password": password,
      "fcm_token": await NotificationsFCM.getToken(),
    };
  }
}
