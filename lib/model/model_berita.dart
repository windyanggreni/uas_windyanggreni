// To parse this JSON data, do
//
//     final modelBerita = modelBeritaFromJson(jsonString);

import 'dart:convert';

ModelBerita modelBeritaFromJson(String str) => ModelBerita.fromJson(json.decode(str));

String modelBeritaToJson(ModelBerita data) => json.encode(data.toJson());

class ModelBerita {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelBerita({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelBerita.fromJson(Map<String, dynamic> json) => ModelBerita(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String idBerita;
  String judul;
  String konten;
  String gambar;
  String author;
  DateTime created;
  dynamic updated;

  Datum({
    required this.idBerita,
    required this.judul,
    required this.konten,
    required this.gambar,
    required this.author,
    required this.created,
    required this.updated,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    idBerita: json["id_berita"],
    judul: json["judul"],
    konten: json["konten"],
    gambar: json["gambar"],
    author: json["author"],
    created: DateTime.parse(json["created"]),
    updated: json["updated"],
  );

  Map<String, dynamic> toJson() => {
    "id_berita": idBerita,
    "judul": judul,
    "konten": konten,
    "gambar": gambar,
    "author": author,
    "created": created.toIso8601String(),
    "updated": updated,
  };
}