import 'package:absensi/page/screens/bulanan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'harian.dart';
import 'form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children:[
                SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    'assets/Background.png',
                    // Replace with your image asset path
                    fit: BoxFit.cover, // Use BoxFit.cover to fill the container
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24,vertical: 58),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Selamat Datang,",style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w300)),
                          Text("Ghaluh Wizard",style: TextStyle(color: Colors.white))
                        ],
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Total Bulan ini",style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w300)),
                          Text("2.300.000",style: TextStyle(color: Colors.white),)
                        ],
                      ),
                    ],
                  ),
                )
              ]
            ),
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
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
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
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.blue),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=> const SumHarian()));
                                  },
                                  child: const Text("Harian"))),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: OutlinedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      side: MaterialStateProperty.all(
                                          const BorderSide(color: Colors.blue)),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blue)),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=> const SumBulanan()));
                                  },
                                  child: const Text("Bulanan"))),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 2,
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
                                      left: BorderSide(
                                          width: 1, color: Color(0xFF2FA4D9)),
                                      top: BorderSide(
                                          width: 11, color: Color(0xFF2FA4D9)),
                                      right: BorderSide(
                                          width: 1, color: Color(0xFF2FA4D9)),
                                      bottom: BorderSide(
                                          width: 1, color: Color(0xFF2FA4D9)),
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
                                            style: TextStyle(
                                                color: Colors.black38),
                                          )),
                                          const Text("Kamis, 23 Juni 2023"),
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
                                            style: TextStyle(
                                                color: Colors.black38),
                                          )),
                                          const Text("Masuk"),
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
                                            "Tanggal",
                                            style: TextStyle(
                                                color: Colors.black38),
                                          )),
                                          const Text("3 Jam"),
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
                                            "Tanggal",
                                            style: TextStyle(
                                                color: Colors.black38),
                                          )),
                                          const Text(
                                            "Rp.200.000",
                                            style:
                                                TextStyle(color: Colors.blue),
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
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 124,left: 24,right: 24),
          child: SizedBox(
            width: double.infinity,
            child: Card(
              child:
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 13),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset("assets/ClockClockwise.svg",color: Colors.black,),
                          const Text("2 Jam",style: TextStyle(color: Colors.blue),),
                          const Text("Lembur",style: TextStyle(color: Colors.black38),),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset("assets/Calendar.svg",color: Colors.black,),
                          const Text("Juni",style: TextStyle(color: Colors.blue),),
                          const Text("Bulan",style: TextStyle(color: Colors.black38),),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset("assets/u_money-stack.svg",color: Colors.black,),
                          const Text("Rp.400.000",style: TextStyle(color: Colors.blue),),
                          const Text("Total Hari ini",style: TextStyle(color: Colors.black38),),
                        ],
                      ),
                    ),
                  ],
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (ctx)=> const FormAbsensi()));
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }
}
