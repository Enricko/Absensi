import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController gajiController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
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
