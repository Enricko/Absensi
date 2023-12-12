import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    height: 50,
                    child: TextFormField(
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 3, 1, 3),
                          hintText: "Cari Lemburanmu",
                          hintStyle: TextStyle(fontSize: 13),
                          prefix: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text("Pilih Tahun",style: TextStyle(fontSize: 16),),
                      Text("2023"),
                    ],),
                    SizedBox(height: 10,),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("PAYSLIP JULY 2023",style: TextStyle(fontWeight: FontWeight.w500),),
                                    SizedBox(height: 8,),
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
                                              "Agustus 2023",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
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
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            backgroundColor:
                                            MaterialStateProperty.all(Colors.blue),
                                            foregroundColor:
                                            MaterialStateProperty.all(Colors.white),
                                          ),
                                          onPressed: (){}, child: Text("Lihat Detail")),
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
                      ),
                    )
              
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
