import 'dart:async';

import 'package:absensi/include/interstisial_ads.dart';
import 'package:absensi/page/auth/login.dart';
import 'package:absensi/system/update_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../system/insert_data.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String id_user = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController gajiController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  // Form Key untuk Validasi Form Input
  final formkey = GlobalKey<FormState>();

  // ignorePointer agar tidak spam click
  bool ignorePointer = false;
  Timer? ignorePointerTimer;

  String? nama;
  String? gaji;
  String? no_telepon;

  // format bilangan kedalam mata uang
  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

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
        nameController.text = snapshot['nama'];
        gajiController.text = snapshot['gaji_pokok'].toString();
        phoneNumberController.text = snapshot['no_telepon'];

        // nameController.text = snapshot.value;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
  //function update data
  void editProfile() {
    // Mengubah Controller menjadi String/int
    var name = nameController.text;
    var gajiPokok = int.parse(gajiController.text.replaceAll(RegExp(r'[^0-9]'), ''));
    var noTelepon = phoneNumberController.text;
   // Menjadikan Map agar mudah di pindah ke function lain
    var data = {
      'nama': name,
      'gaji_pokok': gajiPokok,
      'no_telepon': noTelepon,
    };
    // Menjalankan Logic Class Function Update Profile
    UpdateData.profile(data, id_user, context);
  }

  @override
  void initState() {
    super.initState();
    print("asdad");
    // Cek User apakah user sudah pernah login sebelumnya
    cekUser();

    //mengeksekusi function sebelum function build
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
          "Edit Profile",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        foregroundColor: Colors.white,
      ),
      body: IgnorePointer(
        // Boolean ignorePointer agar tidak spam click
        ignoring: ignorePointer,
        child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(

              children: [
                Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nama"),
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
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() {});
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty || value == "") {
                              return "Nama harus di isi!";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                              hintText: "Nama",
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
                      Text("Nomor Telepon"),
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
                          controller: phoneNumberController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {});
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty || value == "") {
                              return "Nomor Telepon harus di isi!";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                              hintText: "Nomor Telepon",
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
                      Text("Gaji Pokok"),
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
                          controller: gajiController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {});
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                            CurrencyTextInputFormatter(
                              locale: 'ID',
                              decimalDigits: 0,
                              symbol: 'Rp. ',
                            ),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty || value == "") {
                              return "Gaji Pokok harus di isi!";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                              hintText: "Gaji Pokok",
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
                          // Menjalanan kan logic SignUp
                          editProfile();
                        }

                      },
                      child: Text("Simpan")),
                )
              ],
            )
        ),
      )
    );
  }
}
