// To parse this JSON data, do
//
//     final modelRegister = modelRegisterFromJson(jsonString);

import 'dart:convert';

ModelRegister modelRegisterFromJson(String str) => ModelRegister.fromJson(json.decode(str));

String modelRegisterToJson(ModelRegister data) => json.encode(data.toJson());

class ModelRegister {
  int value;
  String username;
  String email;
  String nama;
  String nobp;
  String nohp;
  String alamat;
  String message;

  ModelRegister({
    required this.value,
    required this.username,
    required this.email,
    required this.nama,
    required this.nobp,
    required this.nohp,
    required this.alamat,
    required this.message,
  });

  factory ModelRegister.fromJson(Map<String, dynamic> json) => ModelRegister(
    value: json["value"],
    username: json["username"],
    email: json["email"],
    nama: json["nama"],
    nobp: json["nobp"],
    nohp: json["nohp"],
    alamat: json["alamat"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "username": username,
    "email": email,
    "nama": nama,
    "nobp": nobp,
    "nohp": nohp,
    "alamat": alamat,
    "message": message,
  };
}