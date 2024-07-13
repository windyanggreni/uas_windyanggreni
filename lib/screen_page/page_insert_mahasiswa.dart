import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uas_windyanggreni/screen_page/page_list_mahasiswa.dart';

import '../model/model_insert.dart';


class PageInsertMahasiswa extends StatefulWidget {
  const PageInsertMahasiswa({super.key});

  @override
  State<PageInsertMahasiswa> createState() => _PageInsertMahasiswaState();
}

class _PageInsertMahasiswaState extends State<PageInsertMahasiswa> {
  TextEditingController txtNamaMahasiswa = TextEditingController();
  TextEditingController txtNoBP = TextEditingController();
  TextEditingController txtEmail = TextEditingController();

  String? jenisKelamin;

  // Validasi form
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  // Proses untuk hit API
  bool isLoading = false;

  Future<ModelInsert?> addMahasiswa() async {
    // Handle error
    try {
      setState(() {
        isLoading = true;
      });

      http.Response response = await http.post(
        Uri.parse('http://192.168.43.124/uas_mobile/addmahasiswa.php'),
        body: {
          "nama_mahasiswa": txtNamaMahasiswa.text,
          "no_bp": txtNoBP.text,
          "email": txtEmail.text,
          "jenis_kelamin": jenisKelamin,
        },
      );

      if (response.statusCode == 200) {
        ModelInsert data = modelInsertFromJson(response.body);
        // Cek kondisi
        if (data.value == 1) {
          // Kondisi ketika berhasil menambahkan mahasiswa
          setState(() {
            isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${data.message}')),
            );

            // Navigasi ke halaman utama setelah sukses
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PageUtama()),
            );
          });
        } else {
          setState(() {
            isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${data.message}')),
            );
          });
        }
      } else {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Server Error: ${response.statusCode}')),
          );
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Mahasiswa Baru'),
      ),
      body: Form(
        key: keyForm,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  // Validasi kosong
                  validator: (val) {
                    return val!.isEmpty ? "Tidak boleh kosong" : null;
                  },
                  controller: txtNamaMahasiswa,
                  decoration: InputDecoration(
                    hintText: 'Nama Mahasiswa',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  // Validasi kosong
                  validator: (val) {
                    return val!.isEmpty ? "Tidak boleh kosong" : null;
                  },
                  controller: txtNoBP,
                  decoration: InputDecoration(
                    hintText: 'No BP',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  // Validasi kosong
                  validator: (val) {
                    return val!.isEmpty ? "Tidak boleh kosong" : null;
                  },
                  controller: txtEmail,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Jenis Kelamin"),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'P',
                          groupValue: jenisKelamin,
                          onChanged: (value) {
                            setState(() {
                              jenisKelamin = value;
                            });
                          },
                        ),
                        Text('P'),
                        Radio<String>(
                          value: 'L',
                          groupValue: jenisKelamin,
                          onChanged: (value) {
                            setState(() {
                              jenisKelamin = value;
                            });
                          },
                        ),
                        Text('L'),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                // Proses cek loading
                Center(
                  child: isLoading
                      ? Center(
                    child: CircularProgressIndicator(),
                  )
                      : MaterialButton(
                    minWidth: 150,
                    height: 45,
                    onPressed: () {
                      // Cek validasi form ada kosong atau tidak
                      if (keyForm.currentState?.validate() == true && jenisKelamin != null) {
                        setState(() {
                          addMahasiswa();
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill all fields and select gender')),
                        );
                      }
                    },
                    child: Text('Add'),
                    color: Colors.green,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        width: 1,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
