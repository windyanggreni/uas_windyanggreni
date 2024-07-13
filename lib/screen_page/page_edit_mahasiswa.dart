import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uas_windyanggreni/screen_page/page_list_mahasiswa.dart';
import '../model/model_mahasiswa.dart';

class PageEditMahasiswa extends StatefulWidget {
  final Datum mahasiswa;

  const PageEditMahasiswa({required this.mahasiswa});

  @override
  _PageEditMahasiswaState createState() => _PageEditMahasiswaState();
}

class _PageEditMahasiswaState extends State<PageEditMahasiswa> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _txtNamaMahasiswa = TextEditingController();
  final TextEditingController _txtNoBP = TextEditingController();
  final TextEditingController _txtEmail = TextEditingController();

  String? jenisKelamin;

  @override
  void initState() {
    super.initState();
    _txtNamaMahasiswa.text = widget.mahasiswa.namaMahasiswa;
    _txtNoBP.text = widget.mahasiswa.noBp;
    _txtEmail.text = widget.mahasiswa.email;
    jenisKelamin = widget.mahasiswa.jenisKelamin;
  }

  @override
  void dispose() {
    _txtNamaMahasiswa.dispose();
    _txtNoBP.dispose();
    _txtEmail.dispose();
    super.dispose();
  }

  Future<void> _updateMahasiswa() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('http://192.168.43.124/uas_mobile/updatemahasiswa.php'),
          body: {
            'id': widget.mahasiswa.id.toString(),
            'nama_mahasiswa': _txtNamaMahasiswa.text,
            'no_bp': _txtNoBP.text,
            'email': _txtEmail.text,
            'jenis_kelamin': jenisKelamin,
          },
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          if (jsonResponse['value'] == 1) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => PageUtama()),
                  (Route<dynamic> route) => false,
            );
          } else {
            _showErrorDialog(jsonResponse['message']);
          }
        } else {
          _showErrorDialog('An error occurred while sending data to the server');
        }
      } catch (error) {
        _showErrorDialog('An error occurred: $error');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Failed"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Mahasiswa'),
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextFormField(
                controller: _txtNamaMahasiswa,
                decoration: InputDecoration(
                  labelText: 'Nama Mahasiswa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a nama mahasiswa';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _txtNoBP,
                decoration: InputDecoration(
                  labelText: 'No BP',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a no BP';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _txtEmail,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateMahasiswa,
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
