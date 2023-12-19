import "package:absensi/page/auth/login.dart";
import "package:absensi/page/menu.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:intl/intl.dart";

class UpdateData {
  static profile(Map<String, dynamic> data, String id_user, BuildContext context) async {
    // Menjalankan block code di dalam agar kita mengetahui jika code tersebut errored
    try {
      // UI Loading
      EasyLoading.show(status: 'loading...');

      // Setting Nama di firebase Authentication
      await FirebaseAuth.instance.currentUser!.updateDisplayName(data['nama']);

      // Update data profile ke Firebase Database
      FirebaseDatabase.instance.ref().child("user").child(id_user).update({
        "no_telepon": data['no_telepon'],
        "gaji_pokok": data['gaji_pokok'],
      }).whenComplete(() {
        // Menampilkan alert berhasil jika codingan di atas berhasil dan selesai
        EasyLoading.showSuccess('Profile telah di Edit',
            dismissOnTap: true, duration: const Duration(seconds: 5));
        Navigator.pop(context);
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Menu(indexPage: 2)));
        return;
      }).onError((error, stackTrace) {
        EasyLoading.showError("Something went wrong : $error",
            dismissOnTap: true, duration: const Duration(seconds: 5));
      });
    } on Exception catch (e) {
      // Menampilkan error yang terjadi pada block code di atas
      EasyLoading.showError('Ada Sesuatu Kesalahan : $e',
          dismissOnTap: true, duration: const Duration(seconds: 5));
    }
  }

  static email(Map<String, dynamic> data, String id_user, BuildContext context) async {
    // Menjalankan block code di dalam agar kita mengetahui jika code tersebut errored
    try {
      // UI Loading
      EasyLoading.show(status: 'loading...');
      // Get Current User
      final user = FirebaseAuth.instance.currentUser;
      final cred = EmailAuthProvider.credential(email: user!.email!, password: data['password']);

      await user.reauthenticateWithCredential(cred).then((value) async {
        // Update Email by Verification pada Firebase Auth
        await user.verifyBeforeUpdateEmail(data['email']).then((value) {
          // Menampilkan alert berhasil jika codingan di atas berhasil dan selesai
          EasyLoading.showSuccess('Mohon cek Email Verifikasi untuk aktivasi Email Baru',
              dismissOnTap: true, duration: const Duration(seconds: 5));
          Navigator.pop(context);
          return;
        }).onError((error, stackTrace) {
          // Menampilkan error yang terjadi pada block code di atas
          EasyLoading.showError('Ada Sesuatu Kesalahan : $error',
              dismissOnTap: true, duration: const Duration(seconds: 5));
        });
      }).onError((error, stackTrace) {
        EasyLoading.showError("Password Anda Salah",
            dismissOnTap: true, duration: const Duration(seconds: 5));
      });
    } on Exception catch (e) {
      // Menampilkan error yang terjadi pada block code di atas
      EasyLoading.showError('Ada Sesuatu Kesalahan : $e',
          dismissOnTap: true, duration: const Duration(seconds: 5));
    }
  }

  static password(Map<String, dynamic> data, String id_user, BuildContext context) async {
    // Menjalankan block code di dalam agar kita mengetahui jika code tersebut errored
    try {
      // UI Loading
      EasyLoading.show(status: 'loading...');

      // Get Current User
      final user = FirebaseAuth.instance.currentUser;
      // User Credentials
      final cred =
          EmailAuthProvider.credential(email: user!.email!, password: data['old_password']);
      // Update data profile ke Firebase Database
      await user.reauthenticateWithCredential(cred).then((value) async {
        await user.updatePassword(data['new_password']).then((_) {
          // Menampilkan alert berhasil jika codingan di atas berhasil dan selesai
          EasyLoading.showSuccess('Password telah di Edit',
              dismissOnTap: true, duration: const Duration(seconds: 5));
          Navigator.pop(context);
          return;
        }).onError((error, stackTrace) {
          EasyLoading.showError("Something went wrong : $error",
              dismissOnTap: true, duration: const Duration(seconds: 5));
        });
      }).onError((error, stackTrace) {
        EasyLoading.showError("Password Lama Salah",
            dismissOnTap: true, duration: const Duration(seconds: 5));
      });
    } on Exception catch (e) {
      // Menampilkan error yang terjadi pada block code di atas
      EasyLoading.showError('Ada Sesuatu Kesalahan : $e',
          dismissOnTap: true, duration: const Duration(seconds: 5));
    }
  }

  static forgetPassword(String email, BuildContext context) async {
    try {
      EasyLoading.show(status: 'loading...');
      // Forget Password
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email).whenComplete(() {

        EasyLoading.showSuccess('Email reset password telah di kirim ke email tujuan!',
            dismissOnTap: true);
        Navigator.pop(context);
      }).onError((error, stackTrace){
        EasyLoading.showError("Email yang anda masukkan tidak ditemukan / tidak valid",
            dismissOnTap: true, duration: const Duration(seconds: 5));
      });
    } on Exception catch (e) {
      // Menampilkan error yang terjadi pada block code di atas
      EasyLoading.showError('Ada Sesuatu Kesalahan : $e',
          dismissOnTap: true, duration: const Duration(seconds: 5));
    }
  }
}
