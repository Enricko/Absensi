import 'dart:async';

import 'package:absensi/include/interstisial_ads.dart';
import 'package:absensi/page/auth/login.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../system/update_data.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({Key? key}) : super(key: key);

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  String id_user = "";
  TextEditingController passOldController = TextEditingController();
  TextEditingController passNewController = TextEditingController();
  String? passOld;

  // Form Key untuk Validasi Form Input
  final formkey = GlobalKey<FormState>();

  // ignorePointer agar tidak spam click
  bool ignorePointer = false;
  Timer? ignorePointerTimer;

  // invisible agar icon mata pada password dapat di gunakan semestinya
  bool invisible = true;

  Future<void> getPref() async {
    ///Inisiasi database local (SharedPreference)
    SharedPreferences pref = await SharedPreferences.getInstance();

    //Mengambil data dari database local
    //dan memasukan nya ke variable id_user
    setState(() {
      id_user = pref.getString('id_user')!;
    });
  }

  void cekUser() {
    // Logic cek Data User apakah sudah pernah login
    if (FirebaseAuth.instance.currentUser == null) {
      FirebaseAuth.instance.currentUser;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      });
    }
  }

  //function update data
  void editProfile() {
    // Mengubah Controller menjadi String/int
    var oldPassword = passOldController.text;
    var newPassword = passNewController.text;
    // Menjadikan Map agar mudah di pindah ke function lain
    var data = {
      'old_password': oldPassword,
      'new_password': newPassword,
    };
    // Menjalankan Logic Class Function Update Password
    UpdateData.password(data, id_user, context);
  }


  @override
  void initState() {
    super.initState();
    // Cek User apakah user sudah pernah login sebelumnya
    cekUser();

    ///mengeksekusi function sebelum function build
    getPref();
    // Load InterstitialAd Ads
    InterstitialAds.loadAd();
  }
//function yang akan dijalankan ketika screen di hapus / di tinggalkan
  @override
  void dispose() {
    // Timer pada ignore pointer akan di hapus jika pindah page
    // agar tidak memakan banyak resource device dan tidak error
    if (ignorePointerTimer != null) {
      ignorePointerTimer!.cancel();
    }
    EasyLoading.dismiss();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Edit Password",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(

          children: [
            Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Password Lama"),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: passOldController,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "") {
                          return "Password Lama harus di isi!";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                          hintText: "Password",
                          hintStyle: TextStyle(fontSize: 13),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.black38),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.black38),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.redAccent),
                          ),
                          filled: true,
                          fillColor: Colors.white),
                    ),
                  ),
                  Text("Password Baru"),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: passNewController,
                      keyboardType: TextInputType.text,
                      obscureText: invisible,
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "") {
                          return "Password Baru harus di isi!";
                        }
                        return null;
                      },

                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                          hintText: "Password Baru",
                          hintStyle: TextStyle(fontSize: 13),
                          suffixIcon: IconButton(
                            icon: Icon((invisible == true)
                                ? Icons.visibility_outlined
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                invisible = !invisible;
                              });
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.black38),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.black38),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.redAccent),
                          ),
                          filled: true,
                          fillColor: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      setState(() {
                        ignorePointer = true;
                        ignorePointerTimer = Timer(const Duration(seconds: 2), () {
                          setState(() {
                            ignorePointer = false;
                          });
                        });
                      });
                      // Menjalanan kan logic SignUp
                      editProfile();
                    }
                  },
                  child: Text("Simpan")),
            )
          ],
        )

      ),
    );
  }
}
