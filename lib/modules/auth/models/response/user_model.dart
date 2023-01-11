import '../../../../core/utils/constants.dart';
import '../../../categories/models/category_model.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final String type;
  final String address;
  final List<CategoryModel> interests;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.type,
    required this.address,
    required this.interests,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? 0,
        name: json["first_name"] ?? Constants.empty,
        email: json["email"] ?? Constants.empty,
        phone: json["phone"] ?? Constants.empty,
        avatar: json["avatar"] ?? Constants.empty,
        type: json["type"] ?? Constants.empty,
        address: json["address"] ?? Constants.empty,
        interests: json["user_interested"] != null
            ? List<CategoryModel>.from(json["user_interested"].map((interest) => CategoryModel.fromJson(interest)))
            : [],
      );
}
