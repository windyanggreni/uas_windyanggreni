import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uas_windyanggreni/screen_page/page_bottom_navigation.dart';
import 'package:uas_windyanggreni/screen_page/page_list_berita.dart';
import 'package:uas_windyanggreni/screen_page/page_register_api.dart';
import '../model/model_login.dart';
import '../utils/session_manager.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {

  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  //key untuk form
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  //fungsi untuk post data
  bool isLoading = false;
  Future<ModelLogin?> loginAccount() async{
    try{
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(Uri.parse('http://192.168.43.124/uas_mobile/login.php'),
          body: {
            "username" : txtUsername.text,
            "password" : txtPassword.text,

          }
      );
      ModelLogin data = modelLoginFromJson(res.body);
      //cek kondisi (ini berdasarkan value respon api
      //value ,1 (ada data login),dan 0 (gagal)
      if(data.value == 1){
        setState(() {
          //save session
          session.saveSession(
            data.value ?? 0,
            data.idUser ?? "",
            data.username ?? "",
            data.nama ?? "",
            data.email ?? "",
            data.nohp ?? "",
            data.nobp ?? "",
            data.alamat ?? "",
          );

          isLoading= false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${data.message}'))
          );

          //pindah ke page berita
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context)
              => const PageBottomNavigationBar()), (route) => false);
        });
      }else{
        setState(() {
          isLoading= false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${data.message}'))
          );
        });
      }

    }catch(e){
      //munculkan error
      setState(() {
        isLoading= false;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()))
        );
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Login Form'),
      ),
      body: Form(
        key: keyForm,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [

                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: txtUsername,
                  validator: (val) {
                    return val!.isEmpty ? "Tidak Boleh Kosong" : null;
                  },
                  decoration: InputDecoration(
                      hintText: 'Username',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),

                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: txtPassword,
                  obscureText: true,
                  validator: (val) {
                    return val!.isEmpty ? "Tidak Boleh Kosong" : null;
                  },
                  decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40))),
                ),

                SizedBox(
                  height: 10,
                ),

                MaterialButton(
                  onPressed: () {
                    //cek kondisi dan get data inputan
                    if (keyForm.currentState?.validate() == true) {
                      //kita panggil function login
                      loginAccount();
                    }
                  },
                  color: Colors.orange,
                  textColor: Colors.white,
                  height: 45,
                  child: Text('Login'),
                )
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(width: 1, color: Colors.green),
          ),
          onPressed: (){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)
            =>PageRegisterNew()
            ), (route) => false);
          },
          child: Text('Anda Belum Punya Akun ? Silahkan Register'),
        ),
      ),
    );
  }
}