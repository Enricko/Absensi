import 'dart:async';

import 'package:absensi/include/interstisial_ads.dart';
import 'package:absensi/page/auth/login.dart';
import 'package:absensi/system/insert_data.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormAbsensi extends StatefulWidget {
  const FormAbsensi({Key? key}) : super(key: key);

  @override
  State<FormAbsensi> createState() => _FormAbsensiState();
}

class _FormAbsensiState extends State<FormAbsensi> {
  // Form Key untuk Validasi Form Input
  final formkey = GlobalKey<FormState>();

  // ignorePointer agar tidak spam click
  bool ignorePointer = false;
  Timer? ignorePointerTimer;

  // Set ID_User ke variable
  String id_user = "";
  int totalGajiLembur = 0;

  // deklarasi per rumus lembur
  int lembur1 = 0;
  double totalLembur1 = 0;
  int lembur2 = 0;
  double totalLembur2 = 0;

  // variable boolean
  bool isMasuk = true;

  // Form Input Controller
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  int selectedRadio = 0;
  final String locale = 'id';
  String? keterangan;

  // Format Currency
  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  String totalLembur(int gajiPokok) {
    if (timeController.text != "") {
      // Lembur jam pertama
      var a = 1 * 1.5 * gajiPokok * (1 / 173);
      // Lembur jam kedua dan lembur di hari libur
      var b = (int.parse(timeController.text) - 1) * 2 * gajiPokok * (1 / 173);
      // Lembur Di hari biasa
      var hariBiasa = currencyFormatter.format(a + b);

      // Lembur Di hari libur
      var hariLibur =
          currencyFormatter.format(int.parse(timeController.text) * 2 * gajiPokok * (1 / 173));

      // Lembur Di hari libur
      if (keterangan == "Hari Libur") {
        return "$hariLibur";
      }
      // Lembur Di hari biasa
      else if (keterangan == "Hari Biasa") {
        return "$hariBiasa";
      } else {
        return "Rp. 0";
      }
    }
    return "Rp. 0";

    // if (timeController.text != "") {
    //   var lembur1 = 1 * 1.5 * (1 / 173) * gajiPokok;
    //
    //   var lembur2 =
    //   currencyFormatter.format(int.parse(timeController.text) * 2 * (1 / 173) * gajiPokok);
    //
    //   var lembur3 = currencyFormatter
    //       .format(lembur1 + (int.parse(timeController.text) - 1) * 2 * (1 / 173) * gajiPokok);
    //   if (dateController.text != '') {
    //     // Format Date
    //     var dateFormat = DateFormat.EEEE('id')
    //         .format(DateFormat('EEEE, dd MMMM yyyy', "id").parse(dateController.text));
    //     // Jika Sabtu/Minggu maka return di bawah ini
    //     if (dateFormat == 'Minggu' || dateFormat == 'Sabtu') {
    //       return "$lembur2";
    //     }
    //   }
    //   return "$lembur3";
    // }
    // return "Rp. 0";
  }

   resultLembur(int gajiPokok) {
    if (timeController.text != "") {
      // rumus lembur 1
      var a = 1 * 1.5 * gajiPokok * (1 / 173);
      // rumus lembur 2
      var b = (int.parse(timeController.text) - 1) * 2 * gajiPokok * (1 / 173);

      // Lembur Di hari libur
      if (keterangan == "Hari Libur") {
        lembur2 = int.parse(timeController.text);
        totalLembur2 = (int.parse(timeController.text) * 2 * gajiPokok * (1 / 173));
      }
      // Lembur Di hari biasa
      else if (keterangan == "Hari Biasa") {
        lembur1 = 1;
        lembur2 = int.parse(timeController.text) - 1;
        totalLembur1 = a;
        totalLembur2 = b;
      }
    }
  }

