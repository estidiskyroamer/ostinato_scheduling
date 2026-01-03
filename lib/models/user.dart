// To parse this JSON data, do
//
//     final userDetail = userDetailFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:ostinato/models/company.dart';
import 'package:ostinato/models/role.dart';

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
  String? address;
  DateTime? birthDate;
  String? password;
  List<Role>? roles;
  List<Company>? companies;
  String? companyCode;
  final int isActive;

  User(
      {this.id,
      required this.name,
      required this.email,
      required this.phoneNumber,
      this.address,
      this.birthDate,
      this.password,
      this.roles,
      this.companies,
      this.companyCode,
      required this.isActive});

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      address: json["address"],
      birthDate:
          json["birthDate"] != null ? DateTime.parse(json["birthDate"]) : null,
      password: json["password"],
      roles: json["roles"] != null
          ? List<Role>.from(json["roles"].map((x) => Role.fromJson(x)))
          : null,
      companies: json["companies"] != null
          ? List<Company>.from(
              json["companies"].map((x) => Company.fromJson(x)))
          : null,
      isActive: json["isActive"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "address": address,
        "birthDate": birthDate != null
            ? DateFormat('yyyy-MM-dd').format(birthDate!)
            : null,
        "password": password,
        "roles": roles != null
            ? List<dynamic>.from(roles!.map((x) => x.toJson()))
            : null,
        "companies": companies != null
            ? List<dynamic>.from(companies!.map((x) => x.toJson()))
            : null,
        "companyCode": companyCode,
        "isActive": isActive
      };
}
