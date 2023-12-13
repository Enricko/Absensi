import 'package:absensi/page/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  // Login Logic Functions
  static login(Map<dynamic, dynamic> data, BuildContext context) async {}

  // SignUp Logic Functions
  static signUp(Map<dynamic, dynamic> data, BuildContext context) async {
    // UI Loading
    EasyLoading.show(status: 'loading...');

    // Initialize Firebase Authentication
    FirebaseApp app =
        await Firebase.initializeApp(name: 'AuthUser', options: Firebase.app().options);

    // Insert User to FirebaseAuth
    await FirebaseAuth.instanceFor(app: app)
        .createUserWithEmailAndPassword(email: data['email'], password: data['password'])
        .then((value) {
      // Insert User to database
      FirebaseDatabase.instance.ref().child("user").child(value.user!.uid).set({
        "nama": data['nama'],
        "email": data['email'],
        "no_telepon": data['no_telepon'],
        "gaji_pokok": data['gaji_pokok'],
      }).whenComplete(() {
        // Jika logic telah selesai berjalan, kode yang di bawah ini bakal jalan
        EasyLoading.showSuccess('Tambah Akun Berhasil',
            dismissOnTap: true, duration: const Duration(seconds: 5));
        // Mengarah ke Login Page jika Sign Up Berhasil
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }).onError((error, stackTrace) {
        // Jika logic mengalami error, kode yang di bawah ini bakal jalan
        EasyLoading.showError('Something went wrong : $error',
            dismissOnTap: true, duration: const Duration(seconds: 5));
      });
    }).onError((error, stackTrace) {
      // Jika logic mengalami error, kode yang di bawah ini bakal jalan
      EasyLoading.showError('Something went wrong : $error',
          dismissOnTap: true, duration: const Duration(seconds: 5));
    });
  }
}
