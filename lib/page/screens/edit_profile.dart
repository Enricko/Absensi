import 'package:absensi/include/interstisial_ads.dart';
import 'package:absensi/page/auth/login.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  
  Future<void> getPref() async {
    ///Inisiasi database local (SharedPreference)
    SharedPreferences pref = await SharedPreferences.getInstance();

    ///Mengambil data dari database local
    ///dan memasukan nya ke variable id_user
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
          "Edit Profile",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
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
                    return "Jam Lembur harus di isi!";
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
          ],
        ),
      ),
    );
  }
}