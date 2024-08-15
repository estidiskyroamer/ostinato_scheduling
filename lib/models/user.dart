// To parse this JSON data, do
//
//     final userDetail = userDetailFromJson(jsonString);

import 'dart:convert';

UserDetail userDetailFromJson(String str) =>
    UserDetail.fromJson(json.decode(str));

String userDetailToJson(UserDetail data) => json.encode(data.toJson());

class UserDetail {
  User data;
  String message;
  bool success;

  UserDetail({
    required this.data,
    required this.message,
    required this.success,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        data: User.fromJson(json["data"]),
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "success": success,
      };
}

class User {
  String? id;
  String name;
  String email;
  String phoneNumber;
  String? password;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "password": password,
      };
}
