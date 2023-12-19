import 'dart:async';

import 'package:absensi/include/interstisial_ads.dart';
import 'package:absensi/page/auth/login.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../system/update_data.dart';

class EditEmail extends StatefulWidget {
  const EditEmail({Key? key}) : super(key: key);

  @override
  State<EditEmail> createState() => _EditEmailState();
}

class _EditEmailState extends State<EditEmail> {
  String id_user = "";
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Form Key untuk Validasi Form Input
  final formkey = GlobalKey<FormState>();

  // ignorePointer agar tidak spam click
  bool ignorePointer = false;
  Timer? ignorePointerTimer;

  Future<void> getPref() async {
    //Inisiasi database local (SharedPreference)
    SharedPreferences pref = await SharedPreferences.getInstance();

    //Mengambil data dari database local
    //dan memasukan nya ke variable id_user
    setState(() {
      id_user = pref.getString('id_user')!;
    });

    // Get All data users from firebase database
    setState(() {
      getUserFromFirebase();
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

  // function get data dari firebase
  Future<void> getUserFromFirebase() async {
    try {
      FirebaseDatabase.instance
          .ref()
          .child("user") // Parent di database
          .child(id_user) // Id user
          .onValue
          .listen((event) {
        var snapshot = event.snapshot.value as Map;
        // emailController.text = FirebaseAuth.instance.currentUser!.email!;

        // nameController.text = snapshot.value;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  //function update data
  void editEmail() {
    // Menjadikan Map agar mudah di pindah ke function lain
    var data = {
      'email': emailController.text,
      'password': passwordController.text
    };
    // Menjalankan Logic Class Function Update Email
    UpdateData.email(data, id_user, context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Edit Email",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        foregroundColor: Colors.white,
      ),
      body: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email Baru"),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty || value == "") {
                            return "Jam Lembur harus di isi!";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                            hintText: "Email Baru",
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
                    SizedBox(height: 5,),
                    Text("Password"),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty || value == "") {
                            return "Jam Lembur harus di isi!";
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
                        // Menjalanan kan logic Edit Email
                        editEmail();
                      }
                    },
                    child: Text("Kirim Email Verifikasi")),
              )
            ],
          )),
    );
  }
}
