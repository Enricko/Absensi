import "package:absensi/page/menu.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:intl/intl.dart";

class UpdateData {
  static profile(Map<String,dynamic> data, String id_user, BuildContext context) async {
    // Menjalankan block code di dalam agar kita mengetahui jika code tersebut errored
    try {
      // UI Loading
      EasyLoading.show(status: 'loading...');
      // Update data profile ke Firebase Database
      FirebaseDatabase.instance
          .ref()
          .child("user")
          .child(id_user)
          .update(data)
          .whenComplete(() {
        // Menampilkan alert berhasil jika codingan di atas berhasil dan selesai
        EasyLoading.showSuccess('Profile telah di Edit',
            dismissOnTap: true, duration: const Duration(seconds: 5));
        Navigator.pop(context);
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

  static email(Map<String,dynamic> data, String id_user, BuildContext context) async {
    // Menjalankan block code di dalam agar kita mengetahui jika code tersebut errored
    try {
      // UI Loading
      EasyLoading.show(status: 'loading...');
      // Update data profile ke Firebase Database
      FirebaseDatabase.instance
          .ref()
          .child("user")
          .child(id_user)
          .update(data)
          .whenComplete(() {
        // Menampilkan alert berhasil jika codingan di atas berhasil dan selesai
        EasyLoading.showSuccess('Email telah di Edit',
            dismissOnTap: true, duration: const Duration(seconds: 5));
        Navigator.pop(context);
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

  static password(Map<String,dynamic> data, String id_user, BuildContext context) async {
    // Menjalankan block code di dalam agar kita mengetahui jika code tersebut errored
    try {
      // UI Loading
      EasyLoading.show(status: 'loading...');
      // Update data profile ke Firebase Database
      FirebaseDatabase.instance
          .ref()
          .child("user")
          .child(id_user)
          .update(data)
          .whenComplete(() {
        // Menampilkan alert berhasil jika codingan di atas berhasil dan selesai
        EasyLoading.showSuccess('Password telah di Edit',
            dismissOnTap: true, duration: const Duration(seconds: 5));
        Navigator.pop(context);
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
}


