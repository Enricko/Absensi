import 'dart:async';

import 'package:absensi/include/interstisial_ads.dart';
import 'package:absensi/page/auth/login.dart';
import 'package:absensi/page/screens/bulanan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../include/reward_ads.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  TextEditingController filterSearchController = TextEditingController();
  String id_user = "";

  List<int> years = [DateTime.now().year];
  int selectedYear = DateTime.now().year;

  // Format Currency
  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

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
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()));
      });
    }
  }

  int _adViewCount = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Cek User apakah user sudah pernah login sebelumnya
    cekUser();

    ///mengeksekusi function sebelum function build
    getPref();
    // Load InterstitialAd Ads
    InterstitialAds.loadAd();
    // Reward Ads
    RewardAds.loadAd();
    _loadAdViewCount();
    _timer = Timer.periodic(Duration(days: 1), (timer) {
      _resetAdViewCount();
    });
    setState(() {});
  }

  Future<void> _resetAdViewCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('adViewCount', 0);
    setState(() {
      _adViewCount = 0;
    });
  }

  Future<void> _loadAdViewCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _adViewCount = prefs.getInt('adViewCount') ?? 0;
    });
  }

  Future<void> _incrementAdViewCount() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int updatedCount = (_adViewCount + 1) % 4; // set limit 3 kali sehari
    prefs.setInt('adViewCount', updatedCount);
    setState(() {
      _adViewCount = updatedCount;
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "History Tahunan",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
                      child: TextFormField(
                        controller: filterSearchController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 3, 1, 3),
                            hintText: "Cari Lemburanmu",
                            hintStyle: TextStyle(fontSize: 13),
                            prefix: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: SvgPicture.asset(
                                "assets/Search.svg",
                                color: Colors.black38,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black38),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black38),
                            ),
                            filled: true,
                            fillColor: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Pilih Tahun",
                                style: TextStyle(fontSize: 16),
                              ),
                              DropdownButton<int>(
                                value: selectedYear,
                                onChanged: (value) {
                                  setState(() {
                                    selectedYear = value!;
                                  });
                                },
                                items: years
                                    .map<DropdownMenuItem<int>>((int year) {
                                  return DropdownMenuItem<int>(
                                    value: year,
                                    child: Text('$year'),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: StreamBuilder(
                              // Query untuk mengambil data pada firebase
                              stream: FirebaseDatabase.instance
                                  .ref()
                                  .child("lembur") // Parent di database
                                  .child(id_user) // Id user
                                  .onValue,
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    (snapshot.data!).snapshot.value != null) {
                                  // Variable data mempermudah memanggil data pada database
                                  Map<dynamic, dynamic> data =
                                      Map<dynamic, dynamic>.from(
                                          (snapshot.data! as DatabaseEvent)
                                              .snapshot
                                              .value as Map<dynamic, dynamic>);
                                  // Mengubah map menjadi list
                                  List<Map<dynamic, dynamic>> dataList = [];

                                  // Memperulangkan data menggunakan foreach
                                  data.forEach((key, value) {
                                    // Mensetting variable dengan total lembur dan gaji)

                                    // Filter Tahun History
                                    var parseDateyear =
                                        DateFormat("yyyy", 'id').parse(key);
                                    var formInputYear = DateFormat("yyyy", 'id')
                                        .parse(selectedYear.toString());
                                    if (!years.contains(parseDateyear.year)) {
                                      years.add(parseDateyear.year);
                                    }
                                    if (parseDateyear
                                        .isAtSameMomentAs(formInputYear)) {
                                      dataList.add({
                                        'tanggal': key,
                                      });
                                    }
                                  });
                                  // Filter Sorting Bulan
                                  dataList.sort((a, b) {
                                    var aDate = DateFormat("yyyy-MM", 'id')
                                        .parse(a['tanggal']);
                                    var bDate = DateFormat("yyyy-MM", 'id')
                                        .parse(b['tanggal']);
                                    return aDate.compareTo(bDate);
                                  });
                                  // Filter Search Bulan
                                  dataList = dataList.where((value) {
                                    if (filterSearchController.text == "") {
                                      return true;
                                    }
                                    return DateFormat('MMMM', 'id')
                                        .format(DateFormat('yyyy-MM', "id")
                                            .parse(value['tanggal']))
                                        .toString()
                                        .toLowerCase()
                                        .contains(filterSearchController.text
                                            .toLowerCase());
                                  }).toList();

                                  return ListView.builder(
                                    itemCount: dataList.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          // Card Lemburan
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 20),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border(
                                                left: BorderSide(
                                                    width: 1,
                                                    color: Color(0xFF2FA4D9)),
                                                top: BorderSide(
                                                    width: 11,
                                                    color: Color(0xFF2FA4D9)),
                                                right: BorderSide(
                                                    width: 1,
                                                    color: Color(0xFF2FA4D9)),
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: Color(0xFF2FA4D9)),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "PAYSLIP ${DateFormat('MMMM yyyy', 'id').format(DateFormat('yyyy-MM', "id").parse(dataList[index]['tanggal']))}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/Calendar.svg",
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                      "${DateFormat('MMMM yyyy', 'id').format(DateFormat('yyyy-MM', "id").parse(dataList[index]['tanggal']))}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize: 14,
                                                          color: Colors.blue),
                                                    )),
                                                  ],
                                                ),
                                                Divider(),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        shape:
                                                            MaterialStateProperty
                                                                .all(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .blue),
                                                        foregroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .white),
                                                      ),
                                                      onPressed: () async{
                                                        print('adviewcount = $_adViewCount');
                                                        // tampilkan rewards ads
                                                        if (_adViewCount < 4) {
                                                          EasyLoading.show(
                                                              status:
                                                              "Loading...");
                                                          _incrementAdViewCount();
                                                         await RewardAds
                                                              .rewardedInterstitialAd!
                                                              .show(onUserEarnedReward:
                                                                  (AdWithoutView
                                                                          ad,
                                                                      RewardItem
                                                                          rewardItem) {
                                                            // Reward the user for watching an ad.

                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (ctx) =>
                                                                    SumBulanan(
                                                                        tanggal:
                                                                            dataList[index]['tanggal']),
                                                              ),
                                                            );
                                                          }).then(
                                                            (value) {
                                                              EasyLoading
                                                                  .dismiss();
                                                            },
                                                          );
                                                        } else {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (ctx) => SumBulanan(
                                                                  tanggal: dataList[
                                                                          index]
                                                                      [
                                                                      'tanggal']),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child:
                                                          Text("Lihat Detail")),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                                if (snapshot.hasData) {
                                  // Tampilkan kosong jika snapshot return data tapi data di database kosong
                                  return const Center(
                                    child: Text("Tidak ada lembur tahun ini"),
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
