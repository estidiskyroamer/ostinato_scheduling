// To parse this JSON data, do
//
//     final instrumentList = instrumentListFromJson(jsonString);

import 'dart:convert';

import 'package:ostinato/models/common.dart';

InstrumentList instrumentListFromJson(String str) =>
    InstrumentList.fromJson(json.decode(str));

String instrumentListToJson(InstrumentList data) => json.encode(data.toJson());

class InstrumentList {
  List<Instrument> data;
  String message;
  bool success;
  Links links;
  Meta meta;

  InstrumentList({
    required this.data,
    required this.message,
    required this.success,
    required this.links,
    required this.meta,
  });

  factory InstrumentList.fromJson(Map<String, dynamic> json) => InstrumentList(
        data: List<Instrument>.from(
            json["data"].map((x) => Instrument.fromJson(x))),
        message: json["message"],
        success: json["success"],
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "success": success,
        "links": links.toJson(),
        "meta": meta.toJson(),
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
