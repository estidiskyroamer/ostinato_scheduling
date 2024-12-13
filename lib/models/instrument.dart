// To parse this JSON data, do
//
//     final instrumentList = instrumentListFromJson(jsonString);

import 'dart:convert';

InstrumentList instrumentListFromJson(String str) =>
    InstrumentList.fromJson(json.decode(str));

String instrumentListToJson(InstrumentList data) => json.encode(data.toJson());

class InstrumentList {
  List<Instrument> data;
  String message;
  bool success;

  InstrumentList(
      {required this.data, required this.message, required this.success});

  factory InstrumentList.fromJson(Map<String, dynamic> json) => InstrumentList(
        data: List<Instrument>.from(
            json["data"].map((x) => Instrument.fromJson(x))),
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "success": success,
      };
}

class Instrument {
  String id;
  String name;

  Instrument({
    required this.id,
    required this.name,
  });

  factory Instrument.fromJson(Map<String, dynamic> json) => Instrument(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
