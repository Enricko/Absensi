import 'package:absensi/include/interstisial_ads.dart';
import 'package:absensi/page/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SumHarian extends StatefulWidget {
  const SumHarian({Key? key, required this.tanggal, required this.id})
      : super(key: key);
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

  getjamLembur(int index, data) {
    switch (index) {
      case 0:
        return data["lembur1"];
      case 1:
        return data["lembur2"];
      case 2:
        return data["lembur3"];
      case 3:
        return data["lembur4"];
      default:
    }
  }

  gettotalLembur(int index, data) {
    switch (index) {
      case 0:
        return data['totalLembur1'];
      case 1:
        return data['totalLembur2'];
      case 2:
        return data['totalLembur3'];
      case 3:
        return data['totalLembur4'];
      default:
    }
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
                  (snapshot.data! as DatabaseEvent).snapshot.value
                      as Map<dynamic, dynamic>);
              // Mengubah map menjadi list
              // memberi action scroll
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${data['tanggal']}"),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border(
                            left:
                                BorderSide(width: 1, color: Color(0xFF2FA4D9)),
                            top:
                                BorderSide(width: 11, color: Color(0xFF2FA4D9)),
                            right:
                                BorderSide(width: 1, color: Color(0xFF2FA4D9)),
                            bottom:
                                BorderSide(width: 1, color: Color(0xFF2FA4D9)),
                          ),
                        ),
                        //efek scrolling
                        child: Column(
                          children: [
                            (getjamLembur(0, data) == 0)
                                ? SizedBox()
                                : CardHarian(
                                    no: '1',
                                    absensi: "${data['absensi']}",
                                    jam: "${getjamLembur(0, data)}" " Jam",
                                    total:
                                        "${currencyFormatter.format(gettotalLembur(0, data))}",
                                  ),
                            (getjamLembur(1, data) == 0)
                                ? SizedBox()
                                : CardHarian(
                                    no: '2',
                                    absensi: "${data['absensi']}",
                                    jam: "${getjamLembur(1, data)}" " Jam",
                                    total:
                                        "${currencyFormatter.format(gettotalLembur(1, data))}",
                                  ),
                            (getjamLembur(2, data) == 0)
                                ? SizedBox()
                                : CardHarian(
                                    no: '3',
                                    absensi: "${data['absensi']}",
                                    jam: "${getjamLembur(2, data)}" " Jam",
                                    total:
                                        "${currencyFormatter.format(gettotalLembur(2, data))}",
                                  ),
                            (getjamLembur(3, data) == 0)
                                ? SizedBox()
                                : CardHarian(
                                    no: '4',
                                    absensi: "${data['absensi']}",
                                    jam: "${getjamLembur(3, data)}" " Jam",
                                    total:
                                        "${currencyFormatter.format(gettotalLembur(3, data))}",
                                  ),
                          ],
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Total Lembur Hari ini:",
                        style: TextStyle(color: Colors.black38)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${currencyFormatter.format(data['total'])}",
                      style: TextStyle(color: Colors.blue),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Rumus Lembur 1",
                        style: TextStyle(color: Colors.black38)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "1,5 x Gaji Pokok / 173",
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Rumus Lembur 2",
                        style: TextStyle(color: Colors.black38)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "2 x Gaji Pokok / 173",
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Rumus Lembur 3",
                        style: TextStyle(color: Colors.black38)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "3 x Gaji Pokok / 173",
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Rumus Lembur 4",
                        style: TextStyle(color: Colors.black38)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "4 x Gaji Pokok / 173",
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
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

class CardHarian extends StatelessWidget {
  const CardHarian({
    super.key,
    required this.no,
    required this.absensi,
    required this.jam,
    required this.total,
  });

  final String no;
  final String absensi;
  final String jam;
  final String total;

  @override
  Widget build(BuildContext context) {
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
            Text(no),
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
            Text(absensi
                // "${data['absensi']}"
                ),
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
              "Jam",
              style: TextStyle(color: Colors.black38),
            )),
            Text(
                // "${getjamLembur(index, data)}"
                jam),
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
              total,
              // "${currencyFormatter.format(
              //     gettotalLembur(index, data)
              // )}",
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
  }
}
