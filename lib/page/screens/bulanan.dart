import 'package:absensi/include/interstisial_ads.dart';
import 'package:absensi/page/auth/login.dart';
import 'package:absensi/page/screens/harian.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
    InterstitialAds.loadAd();
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
                                Text(
                                    "${currencyFormatter.format(int.tryParse(data['gaji_pokok']))}"),
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
                      height: 160,
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
                            });
                            return ListView.builder(
                              //membuat container fit dengan tinggi listview
                              shrinkWrap: true,
                              //jumlah item listview
                              itemCount: dataList.length,
                              itemBuilder: (context, index) {
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
                                          "Lembur ke ${index + 1}",
                                          style: TextStyle(color: Colors.black38),
                                        )),
                                        Text("${dataList[index]['lembur']} Jam"),
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
                                          "Total Lembur ke ${index + 1}",
                                          style: TextStyle(color: Colors.black38),
                                        )),
                                        Text(
                                          "${currencyFormatter.format(dataList[index]['total'])}",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Divider(),
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
                    return ListView.builder(
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (ctx) => SumHarian(tanggal:widget.tanggal,id:dataList[index]['id'])));
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
                                            Text("${dataList[index]['absensi']}"),
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
                                              "Total Lembur ke ${index + 1}",
                                              style: TextStyle(color: Colors.black38),
                                            )),
                                            Text(
                                              "${currencyFormatter.format(dataList[index]['total'])}",
                                              style: TextStyle(color: Colors.blue),
                                            ),
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
