import 'package:absensi/include/alerts.dart';
import 'package:absensi/include/interstisial_ads.dart';
import 'package:absensi/page/auth/login.dart';
import 'package:absensi/page/screens/harian.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SumBulanan extends StatefulWidget {
  const SumBulanan({Key? key, required this.tanggal}) : super(key: key);
  final String tanggal;

  @override
  State<SumBulanan> createState() => _SumBulananState();
}

class _SumBulananState extends State<SumBulanan> {
  String id_user = "";

  List<Map<dynamic, dynamic>> keterangan = [];
  List<Map<dynamic, dynamic>> lembur = [];
  List<Map<dynamic, dynamic>> totalLembur = [];

  List<String> summaries = [];
  List<String> listHariBiasa = [];
  List<String> listHariLibur = [];

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
    // InterstitialAds.loadAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Ringkasan Bulanan",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 19),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Keterangan Bulan ${DateFormat('MMMM yyyy').format(DateFormat('yyyy-MM').parse(widget.tanggal))}",
                style: TextStyle(fontSize: 16)),
            SizedBox(
              height: 15,
            ),
            Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFF2FA4D9), width: 1)),
                //efek scrolling
                child: Column(
                  children: [
                    StreamBuilder(
                        stream:
                            FirebaseDatabase.instance.ref().child("user").child(id_user).onValue,
                        builder: (context, snapshot) {
                          // Mengecek apakah data nya ada atau tidak
                          if (snapshot.hasData &&
                              (snapshot.data! as DatabaseEvent).snapshot.value != null) {
                            Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(
                                (snapshot.data! as DatabaseEvent).snapshot.value
                                    as Map<dynamic, dynamic>);
                            return Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/Fingerprint.svg",
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                    child: Text(
                                  "Gaji Pokok",
                                  style: TextStyle(color: Colors.black38),
                                )),
                                Text("${currencyFormatter.format(data['gaji_pokok'])}"),
                              ],
                            );
                          }
                          return Row(
                            children: [
                              SvgPicture.asset(
                                "assets/Fingerprint.svg",
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                  child: Text(
                                "Gaji Pokok",
                                style: TextStyle(color: Colors.black38),
                              )),
                              Text("-"),
                            ],
                          );
                        }),
                    Divider(),
                    SizedBox(
                      child: StreamBuilder(
                          stream: FirebaseDatabase.instance
                              .ref()
                              .child("lembur") // Parent di database
                              .child(id_user) // Id user
                              .child(widget.tanggal) // Bulan dan tahun saat ini
                              .onValue,
                          builder: (context, snapshot) {
                            // Mengecek apakah data nya ada atau tidak
                            if (snapshot.hasData && (snapshot.data!).snapshot.value != null) {
                              // Variable data mempermudah memanggil data pada database
                              Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(
                                  (snapshot.data! as DatabaseEvent).snapshot.value
                                      as Map<dynamic, dynamic>);
                              // Mengubah map menjadi list
                              List<Map<dynamic, dynamic>> dataList = [];
                              int lembur1 = 0;
                              int totalLembur1 = 0;
                              int lembur2 = 0;
                              int totalLembur2 = 0;
                              int lembur3 = 0;
                              int totalLembur3 = 0;
                              int lembur4 = 0;
                              int totalLembur4 = 0;
                              // Memperulangkan data menggunakan foreach
                              data.forEach((key, value) {
                                // Setiap data yang di perulangkan bakal di simpan ke dalam list
                                final currentData = Map<String, dynamic>.from(value);
                                // Mensetting variable dengan total lembur dan gaji)
                                dataList.add({
                                  'tanggal': currentData['tanggal'],
                                  'absensi': currentData['absensi'],
                                  'keterangan': currentData['keterangan'],
                                  'lembur': currentData['lembur'],
                                  'total': currentData['total'],
                                });
                                // set data ke masing masing variable
                                lembur1 += int.parse(currentData['lembur1'].toString());
                                totalLembur1 += int.parse(currentData['totalLembur1'].toString());
                                lembur2 += int.parse(currentData['lembur2'].toString());
                                totalLembur2 += int.parse(currentData['totalLembur2'].toString());
                                lembur3 += int.parse(currentData['lembur3'].toString());
                                totalLembur3 += int.parse(currentData['totalLembur3'].toString());
                                lembur4 += int.parse(currentData['lembur4'].toString());
                                totalLembur4 += int.parse(currentData['totalLembur4'].toString());
                              });
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
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
                                        "Lembur ke 1",
                                        style: TextStyle(color: Colors.black38),
                                      )),
                                      Text("$lembur1 Jam"),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
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
                                        "Total Lembur ke 1",
                                        style: TextStyle(color: Colors.black38),
                                      )),
                                      Text(
                                        "${currencyFormatter.format(totalLembur1)}",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 5,
                                  ),
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
                                        "Lembur ke 2",
                                        style: TextStyle(color: Colors.black38),
                                      )),
                                      Text("$lembur2 Jam"),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
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
                                        "Total Lembur ke 2",
                                        style: TextStyle(color: Colors.black38),
                                      )),
                                      Text(
                                        "${currencyFormatter.format(totalLembur2)}",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),Divider(),
                                  SizedBox(
                                    height: 5,
                                  ),
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
                                            "Lembur ke 3",
                                            style: TextStyle(color: Colors.black38),
                                          )),
                                      Text("$lembur3 Jam"),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
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
                                            "Total Lembur ke 3",
                                            style: TextStyle(color: Colors.black38),
                                          )),
                                      Text(
                                        "${currencyFormatter.format(totalLembur3)}",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 5,
                                  ),
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
                                            "Lembur ke 4",
                                            style: TextStyle(color: Colors.black38),
                                          )),
                                      Text("$lembur4 Jam"),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
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
                                            "Total Lembur ke 4",
                                            style: TextStyle(color: Colors.black38),
                                          )),
                                      Text(
                                        "${currencyFormatter.format(totalLembur4)}",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                            if (snapshot.hasData) {
                              // Tampilkan kosong jika snapshot return data tapi data di database kosong
                              return const Center(
                                child: Text("Tidak ada lembur bulan ini"),
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }),
                    ),
                  ],
                )),
            SizedBox(
              height: 30,
            ),
            Text("History Lemburan Bulan ini", style: TextStyle(fontSize: 16)),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseDatabase.instance
                    .ref()
                    .child("lembur") // Parent di database
                    .child(id_user) // Id user
                    .child(widget.tanggal) // Bulan dan tahun saat ini
                    .onValue,
                builder: (context, snapshot) {
                  // Mengecek apakah data nya ada atau tidak
                  if (snapshot.hasData && (snapshot.data!).snapshot.value != null) {
                    // Variable data mempermudah memanggil data pada database
                    Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(
                        (snapshot.data! as DatabaseEvent).snapshot.value as Map<dynamic, dynamic>);
                    // Mengubah map menjadi list
                    List<Map<dynamic, dynamic>> dataList = [];
                    // Memperulangkan data menggunakan foreach
                    data.forEach((key, value) {
                      // Setiap data yang di perulangkan bakal di simpan ke dalam list
                      final currentData = Map<String, dynamic>.from(value);
                      // Mensetting variable dengan total lembur dan gaji)
                      dataList.add({
                        'id': key,
                        'tanggal': currentData['tanggal'],
                        'absensi': currentData['absensi'],
                        'keterangan': currentData['keterangan'],
                        'lembur': currentData['lembur'],
                        'total': currentData['total'],
                      });
                    });
                    dataList.sort((a, b) {
                      var aDate = DateFormat("EEEE, dd MMMM yyyy", 'id').parse(a['tanggal']);
                      var bDate = DateFormat("EEEE, dd MMMM yyyy", 'id').parse(b['tanggal']);
                      return aDate.compareTo(bDate);
                    });
                    return ListView.builder(
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => SumHarian(
                                            tanggal: widget.tanggal, id: dataList[index]['id'])));
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Color(0xFF2FA4D9), width: 1)),
                                //efek scrolling
                                child: Column(
                                  children: [
                                    Text("${dataList[index]['tanggal']}"),
                                    Divider(),
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
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
                                            Text("${dataList[index]['absensi']} (${dataList[index]['keterangan']})"),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
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
                                              "Lembur",
                                              style: TextStyle(color: Colors.black38),
                                            )),
                                            Text(
                                              "${dataList[index]['lembur']} Jam",
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
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
                                              "Total Lembur",
                                              style: TextStyle(color: Colors.black38),
                                            )),
                                            Text(
                                              "${currencyFormatter.format(dataList[index]['total'])}",
                                              style: TextStyle(color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                                icon: Icon(Icons.delete),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(Colors.red),
                                                  foregroundColor:
                                                      MaterialStateProperty.all(Colors.white),
                                                  shape: MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(15),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Alerts.showAlertYesNoDelete(
                                                      title: "Are you sure you want to Delete?",
                                                      onPressYes: () async {
                                                        FirebaseDatabase.instance
                                                            .ref()
                                                            .child("lembur") // Parent di database
                                                            .child(id_user) // Id user
                                                            .child(widget
                                                                .tanggal) // Bulan dan tahun saat ini
                                                            .child(dataList[index]['id'])
                                                            .remove()
                                                            .whenComplete(() {
                                                          EasyLoading.showSuccess(
                                                              'Data Lembur berhasil di hapus',
                                                              dismissOnTap: true);
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      onPressNo: () {
                                                        Navigator.pop(context);
                                                      },
                                                      context: context);
                                                }),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      },
                    );
                  }
                  if (snapshot.hasData) {
                    // Tampilkan kosong jika snapshot return data tapi data di database kosong
                    return const Center(
                      child: Text("Tidak ada lembur bulan ini"),
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
    );
  }
}
