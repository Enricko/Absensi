import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
            SizedBox(
              width: double.infinity,
              child: Image.asset(
                'assets/Background.png',
                // Replace with your image asset path
                fit: BoxFit.cover, // Use BoxFit.cover to fill the container
              ),
            ),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Text(
                        "Ringkasan",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
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
                                  onPressed: () {},
                                  child: Text("Harian"))),
                          SizedBox(
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
                                          BorderSide(color: Colors.blue)),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blue)),
                                  onPressed: () {},
                                  child: Text("Bulanan"))),
                        ],
                      ),
                      SizedBox(
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
                                    border: Border(
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
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                              child: Text(
                                            "Tanggal",
                                            style: TextStyle(
                                                color: Colors.black38),
                                          )),
                                          Text("Kamis, 23 Juni 2023"),
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
                                            style: TextStyle(
                                                color: Colors.black38),
                                          )),
                                          Text("Masuk"),
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
                                            style: TextStyle(
                                                color: Colors.black38),
                                          )),
                                          Text("3 Jam"),
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
                                            "Tanggal",
                                            style: TextStyle(
                                                color: Colors.black38),
                                          )),
                                          Text(
                                            "Rp.200.000",
                                            style:
                                                TextStyle(color: Colors.blue),
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
                            );
                          },
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ),
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
          onPressed: () {},
          child: Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }
}
