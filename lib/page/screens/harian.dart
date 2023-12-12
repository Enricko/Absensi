import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SumHarian extends StatefulWidget {
  const SumHarian({Key? key}) : super(key: key);

  @override
  State<SumHarian> createState() => _SumHarianState();
}

class _SumHarianState extends State<SumHarian> {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Kamis, 23 Juni 2023"),
            SizedBox(
              height: 5,
            ),
            Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                            Text("1"),
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
                              style: TextStyle(color: Colors.black38),
                            )),
                            Text("1 Jam"),
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
                              style: TextStyle(color: Colors.black38),
                            )),
                            Text(
                              "Rp.200.000",
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
            SizedBox(height: 10,),
            Text("Total Lembur Hari ini:",style: TextStyle(color: Colors.black38)),
            SizedBox(height: 5,),
            Text(
              "Rp.200.000",
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
