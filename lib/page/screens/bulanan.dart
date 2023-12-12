import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class SumBulanan extends StatefulWidget {
  const SumBulanan({Key? key}) : super(key: key);

  @override
  State<SumBulanan> createState() => _SumBulananState();
}

class _SumBulananState extends State<SumBulanan> {
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
            Text("Keterangan Bulan Juli 2023",style: TextStyle(fontSize: 16)),
            SizedBox(
              height: 15,
            ),
            Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color:Color(0xFF2FA4D9),width: 1)
                ),
                //efek scrolling
                child: Column(
                  children: [
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
                              "Gaji Pokok",
                              style: TextStyle(color: Colors.black38),
                            )),
                        Text("2.300.000"),
                      ],
                    ),
                    Divider(),
                    ListView.builder(
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
                                      "Lembur ke ${index+1}",
                                      style: TextStyle(color: Colors.black38),
                                    )),
                                Text("20 Jam"),
                              ],
                            ),
                            SizedBox(height: 5,),
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
                                      "Total Lembur ke ${index+1}",
                                      style: TextStyle(color: Colors.black38),
                                    )),
                                Text(
                                  "Rp.180.000",
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
                    ),
                  ],
                )),
            SizedBox(height: 30,),
            Text("History Lemburan Bulan ini",style: TextStyle(fontSize: 16)),
            SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                        width: double.infinity,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color:Color(0xFF2FA4D9),width: 1)
                        ),
                        //efek scrolling
                        child: Column(
                          children: [
                            Text("Kamis, 23 - 08 - 2023"),
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
                                    Text("Masuk"),
                                  ],
                                ),
                                SizedBox(height: 5,),
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
                                      "2 Jam",
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
                                          "Total Lembur ke ${index+1}",
                                          style: TextStyle(color: Colors.black38),
                                        )),
                                    Text(
                                      "Rp.40.000",style: TextStyle(color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        )),
                    SizedBox(height: 10,)
                  ],
                );
              },),
            )

          ],
        ),
      ),
    );
  }
}
