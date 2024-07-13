import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uas_windyanggreni/screen_page/page_login_api.dart';
import '../model/model_berita.dart';
import '../utils/session_manager.dart';
import 'detail_berita.dart';

class PageListBerita extends StatefulWidget {
  const PageListBerita({Key? key}) : super(key: key);

  @override
  State<PageListBerita> createState() => _PageListBeritaState();
}

class _PageListBeritaState extends State<PageListBerita> {
  TextEditingController searchController = TextEditingController();
  List<Datum>? beritaList;
  String? username;
  List<Datum>? filteredBeritaList; // List berita hasil filter

  @override
  void initState() {
    super.initState();
    session.getSession();
    getDataSession();
  }

  Future getDataSession() async {
    await Future.delayed(const Duration(seconds: 1), () {
      session.getSession().then((value) {
        print('data sesi .. ' + session.userName.toString());
        username = session.userName;
      });
    });
  }

  Future<List<Datum>?> getBerita() async {
    try {
      // Berhasil
      http.Response response = await http.get(
        Uri.parse("http://192.168.43.124/uas_mobile/berita.php"),
      );

      return modelBeritaFromJson(response.body).data;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List Berita',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        actions: [
          TextButton(onPressed: () {}, child: Text('Hi ... ${session.userName}', style: TextStyle(color: Colors.deepOrangeAccent), )),
          // Logout
          IconButton(
            onPressed: () {
              // Clear session
              setState(() {
                session.clearSession();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => PageLogin()),
                      (route) => false,
                );
              });
            },
            icon: Icon(Icons.exit_to_app),
            tooltip: 'Logout',
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  filteredBeritaList = beritaList
                      ?.where((element) =>
                  element.judul!
                      .toLowerCase()
                      .contains(value.toLowerCase()) ||
                      element.author!
                          .toLowerCase()
                          .contains(value.toLowerCase()) ||
                      element.created.toString()!
                          .toLowerCase()
                          .contains(value.toLowerCase()) ||
                        element.konten!
                            .toLowerCase()
                            .contains(value.toLowerCase()))
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
            child: FutureBuilder(
              future: getBerita(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Datum>?> snapshot) {
                if (snapshot.hasData) {
                  beritaList = snapshot.data;
                  if (filteredBeritaList == null) {
                    filteredBeritaList = beritaList;
                  }
                  return ListView.builder(
                    itemCount: filteredBeritaList!.length,
                    itemBuilder: (context, index) {
                      Datum data = filteredBeritaList![index];
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailBeritaPage(data),
                              ),
                            );
                          },
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(4),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network('http://192.168.43.124/uts_mobile/image/${data.gambar}',
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                ),
                                ListTile(
                                  title: Text(
                                    '${data.judul}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Author: ${data.author}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'Created: ${data.created.toString()}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    '${data.konten}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
