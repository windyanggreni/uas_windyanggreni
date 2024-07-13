import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uas_windyanggreni/screen_page/page_edit_mahasiswa.dart';
import 'package:uas_windyanggreni/screen_page/page_insert_mahasiswa.dart';
import '../model/model_mahasiswa.dart';

class PageUtama extends StatefulWidget {
  const PageUtama({Key? key}) : super(key: key);

  @override
  State<PageUtama> createState() => _PageUtamaState();
}

class _PageUtamaState extends State<PageUtama> {
  TextEditingController searchController = TextEditingController();
  List<Datum>? mahasiswaList;
  List<Datum>? filteredMahasiswaList;

  @override
  void initState() {
    super.initState();
    getMahasiswa();
  }

  Future<void> getMahasiswa() async {
    try {
      var response = await http.get(Uri.parse('http://192.168.43.124/uas_mobile/listmahasiswa.php'));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['isSuccess'] == true) {
          List<Datum> mahasiswas = (jsonData['data'] as List).map((item) => Datum.fromJson(item)).toList();
          setState(() {
            mahasiswaList = mahasiswas;
            filteredMahasiswaList = mahasiswaList;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load mahasiswa: ${jsonData['message']}')));
        }
      } else {
        throw Exception('Failed to load mahasiswa');
      }
    } catch (e) {
      print('Error getMahasiswa: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  Future<void> deleteMahasiswa(String id) async {
    try {
      var response = await http.post(
        Uri.parse('http://192.168.43.124/uas_mobile/deletemahasiswa.php'),
        body: {'id': id},
      );
      var jsonData = json.decode(response.body);
      if (response.statusCode == 200 && jsonData['is_success'] == true) {
        setState(() {
          mahasiswaList!.removeWhere((mahasiswa) => mahasiswa.id == id);
          filteredMahasiswaList = List.from(mahasiswaList!);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mahasiswa deleted successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete mahasiswa: ${jsonData['message']}')));
      }
    } catch (e) {
      print('Error deleteMahasiswa: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Mahasiswa')),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  filteredMahasiswaList = mahasiswaList
                      ?.where((mahasiswa) =>
                  mahasiswa.namaMahasiswa.toLowerCase().contains(value.toLowerCase()) ||
                      mahasiswa.email.toLowerCase().contains(value.toLowerCase()))
                      .toList();
                });
              },
              decoration: InputDecoration(
                labelText: "Search",
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredMahasiswaList != null
                ? ListView.builder(
              itemCount: filteredMahasiswaList!.length,
              itemBuilder: (context, index) {
                Datum data = filteredMahasiswaList![index];
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      // Implement detail page if needed
                    },
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              data.namaMahasiswa,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.email,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Jenis Kelamin: ${data.jenisKelamin}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PageEditMahasiswa(mahasiswa: data),
                                      ),
                                    ).then((updatedMahasiswa) {
                                      if (updatedMahasiswa != null) {
                                        setState(() {
                                          int index = mahasiswaList!.indexWhere((mahasiswa) => mahasiswa.id == updatedMahasiswa.id);
                                          if (index != -1) {
                                            mahasiswaList![index] = updatedMahasiswa;
                                            filteredMahasiswaList = List.from(mahasiswaList!);
                                          }
                                        });
                                      }
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Delete Mahasiswa'),
                                        content: Text('Are you sure you want to delete this mahasiswa?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteMahasiswa(data.id);
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Yes'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
                : Center(
              child: CircularProgressIndicator(color: Colors.blue),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var newMahasiswa = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PageInsertMahasiswa()),
          );

          if (newMahasiswa != null) {
            setState(() {
              mahasiswaList!.add(newMahasiswa);
              if (searchController.text.isNotEmpty) {
                filteredMahasiswaList = mahasiswaList
                    ?.where((mahasiswa) =>
                mahasiswa.namaMahasiswa
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()) ||
                    mahasiswa.email
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase()))
                    .toList();
              } else {
                filteredMahasiswaList = List.from(mahasiswaList!);
              }
            });
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan,
      ),
    );
  }
}
