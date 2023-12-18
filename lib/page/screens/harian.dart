import 'package:absensi/include/interstisial_ads.dart';
import 'package:absensi/page/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SumHarian extends StatefulWidget {
  const SumHarian({Key? key, required this.tanggal, required this.id}) : super(key: key);
  final String tanggal, id;

  @override
  State<SumHarian> createState() => _SumHarianState();
}

class _SumHarianState extends State<SumHarian> {
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
          "Ringkasan Harian",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 19),
        child: StreamBuilder(
          stream: FirebaseDatabase.instance
              .ref()
              .child("lembur") // Parent di database
              .child(id_user) // Id user
              .child(widget.tanggal)
              .child(widget.id) // Bulan dan tahun saat ini
              .onValue,
          builder: (context, snapshot) {
            // Mengecek apakah data nya ada atau tidak
            if (snapshot.hasData && (snapshot.data!).snapshot.value != null) {
              // Variable data mempermudah memanggil data pada database
              Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(
                  (snapshot.data! as DatabaseEvent).snapshot.value as Map<dynamic, dynamic>);
              // Mengubah map menjadi list
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${data['tanggal']}"),
                  SizedBox(
                    height: 5,
                  ),
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
                      //efek scrolling
                      child: ListView.builder(
                        //membuat container fit dengan tinggi listview
                        shrinkWrap: true,
                        //jumlah item listview
                        itemCount: 2,
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
                                    "Lembur Ke",
                                    style: TextStyle(color: Colors.black38),
                                  )),
                                  Text("${index + 1}"),
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
                                  Text("${data['absensi']}"),
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
                                    "Tanggal",
                                    style: TextStyle(color: Colors.black38),
                                  )),
                                  Text("${index == 0?data['lembur1']:data['lembur2']} Jam"),
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
                                  )),
                                  Text(
                                    "${currencyFormatter.format(index == 0?data['totalLembur1']:data['totalLembur2'])}",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(color: Colors.blue),
                            ],
                          );
                        },
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Total Lembur Hari ini:", style: TextStyle(color: Colors.black38)),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${currencyFormatter.format(data['total'])}",
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              );
            }
            if (snapshot.hasData) {
              // Tampilkan kosong jika snapshot return data tapi data di database kosong
              return const Center(
                child: Text("Tidak ada lembur hari ini"),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
