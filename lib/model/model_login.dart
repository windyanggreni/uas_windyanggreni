// To parse this JSON data, do
//
//     final modelLogin = modelLoginFromJson(jsonString);

import 'dart:convert';

ModelLogin modelLoginFromJson(String str) => ModelLogin.fromJson(json.decode(str));

String modelLoginToJson(ModelLogin data) => json.encode(data.toJson());

class ModelLogin {
  int value;
  String message;
  String username;
  String nama;
  String nobp;
  String nohp;
  String email;
  String alamat;
  String idUser;

  ModelLogin({
    required this.value,
    required this.message,
    required this.username,
    required this.nama,
    required this.nobp,
    required this.nohp,
    required this.email,
    required this.alamat,
    required this.idUser,
  });

  factory ModelLogin.fromJson(Map<String, dynamic> json) => ModelLogin(
    value: json["value"],
    message: json["message"],
    username: json["username"],
    nama: json["nama"],
    nobp: json["nobp"],
    nohp: json["nohp"],
    email: json["email"],
    alamat: json["alamat"],
    idUser: json["id_user"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "message": message,
    "username": username,
    "nama": nama,
    "nobp": nobp,
    "nohp": nohp,
    "email": email,
    "alamat": alamat,
    "id_user": idUser,
  };
}