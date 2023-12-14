import 'package:absensi/page/auth/login.dart';
import 'package:absensi/page/screens/bulanan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'harian.dart';
import 'form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              SizedBox(
                width: double.infinity,
                child: Image.asset(
                  'assets/Background.png',
                  // Replace with your image asset path
                  fit: BoxFit.cover, // Use BoxFit.cover to fill the container
                ),
              ),
              // Mengambil data pada firebase menggunakan StreamBuilder
              StreamBuilder(
                // Query untuk mengambil data pada firebase
                stream: FirebaseDatabase.instance.ref().child("user").child(id_user).onValue,
                builder: (context, snapshot) {
                  // Mengecek apakah data nya ada atau tidak
                  if (snapshot.hasData &&
                      (snapshot.data! as DatabaseEvent).snapshot.value != null) {
                    Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(
                        (snapshot.data! as DatabaseEvent).snapshot.value as Map<dynamic, dynamic>);
                    // Display True data
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 58),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text("Selamat Datang,",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300)),
                              Text(data['nama'] ?? "-", style: const TextStyle(color: Colors.white))
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text("Total Bulan ini",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300)),
                              Text(
                                "${currencyFormatter.format(int.parse(data['gaji_pokok']))}",
                                style: const TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  // Menampilkan dummy data agar tidak error
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 58),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Selamat Datang,",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300)),
                            Text("-", style: TextStyle(color: Colors.white))
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Total Bulan ini",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300)),
                            Text(
                              "0",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ]),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      const Text(
                        "Ringkasan",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                                    foregroundColor: MaterialStateProperty.all(Colors.white),
                                  ),
                                  onPressed: () {},
                                  child: const Text("Harian"))),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: OutlinedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      side: MaterialStateProperty.all(
                                          const BorderSide(color: Colors.blue)),
                                      foregroundColor: MaterialStateProperty.all(Colors.blue)),
                                  onPressed: () {},
                                  child: const Text("Bulanan"))),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: StreamBuilder(
                          // Query untuk mengambil data pada firebase
                          stream: FirebaseDatabase.instance
                              .ref()
                              .child("lembur") // Parent di database
                              .child(id_user) // Id user
                              .child(DateFormat('yyyy-MM', "id")
                                  .format(DateTime.now())) // Bulan dan tahun saat ini
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
                                          borderRadius: BorderRadius.circular(8),
                                          border: const Border(
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
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                const Expanded(
                                                    child: Text(
                                                  "Tanggal",
                                                  style: TextStyle(color: Colors.black38),
                                                )),
                                                Text("${dataList[index]['tanggal']}"),
                                              ],
                                            ),
                                            const Divider(),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/Fingerprint.svg",
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                const Expanded(
                                                    child: Text(
                                                  "Absensi",
                                                  style: TextStyle(color: Colors.black38),
                                                )),
                                                Text("${dataList[index]['absensi']}"),
                                              ],
                                            ),
                                            const Divider(),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/ClockClockwise.svg",
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                const Expanded(
                                                    child: Text(
                                                  "Lembur",
                                                  style: TextStyle(color: Colors.black38),
                                                )),
                                                Text("${dataList[index]['lembur']} Jam"),
                                              ],
                                            ),
                                            const Divider(),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/u_money-stack.svg",
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                const Expanded(
                                                    child: Text(
                                                  "Total",
                                                  style: TextStyle(color: Colors.black38),
                                                )),
                                                Text(
                                                  "${currencyFormatter.format(dataList[index]['total'])}",
                                                  style: const TextStyle(color: Colors.blue),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
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
                                child: Text("Tidak ada lembur hari ini"),
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                            // Dummy display data
                            // return ListView.builder(
                            //   itemCount: 2,
                            //   itemBuilder: (context, index) {
                            //     return Column(
                            //       children: [
                            //         // Card Lemburan
                            //         Container(
                            //           width: double.infinity,
                            //           padding:
                            //               const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                            //           decoration: BoxDecoration(
                            //             color: Colors.white,
                            //             borderRadius: BorderRadius.circular(8),
                            //             border: const Border(
                            //               left: BorderSide(width: 1, color: Color(0xFF2FA4D9)),
                            //               top: BorderSide(width: 11, color: Color(0xFF2FA4D9)),
                            //               right: BorderSide(width: 1, color: Color(0xFF2FA4D9)),
                            //               bottom: BorderSide(width: 1, color: Color(0xFF2FA4D9)),
                            //             ),
                            //           ),
                            //           child: Column(
                            //             children: [
                            //               Row(
                            //                 children: [
                            //                   SvgPicture.asset(
                            //                     "assets/Calendar.svg",
                            //                   ),
                            //                   const SizedBox(
                            //                     width: 8,
                            //                   ),
                            //                   const Expanded(
                            //                       child: Text(
                            //                     "Tanggal",
                            //                     style: TextStyle(color: Colors.black38),
                            //                   )),
                            //                   const Text("-"),
                            //                 ],
                            //               ),
                            //               const Divider(),
                            //               Row(
                            //                 children: [
                            //                   SvgPicture.asset(
                            //                     "assets/Fingerprint.svg",
                            //                   ),
                            //                   const SizedBox(
                            //                     width: 8,
                            //                   ),
                            //                   const Expanded(
                            //                       child: Text(
                            //                     "Absensi",
                            //                     style: TextStyle(color: Colors.black38),
                            //                   )),
                            //                   const Text("-"),
                            //                 ],
                            //               ),
                            //               const Divider(),
                            //               Row(
                            //                 children: [
                            //                   SvgPicture.asset(
                            //                     "assets/ClockClockwise.svg",
                            //                   ),
                            //                   const SizedBox(
                            //                     width: 8,
                            //                   ),
                            //                   const Expanded(
                            //                       child: Text(
                            //                     "Lembur",
                            //                     style: TextStyle(color: Colors.black38),
                            //                   )),
                            //                   const Text("- Jam"),
                            //                 ],
                            //               ),
                            //               const Divider(),
                            //               Row(
                            //                 children: [
                            //                   SvgPicture.asset(
                            //                     "assets/u_money-stack.svg",
                            //                   ),
                            //                   const SizedBox(
                            //                     width: 8,
                            //                   ),
                            //                   const Expanded(
                            //                       child: Text(
                            //                     "Total",
                            //                     style: TextStyle(color: Colors.black38),
                            //                   )),
                            //                   const Text(
                            //                     "-",
                            //                     style: TextStyle(color: Colors.blue),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //         const SizedBox(
                            //           height: 10,
                            //         ),
                            //       ],
                            //     );
                            //   },
                            // );
                          },
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 124, left: 24, right: 24),
          child: SizedBox(
            width: double.infinity,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 13),
                child: StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .ref()
                      .child("lembur") // Parent di database
                      .child(id_user) // Id user
                      .child(DateFormat('yyyy-MM', "id")
                          .format(DateTime.now())) // Bulan dan tahun saat ini
                      .onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && (snapshot.data!).snapshot.value != null) {
                      // Variable data mempermudah memanggil data pada database
                      Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(
                          (snapshot.data! as DatabaseEvent).snapshot.value
                              as Map<dynamic, dynamic>);
                      // Memperulangkan data menggunakan foreach
                      int totalJam = 0;
                      int totalGaji = 0;
                      data.forEach((key, value) {
                        // Setiap data yang di perulangkan bakal di simpan ke dalam list
                        final currentData = Map<String, dynamic>.from(value);
                        // Mensetting variable dengan total lembur dan gaji)
                        totalJam += int.parse(currentData['lembur'].toString());
                        totalGaji += int.parse(currentData['total'].toString());
                      });
                      return Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  "assets/ClockClockwise.svg",
                                  color: Colors.black,
                                ),
                                Text(
                                  "$totalJam Jam",
                                  style: const TextStyle(color: Colors.blue),
                                ),
                                const Text(
                                  "Lembur",
                                  style: TextStyle(color: Colors.black38),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  "assets/Calendar.svg",
                                  color: Colors.black,
                                ),
                                Text(
                                  "${DateFormat('MMMM', 'id').format(DateTime.now())}",
                                  style: const TextStyle(color: Colors.blue),
                                ),
                                const Text(
                                  "Bulan",
                                  style: TextStyle(color: Colors.black38),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  "assets/u_money-stack.svg",
                                  color: Colors.black,
                                ),
                                Text(
                                  "${currencyFormatter.format(totalGaji)}",
                                  style: const TextStyle(color: Colors.blue),
                                ),
                                const Text(
                                  "Total Bulan ini",
                                  style: TextStyle(color: Colors.black38),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                "assets/ClockClockwise.svg",
                                color: Colors.black,
                              ),
                              Text(
                                "- Jam",
                                style: const TextStyle(color: Colors.blue),
                              ),
                              const Text(
                                "Lembur",
                                style: TextStyle(color: Colors.black38),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                "assets/Calendar.svg",
                                color: Colors.black,
                              ),
                              Text(
                                "${DateFormat('MMMM', 'id').format(DateTime.now())}",
                                style: const TextStyle(color: Colors.blue),
                              ),
                              const Text(
                                "Bulan",
                                style: TextStyle(color: Colors.black38),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                "assets/u_money-stack.svg",
                                color: Colors.black,
                              ),
                              Text(
                                "-",
                                style: const TextStyle(color: Colors.blue),
                              ),
                              const Text(
                                "Total Bulan ini",
                                style: TextStyle(color: Colors.black38),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        )
        // Positioned(
        //   top: 50,
        //   right: 24,
        //   left: 24,
        //   child: FittedBox(
        //     child: Card(
        //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        //       color: Colors.white,
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         // child: Row(
        //         //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //         //   children: [
        //         //     Column(
        //         //       children: [
        //         //         Image.asset("assets/ClockClockwise.png"),
        //         //         Text("2 Jam",style: TextStyle(fontSize: 8),),
        //         //         Text("Lembur",style: TextStyle(fontSize: 8)),
        //         //       ],
        //         //     ),
        //         //     Column(
        //         //       children: [
        //         //         Image.asset("assets/ClockClockwise.png"),
        //         //         Text("2 Jam"),
        //         //         Text("Lembur"),
        //         //       ],
        //         //     ),
        //         //     Column(
        //         //       children: [
        //         //         Image.asset("assets/ClockClockwise.png"),
        //         //         Text("2 Jam"),
        //         //         Text("Lembur"),
        //         //       ],
        //         //     )
        //         //   ],
        //         // ),
        //       ),
        //     ),
        //   ),
        // )
      ]),
      floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (ctx) => const FormAbsensi()));
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }
}
