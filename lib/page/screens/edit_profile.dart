import 'dart:async';

import 'package:absensi/include/interstisial_ads.dart';
import 'package:absensi/page/auth/login.dart';
import 'package:absensi/system/update_data.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../include/reward_ads.dart';
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

  //variable hitung gaji pokok
  final TextEditingController jumlahLemburController = TextEditingController();
  final TextEditingController totalLemburController = TextEditingController();
  String? valueJamLembur;
  String? gajiPokok;

  // variable waktu kerja
  String? keteranganLembur;

  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  // Form Key untuk Validasi Form Input
  final formkey = GlobalKey<FormState>();

  // ignorePointer agar tidak spam click
  bool ignorePointer = false;
  Timer? ignorePointerTimer;

  // Ads Counter
  int _adViewCount = 0;

  String? nama;
  String? gaji;
  String? no_telepon;

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
        nameController.text = FirebaseAuth.instance.currentUser!.displayName.toString();
        phoneNumberController.text = snapshot['no_telepon'];
        keteranganLembur = snapshot['waktu_lembur'];
        gajiController.text = currencyFormatter.format(snapshot['gaji_pokok']);

        // nameController.text = snapshot.value;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

// Function hitung gaji
  String hitungGaji(jumlah, total) {
    if (totalLemburController.text.isNotEmpty) {
      if (jumlahLemburController.text.isNotEmpty) {
        if (valueJamLembur != null) {
          // gajiPokok = ((int.parse(total) * 173 )/ (int.parse(jumlah) *int.parse(jam)));
          // gajiController.text = currencyFormatter.format(gajiPokok);
          if (valueJamLembur == "Lembur 1") {
            gajiPokok = currencyFormatter.format((int.parse(total) * 173) / (int.parse(jumlah) * 1.5));
            return currencyFormatter.format((int.parse(total) * 173) / (int.parse(jumlah) * 1.5));
          } else if (valueJamLembur == "Lembur 2") {
            gajiPokok = currencyFormatter.format((int.parse(total) * 173) / (int.parse(jumlah) * 2));
            return currencyFormatter.format((int.parse(total) * 173) / (int.parse(jumlah) * 2));
          } else if (valueJamLembur == "Lembur 3") {
            gajiPokok = currencyFormatter.format((int.parse(total) * 173) / (int.parse(jumlah) * 3));
            return currencyFormatter.format((int.parse(total) * 173) / (int.parse(jumlah) * 3));
          } else if (valueJamLembur == "Lembur 4") {
            gajiPokok = currencyFormatter.format((int.parse(total) * 173) / (int.parse(jumlah) * 4));
            return currencyFormatter.format((int.parse(total) * 173) / (int.parse(jumlah) * 4));
          } else {
            return "Rp. 0";
          }
        }
        return "Rp. 0";
      }
      return "Rp. 0";
    }
    return "Rp. 0";
  }

  //function update data
  void editProfile() {
    // Mengubah Controller menjadi String/int
    var name = nameController.text;
    var gajiPokok = int.parse(gajiController.text.replaceAll(RegExp(r'[^0-9]'), ''));
    var noTelepon = phoneNumberController.text;
    var ketLembur = keteranganLembur;

    // Menjadikan Map agar mudah di pindah ke function lain
    var data = {
      'nama': name,
      'no_telepon': noTelepon,
      'waktu_lembur': ketLembur,
      'gaji_pokok': gajiPokok,
    };
    // Menjalankan Logic Class Function Update Profile
    UpdateData.profile(data, id_user, context);
  }

  @override
  void initState() {
    super.initState();
    // Cek User apakah user sudah pernah login sebelumnya
    cekUser();

    //mengeksekusi function sebelum function build
    getPref();
    // Load InterstitialAd Ads
    InterstitialAds.loadAd();
    // Reward Ads
    RewardAds.loadAd();
    _loadAdViewCount();
    setState(() {});
  }

  Future<void> _loadAdViewCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _adViewCount = prefs.getInt('adViewCount') ?? 0;
    });
  }

  Future<void> _incrementAdViewCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int updatedCount = (_adViewCount + 1); // set limit 3 kali sehari
    if (prefs.getString('adViewCountDate') != null) {
      if (prefs.getInt('adViewCount')! >= 1 &&
          DateTime.now().isAfter(DateTime.parse(prefs.getString('adViewCountDate').toString()))) {
        prefs.setString('adViewCountDate', DateTime.now().add(Duration(days: 1)).toString());
        updatedCount = 1;
      }
    } else {
      prefs.setString('adViewCountDate', DateTime.now().add(Duration(days: 1)).toString());
      updatedCount = 1;
    }

    prefs.setInt('adViewCount', updatedCount);
    setState(() {
      _adViewCount = updatedCount;
    });
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
                        Text(
                          "Nama",
                          style: TextStyle(
                            color: Color(0xFF696F79),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
                        Text(
                          "Nomor Telepon",
                          style: TextStyle(
                            color: Color(0xFF696F79),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
                        SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Waktu Lembur",
                          style: TextStyle(
                            color: Color(0xFF696F79),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownSearch<String>(
                          items: [
                            "5 Hari",
                            "6 Hari",
                          ],
                          validator: (value) {
                            if (keteranganLembur == null || value == "") {
                              return "Waktu lembur harus di isi!";
                            }
                            return null;
                          },
                          popupProps: PopupPropsMultiSelection.menu(
                            fit: FlexFit.loose,
                            showSearchBox: false,
                            itemBuilder: (context, item, isSelected) => ListTile(
                              title: Text(
                                item,
                              ),
                            ),
                          ),
                          dropdownBuilder: (context, selectedItem) => Text(
                            keteranganLembur ?? "Pilih Waktu Lembur Anda",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          onChanged: (value) {
                            setState(() {
                              keteranganLembur = value!;
                            });
                          },
                          dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                  enabled: false,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      borderSide: BorderSide(color: Colors.deepPurple, width: 1)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      borderSide: BorderSide(color: Colors.black, width: 1)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      borderSide: BorderSide(color: Colors.redAccent, width: 1)),
                                  filled: true,
                                  fillColor: Colors.white)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Gaji Pokok",
                          style: TextStyle(
                            color: Color(0xFF696F79),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: gajiController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty || value == "") {
                                    return "Gaji Pokok harus di isi!";
                                  }
                                  return null;
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
                                decoration: InputDecoration(
                                  filled: true,
                                  // enabled: false,
                                  fillColor: const Color(0xFFFCFDFE),
                                  hintText: "Gaji Pokok",
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF696F79),
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(13),
                                    borderSide: const BorderSide(width: 1, color: Color(0xFFDEDEDE)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 1, color: Colors.redAccent),
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                              width: 100,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                    backgroundColor: MaterialStateProperty.all(Color(0xFF2FA4D9)),
                                    foregroundColor: MaterialStateProperty.all(Colors.white),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(builder: (context, setState) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(10))),
                                            insetPadding: EdgeInsets.all(10),
                                            backgroundColor: Colors.white,
                                            elevation: 1,
                                            child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Jumlah Lembur",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: Color(0xFF696F79),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    controller: jumlahLemburController,
                                                    keyboardType: TextInputType.number,
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty || value == "") {
                                                        return "Jumlah Lembur harus di isi!";
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {
                                                      setState(() {
                                                        jumlahLemburController.text = value;
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: const Color(0xFFFCFDFE),
                                                      suffixText: "Jam",
                                                      suffixStyle: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.blue),
                                                      hintText: "Masukan Jumlah Lembur Anda",
                                                      hintStyle: const TextStyle(
                                                        color: Color(0xFF696F79),
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                      isDense: true,
                                                      contentPadding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(13),
                                                        borderSide:
                                                            const BorderSide(width: 1, color: Color(0xFFDEDEDE)),
                                                      ),
                                                      errorBorder: OutlineInputBorder(
                                                        borderSide: const BorderSide(width: 1, color: Colors.redAccent),
                                                        borderRadius: BorderRadius.circular(13),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Text(
                                                    "Total Lembur",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: Color(0xFF696F79),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    controller: totalLemburController,
                                                    keyboardType: TextInputType.number,
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty || value == "") {
                                                        return "Total Lembur harus di isi!";
                                                      }
                                                      return null;
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
                                                    onChanged: (value) {
                                                      setState(() {
                                                        totalLemburController.text = value;
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: const Color(0xFFFCFDFE),
                                                      hintText: "Masukan Total Lembur Anda",
                                                      hintStyle: const TextStyle(
                                                        color: Color(0xFF696F79),
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                      isDense: true,
                                                      contentPadding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(13),
                                                        borderSide:
                                                            const BorderSide(width: 1, color: Color(0xFFDEDEDE)),
                                                      ),
                                                      errorBorder: OutlineInputBorder(
                                                        borderSide: const BorderSide(width: 1, color: Colors.redAccent),
                                                        borderRadius: BorderRadius.circular(13),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Text(
                                                    "Jam Lembur",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: Color(0xFF696F79),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  DropdownSearch<String>(
                                                    items: [
                                                      "Lembur 1",
                                                      "Lembur 2",
                                                      "Lembur 3",
                                                      "Lembur 4",
                                                    ],
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty || value == "") {
                                                        return "Jam lembur harus di isi!";
                                                      }
                                                      return null;
                                                    },
                                                    popupProps: PopupPropsMultiSelection.menu(
                                                      fit: FlexFit.loose,
                                                      showSearchBox: false,
                                                      itemBuilder: (context, item, isSelected) => ListTile(
                                                        title: Text(
                                                          item,
                                                        ),
                                                      ),
                                                    ),
                                                    dropdownBuilder: (context, selectedItem) => Text(
                                                      valueJamLembur ?? "Pilih Jam Lembur Anda",
                                                      style: TextStyle(fontSize: 15, color: Colors.black),
                                                    ),
                                                    onChanged: (value) {
                                                      print(value);
                                                      setState(() {
                                                        valueJamLembur = value!;
                                                      });
                                                    },
                                                    dropdownDecoratorProps: DropDownDecoratorProps(
                                                        dropdownSearchDecoration: InputDecoration(
                                                            enabled: false,
                                                            focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(13),
                                                                borderSide:
                                                                    BorderSide(color: Colors.deepPurple, width: 1)),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(13),
                                                                borderSide: BorderSide(color: Colors.black, width: 1)),
                                                            errorBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(13),
                                                                borderSide:
                                                                    BorderSide(color: Colors.redAccent, width: 1)),
                                                            filled: true,
                                                            fillColor: Colors.white)),
                                                  ),
                                                  // TextFormField(
                                                  //   controller: jamLemburController,
                                                  //   keyboardType: TextInputType.number,
                                                  //   validator: (value) {
                                                  //     if (value == null || value.isEmpty || value == "") {
                                                  //       return "Jam Lembur harus di isi!";
                                                  //     }
                                                  //     return null;
                                                  //   },
                                                  //   decoration: InputDecoration(
                                                  //     filled: true,
                                                  //     fillColor: const Color(0xFFFCFDFE),
                                                  //     hintText: "Masukan Jam Lembur Anda",
                                                  //     hintStyle: const TextStyle(
                                                  //       color: Color(0xFF696F79),
                                                  //       fontSize: 14,
                                                  //       fontWeight: FontWeight.w400,
                                                  //     ),
                                                  //     isDense: true,
                                                  //     contentPadding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                                                  //     border: OutlineInputBorder(
                                                  //       borderRadius: BorderRadius.circular(13),
                                                  //       borderSide: const BorderSide(width: 1, color: Color(0xFFDEDEDE)),
                                                  //     ),
                                                  //     errorBorder: OutlineInputBorder(
                                                  //       borderSide: const BorderSide(width: 1, color: Colors.redAccent),
                                                  //       borderRadius: BorderRadius.circular(13),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Divider(),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "Gaji Pokok = ${hitungGaji(
                                                      jumlahLemburController.text,
                                                      totalLemburController.text.replaceAll(RegExp(r'[^0-9]'), ''),
                                                    )}",
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10))),
                                                        backgroundColor: MaterialStateProperty.all(Color(0xFF2FA4D9)),
                                                        foregroundColor: MaterialStateProperty.all(Colors.white),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                        gajiController.text = gajiPokok!;
                                                        setState(() {});
                                                      },
                                                      child: Text("Simpan"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                    );
                                  },
                                  child: Text(
                                    "Hitung",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            )
                          ],
                        ),

                        // Container(
                        //   margin: EdgeInsets.symmetric(vertical: 5),
                        //   width: double.infinity,
                        //   height: 50,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(15),
                        //   ),
                        //   child: TextFormField(
                        //     controller: gajiController,
                        //     keyboardType: TextInputType.number,
                        //     onChanged: (value) {
                        //       setState(() {});
                        //     },
                        //     inputFormatters: [
                        //       FilteringTextInputFormatter.digitsOnly,
                        //       LengthLimitingTextInputFormatter(10),
                        //       CurrencyTextInputFormatter(
                        //         locale: 'ID',
                        //         decimalDigits: 0,
                        //         symbol: 'Rp. ',
                        //       ),
                        //     ],
                        //     validator: (value) {
                        //       if (value == null || value.isEmpty || value == "") {
                        //         return "Gaji Pokok harus di isi!";
                        //       }
                        //       return null;
                        //     },
                        //     decoration: InputDecoration(
                        //         contentPadding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                        //         hintText: "Gaji Pokok",
                        //         hintStyle: TextStyle(fontSize: 13),
                        //         enabledBorder: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(15),
                        //           borderSide: BorderSide(width: 1, color: Colors.black38),
                        //         ),
                        //         focusedBorder: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(15),
                        //           borderSide: BorderSide(width: 1, color: Colors.black38),
                        //         ),
                        //         errorBorder: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(15),
                        //           borderSide: BorderSide(width: 1, color: Colors.redAccent),
                        //         ),
                        //         filled: true,
                        //         fillColor: Colors.white),
                        //   ),
                        // ),
                      ],
                    ),
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
                            EasyLoading.show(status: "Loading...");
                            if (_adViewCount < 3) {
                              Future.delayed(Duration(seconds: 3), () async {
                                await RewardAds.rewardedInterstitialAd!.show(
                                    onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) async {
                                  // Reward the user for watching an ad.

                                  await _incrementAdViewCount();
                                  RewardAds.loadAd();
                                  editProfile();
                                }).then(
                                  (value) {
                                    EasyLoading.dismiss();
                                  },
                                );
                              }).then((value) {
                                print(value);
                                EasyLoading.dismiss();
                              });
                            } else {
                              editProfile();
                            }
                          }
                        },
                        child: Text("Simpan")),
                  )
                ],
              )),
        ));
  }
}
