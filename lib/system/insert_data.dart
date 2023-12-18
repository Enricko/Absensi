import "package:absensi/page/menu.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:intl/intl.dart";

class InsertData {
  // Insert Data Lembur Logic Functions
  static lembur(Map<dynamic, dynamic> data, String id_user, BuildContext context) async {
    // Menjalankan block code di dalam agar kita mengetahui jika code tersebut errored
    try {
      // UI Loading
      EasyLoading.show(status: 'loading...');
      // Insert data lembur ke Firebase Database
      FirebaseDatabase.instance
          .ref()
          .child("lembur")
          .child(id_user)
          .child(DateFormat('yyyy-MM', 'id')
              .format(DateFormat('EEEE, dd MMMM yyyy', "id").parse(data['tanggal'])))
          .push()
          .set(data)
          .whenComplete(() {
        // Menampilkan alert berhasil jika codingan di atas berhasil dan selesai
        EasyLoading.showSuccess('Lembur telah di tambahkan',
            dismissOnTap: true, duration: const Duration(seconds: 5));
        Navigator.pop(context);
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Menu()));
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
