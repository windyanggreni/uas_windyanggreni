// To parse this JSON data, do
//
//     final modelMahasiswa = modelMahasiswaFromJson(jsonString);

import 'dart:convert';

ModelMahasiswa modelMahasiswaFromJson(String str) => ModelMahasiswa.fromJson(json.decode(str));

String modelMahasiswaToJson(ModelMahasiswa data) => json.encode(data.toJson());

class ModelMahasiswa {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelMahasiswa({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelMahasiswa.fromJson(Map<String, dynamic> json) => ModelMahasiswa(
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
  String id;
  String namaMahasiswa;
  String noBp;
  String email;
  String jenisKelamin;

  Datum({
    required this.id,
    required this.namaMahasiswa,
    required this.noBp,
    required this.email,
    required this.jenisKelamin,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    namaMahasiswa: json["nama_mahasiswa"],
    noBp: json["no_bp"],
    email: json["email"],
    jenisKelamin: json["jenis_kelamin"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama_mahasiswa": namaMahasiswa,
    "no_bp": noBp,
    "email": email,
    "jenis_kelamin": jenisKelamin,
  };
}
