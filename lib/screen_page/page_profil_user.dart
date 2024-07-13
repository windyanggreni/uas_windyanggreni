import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../utils/session_manager.dart';


class PageProfileUser extends StatefulWidget {
  const PageProfileUser({Key? key}) : super(key: key);

  @override
  State<PageProfileUser> createState() => _PageProfileUserState();
}

class _PageProfileUserState extends State<PageProfileUser> {
  late SessionManager session;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    session = SessionManager();
    getDataSession();
  }

  Future<void> getDataSession() async {
    await session.getSession();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile User',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(5, 25, 54, 1.0),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 55,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${isLoading ? 'Loading...' : session.nama ?? 'Data tidak tersedia'}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 5),
                Divider(
                  thickness: 2,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 5),
                ListTile(
                  title: Text(
                    'Username',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${isLoading ? 'Loading...' : session.userName ?? 'Data tidak tersedia'}',
                  ),
                  leading: Icon(Icons.person),
                ),
                ListTile(
                  title: Text(
                    'Email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${isLoading ? 'Loading...' : session.email ?? 'Data tidak tersedia'}',
                  ),
                  leading: Icon(Icons.email),
                ),
                ListTile(
                  title: Text(
                    'No BP',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${isLoading ? 'Loading...' : session.nobp ?? 'Data tidak tersedia'}',
                  ),
                  leading: Icon(Icons.numbers),
                ),
                ListTile(
                  title: Text(
                    'NoHP',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${isLoading ? 'Loading...' : session.nohp ?? 'Data tidak tersedia'}',
                  ),
                  leading: Icon(Icons.phone),
                ),
                ListTile(
                  title: Text(
                    'Alamat',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${isLoading ? 'Loading...' : session.alamat ?? 'Data tidak tersedia'}',
                  ),
                  leading: Icon(Icons.maps_home_work),
                ),
                // SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => PageEditProfile(session: session),
                //       ),
                //     ).then((_) {
                //       setState(() {
                //         isLoading = true;
                //       });
                //       getDataSession();
                //     });
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.lightBlue,
                //
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                //   ),
                //   child: Text(
                //     'Edit Profile',
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 15,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PageEditProfile extends StatefulWidget {
  final SessionManager session;

  const PageEditProfile({Key? key, required this.session}) : super(key: key);

  @override
  State<PageEditProfile> createState() => _PageEditProfileState();
}

class _PageEditProfileState extends State<PageEditProfile> {
  late TextEditingController txtNama;
  late TextEditingController txtEmail;
  late TextEditingController txtNoHP;
  late TextEditingController txtNobp;
  late TextEditingController txtAlamat;


  @override
  void initState() {
    super.initState();
    txtNama = TextEditingController(text: widget.session.nama);
    txtEmail = TextEditingController(text: widget.session.email);
    txtNobp = TextEditingController(text: widget.session.nobp);
    txtNoHP = TextEditingController(text: widget.session.nohp);
    txtAlamat = TextEditingController(text: widget.session.alamat);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: txtNama,
                decoration: InputDecoration(
                  labelText: 'Nama',
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: txtEmail,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: txtNoHP,
                decoration: InputDecoration(
                  labelText: 'No. HP',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  widget.session.saveSession(
                    widget.session.value ?? 0,
                    widget.session.idUser ?? '',
                    widget.session.userName ?? '',
                    txtNama.text,
                    txtEmail.text,
                    txtNobp.text,
                    txtNoHP.text,
                    txtAlamat.text,
                  ).then((_) {
                    updateDatabase(txtNama.text, txtEmail.text, txtNoHP.text);
                    Navigator.pop(context);
                  });
                },
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    txtNama.dispose();
    txtEmail.dispose();
    txtNoHP.dispose();
    super.dispose();
  }

  void updateDatabase(String nama, String email, String nohp) async {
    try {
      // Mendapatkan session ID pengguna dari session manager
      String id = session.idUser ?? '';

      // Membuat permintaan POST ke updateUser.php
      final response = await http.post(
        Uri.parse('http://192.168.43.124/edukasi_server2/updateUser.php'),
        body: {
          'id': id,
          'nama': nama,
          'email': email,
          'nohp': nohp,
        },
      );

      // Memeriksa respon dari server
      if (response.statusCode == 200) {
        // Data berhasil diperbarui
        print('Data berhasil diperbarui');
      } else {
        // Terjadi kesalahan dalam permintaan
        print('Gagal memperbarui data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Terjadi kesalahan dalam koneksi atau server
      print('Terjadi kesalahan: $e');
    }
  }

}