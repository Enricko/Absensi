import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:intl/intl.dart";

class InsertData {
  static lembur(Map<dynamic, dynamic> data,String id_user, BuildContext context) async {
    FirebaseDatabase.instance.ref().child("lembur").child(id_user).child(DateFormat('MMMM yyyy', "id").format(DateTime.now())).push().set(data).whenComplete(() {
      EasyLoading.showSuccess('Menu telah di tambahkan', dismissOnTap: true);
      Navigator.pop(context);
      return;
    });
  }
}