  void simpanLembur() {
    var date = dateController.text != ''
        ? dateController.text
        : DateFormat('EEEE, dd MMMM yyyy', "id").format(DateTime.now());
    var time = timeController.text != '' ? timeController.text : "0";
    var absensi = "${selectedRadio != 1 ? 'Masuk' : 'Tidak Masuk'}";
    var total = totalGajiLembur;

    var data = {
      'tanggal': date,
      'absensi': absensi,
      'keterangan': keterangan,
      'lembur': int.parse(time),
      'total': total,
      'lembur1' :lembur1,
      'lembur2' :lembur2,
      "totalLembur1" :totalLembur1,
      "totalLembur2" :totalLembur2,
    };
    print(lembur1);
    print(lembur2);
    InsertData.lembur(data, id_user, context);
  }

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
          "Absensi",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        foregroundColor: Colors.white,
      ),
      body: IgnorePointer(
        ignoring: ignorePointer,
        child: Padding(
          padding: EdgeInsets.all(24),
          // efek scrolling
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Silahkan lengkapi formulir dibawah ini untuk mengisi absensi lemburan"),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Apakah Anda masuk lemburan Hari ini?"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio(
                        activeColor: Colors.blue,
                        value: 0,
                        groupValue: selectedRadio,
                        onChanged: (value) {
                          setState(() {
                            selectedRadio = value!;
                            isMasuk = true;
                          });
                        },
                      ),
                      Text('Masuk'),
                      SizedBox(width: 16.0),
                      // Adjust the spacing between radio buttons
                      Radio(
                        activeColor: Colors.blue,
                        value: 1,
                        groupValue: selectedRadio,
                        onChanged: (value) {
                          setState(() {
                            selectedRadio = value!;
                            isMasuk = false;
                            timeController.clear();
                          });
                        },
                      ),
                      Text('Tidak Masuk'),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: isMasuk,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tanggal Lembur"),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () async {
                            showDatePicker(
                              context: context,
                              locale: const Locale("id", "ID"),
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1945),
                              lastDate: DateTime(2030),
                              initialEntryMode: DatePickerEntryMode.calendarOnly,
                            ).then((value) {
                              if (value != null) {
                                //format tanggal hari, tanggal bulan tahun dalam bahasa indonesia
                                String formatDate =
                                    DateFormat('EEEE, dd MMMM yyyy', "id").format(value);
                                setState(() {
                                  dateController.text = formatDate;
                                });
                              }
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextFormField(
                              controller: dateController,
                              enabled: false,
                              validator: (value) {
                                if (value == null || value.isEmpty || value == "") {
                                  return "Tanggal Lembur harus di isi!";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(10, 3, 1, 3),
                                  hintText: "Pilih Tanggal Lemburan Anda",
                                  hintStyle: TextStyle(fontSize: 13),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: SvgPicture.asset(
                                      "assets/Calendar.svg",
                                      color: Colors.black38,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
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
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Keterangan Lembur"),
                        SizedBox(
                          height: 15,
                        ),
                        DropdownSearch<String>(
                          items: [
                            "Hari Biasa",
                            "Hari Libur",
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty || value == "") {
                              return "Keterangan lembur harus di isi!";
                            }
                            return null;
                          },
                          popupProps: PopupPropsMultiSelection.menu(
                            fit: FlexFit.loose,
                            showSearchBox: false,
                            itemBuilder: (context, item, isSelected) => ListTile(
                              title: Text(item),
                            ),
                          ),
                          dropdownBuilder: (context, selectedItem) => Text(
                            keterangan ?? "Pilih Keterangan Lembur Anda",
                            style: TextStyle(fontSize: 15, color: Colors.black38),
                          ),
                          onChanged: (value) {
                            setState(() {
                              keterangan = value!;
                            });
                          },
                          dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                            enabled: false,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide: BorderSide(color: Colors.blue, width: 1)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide: BorderSide(color: Colors.black38, width: 1)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide: BorderSide(color: Colors.redAccent, width: 1)),
                          )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Berapa Jam Lembur?"),
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
                            enabled: isMasuk,
                            controller: timeController,
                            keyboardType: TextInputType.number,
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
                                hintText: "Masukan Jam Lembur",
                                hintStyle: TextStyle(fontSize: 13),
                                suffixText: "Jam",
                                suffixStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(width: 1, color: Colors.black38),
                                ),
                                disabledBorder: OutlineInputBorder(
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
                  // ! Perkiraan tidak di butuhkan

                  // SizedBox(
                  //   height: 10,
                  // ),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: OutlinedButton(
                  //     style: ButtonStyle(
                  //         shape: MaterialStateProperty.all(
                  //           RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(12),
                  //           ),
                  //         ),
                  //         side: MaterialStateProperty.all(BorderSide(color: Colors.blue)),
                  //         foregroundColor: MaterialStateProperty.all(Colors.blue)),
                  //     onPressed: () {
                  //       setState(() {});
                  //     },
                  //     child: Text(
                  //       "Hitung Lemburan Saya",
                  //       style: TextStyle(fontSize: 15),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 15,
                  ),
                  Text("HASIL PERHITUNGAN"),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border(
                            left: BorderSide(width: 1, color: Color(0xFF2FA4D9)),
                            top: BorderSide(width: 11, color: Color(0xFF2FA4D9)),
                            right: BorderSide(width: 1, color: Color(0xFF2FA4D9)),
                            bottom: BorderSide(width: 1, color: Color(0xFF2FA4D9)),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/Calendar.svg",
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                    child: Text(
                                  "Tanggal",
                                  style: TextStyle(color: Colors.black38),
                                )),
                                Text(

                                    ///kalau tidak masuk lembur , tanggal akan otomatis set pada hari itu
                                    (isMasuk == false)
                                        ? DateFormat('EEEE, dd MMMM yyyy', 'id')
                                            .format(DateTime.now())

                                        ///apabila tanggal lembur bernilai "" maka akan otomatis set ke tanggal pada hari itu
                                        : dateController.text == ""
                                            ? DateFormat('EEEE, dd MMMM yyyy', 'id')
                                                .format(DateTime.now())
                                            : dateController.text
                                    // "${dateController.text == '' ? 'Senin, 1 Januari 2000' : dateController.text}"
                                    ),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/Fingerprint.svg",
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                    child: Text(
                                  "Absensi",
                                  style: TextStyle(color: Colors.black38),
                                )),
                                Text(
                                    "${selectedRadio == 0 ? 'Masuk (${keterangan})' : 'Tidak Masuk'}"),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/ClockClockwise.svg",
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                    child: Text(
                                  "Lembur",
                                  style: TextStyle(color: Colors.black38),
                                )),
                                Text((selectedRadio == 2)
                                    ? "0 Jam"
                                    : timeController.text == ''
                                        ? '0'
                                        : "${timeController.text} Jam"),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/u_money-stack.svg",
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    "Total",
                                    style: TextStyle(color: Colors.black38),
                                  ),
                                ),
                                StreamBuilder(
                                  stream: FirebaseDatabase.instance
                                      .ref()
                                      .child("user")
                                      .child(id_user)
                                      .onValue,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        (snapshot.data! as DatabaseEvent).snapshot.value != null) {
                                      Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(
                                          (snapshot.data! as DatabaseEvent).snapshot.value
                                              as Map<dynamic, dynamic>);
                                      if (data['gaji_pokok'] != null) {
                                        totalGajiLembur = int.parse(
                                            totalLembur(data['gaji_pokok'])
                                                .replaceAll(RegExp(r'[^0-9]'), ''));
                                        resultLembur(data['gaji_pokok']);
                                        return Text(
                                          "${totalLembur(data['gaji_pokok'])}",
                                          style: TextStyle(color: Colors.blue),
                                        );
                                      }
                                      return Text(
                                        "Rp. 0",
                                        style: TextStyle(color: Colors.blue),
                                      );
                                    }
                                    return Text(
                                      "Rp. 0",
                                      style: TextStyle(color: Colors.blue),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
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
                            // Menjalanan kan logic Simpan data lembur
                            simpanLembur();
                          }
                        },
                        child: Text("Simpan")),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
