// To parse this JSON data, do
//
//     final company = companyFromJson(jsonString);

import 'dart:convert';

Company companyFromJson(String str) => Company.fromJson(json.decode(str));

String companyToJson(Company data) => json.encode(data.toJson());

class Company {
  final String id;
  final String name;
  final String phoneNumber;
  final String address;
  final String companyCode;

  Company({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.companyCode,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        address: json["address"],
        companyCode: json["companyCode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phoneNumber": phoneNumber,
        "address": address,
        "companyCode": companyCode,
      };
}
