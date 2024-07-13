import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uas_windyanggreni/screen_page/page_login_api.dart';
import '../model/model_register.dart';


class PageRegisterNew extends StatefulWidget {
  const PageRegisterNew({super.key});

  @override
  State<PageRegisterNew> createState() => _PageRegisterState();
}

class _PageRegisterState extends State<PageRegisterNew> {
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtNama = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtNohp = TextEditingController();
  TextEditingController txtNobp = TextEditingController();
  TextEditingController txtAlamat = TextEditingController();
  //key untuk form
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  //fungsi untuk post data
  bool isLoading = false;
  Future<ModelRegister?> registerAccount() async{
    try{
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(Uri.parse('http:///192.168.43.124/uas_mobile/register.php'),
        body: {
          "username": txtUsername.text,
          "nama": txtNama.text,
          "nobp": txtNobp.text,
          "nohp": txtNohp.text,
          "email": txtEmail.text,
          "alamat": txtAlamat.text,
          "password": txtPassword.text,
        },
      );
      ModelRegister data = modelRegisterFromJson(res.body);
      //cek kondisi (ini berdasarkan value respon api
      //value 2 (email sudah terdaftar),1 (berhasil),dan 0 (gagal)
      if(data.value == 1){
        setState(() {
          isLoading= false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${data.message}'))
          );
          //pindah ke page login
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context)
              => const PageLogin()), (route) => false);
        });
      }else if(data.value == 2){
        setState(() {
          isLoading= false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${data.message}'))
          );
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
        title: Text('Register Form'),
      ),
      body: Form(
        key: keyForm,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  validator: (val) {
                    return val!.isEmpty ? "tidak boleh kosong " : null;
                  },
                  controller: txtUsername,
                  decoration: InputDecoration(
                    hintText: 'Input Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  validator: (val) {
                    return val!.isEmpty ? "tidak boleh kosong " : null;
                  },
                  controller: txtNama,
                  decoration: InputDecoration(
                    hintText: 'Input Nama',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  validator: (val) {
                    return val!.isEmpty ? "tidak boleh kosong " : null;
                  },
                  controller: txtNobp,
                  decoration: InputDecoration(
                    hintText: 'Input No BP',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 8,),
                TextFormField(
                  validator: (val) {
                    return val!.isEmpty ? "tidak boleh kosong " : null;
                  },
                  controller: txtNohp,
                  decoration: InputDecoration(
                    hintText: 'Input No HP',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 8,),
                TextFormField(
                  validator: (val) {
                    return val!.isEmpty ? "tidak boleh kosong " : null;
                  },
                  controller: txtEmail,
                  decoration: InputDecoration(
                    hintText: 'Input Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  validator: (val) {
                    return val!.isEmpty ? "tidak boleh kosong " : null;
                  },
                  controller: txtAlamat,
                  decoration: InputDecoration(
                    hintText: 'Input Alamat',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 8,),
                TextFormField(
                  validator: (val) {
                    return val!.isEmpty ? "tidak boleh kosong " : null;
                  },
                  controller: txtPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Input Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                MaterialButton(
                  onPressed: () {
                    //cek kondisi dan get data inputan
                    if (keyForm.currentState?.validate() == true) {
                      //kita panggil function register
                      registerAccount();
                    }
                  },
                  color: Colors.orange,
                  textColor: Colors.white,
                  height: 45,
                  child: Text('Submit'),
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
            =>PageLogin()
            ), (route) => false);
          },
          child: Text('Anda Sudah Punya Akun ? Silahkan Login'),
        ),
      ),
    );
  }
}