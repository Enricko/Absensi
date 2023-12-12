import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class FormAbsensi extends StatefulWidget {
  const FormAbsensi({Key? key}) : super(key: key);

  @override
  State<FormAbsensi> createState() => _FormAbsensiState();
}

class _FormAbsensiState extends State<FormAbsensi> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  int selectedRadio = 0;
  final String locale = 'id';
  String? status;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Absensi",style: TextStyle(fontSize: 18,color: Colors.white),),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        // efek scrolling
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Silahkan lengkapi formulir dibawah ini untuk mengisi absensi lemburan"),
              SizedBox(height: 10,),
              Text("Apakah Anda masuk lemburan Hari ini?"),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio(
                    activeColor: Colors.blue,
                    value: 1,
                    groupValue: selectedRadio,
                    onChanged: (value) {
                      setState(() {
                        selectedRadio = value!;
                      });
                    },
                  ),
                  Text('Masuk'),
                  SizedBox(width: 16.0), // Adjust the spacing between radio buttons
                  Radio(
                    activeColor: Colors.blue,
                    value: 2,
                    groupValue: selectedRadio,
                    onChanged: (value) {
                      setState(() {
                        selectedRadio = value!;
                      });
                    },
                  ),
                  Text('Tidak Masuk'),
                ],
              ),
              SizedBox(height: 10,),
              Text("Tanggal Lembur"),
              SizedBox(height: 5,),
              GestureDetector(
                onTap: () async {
                  showDatePicker(
                    context: context,

                    initialDate: DateTime.now() ,
                    firstDate: DateTime(1945),
                    lastDate: DateTime(2030),
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                  ).then((value) {
                    if (value != null) {
                      //format tanggal hari, tanggal bulan tahun dalam bahasa indonesia
                      String formatDate =DateFormat('EEEE, dd MMMM yyyy').format(value);
                      setState(() {
                        dateController.text = formatDate;
                      });
                    }
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 5),
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    controller:
                    dateController,
                    enabled: false,
                    decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.fromLTRB(
                            10, 3, 1, 3),
                        hintText:
                        "Pilih Tanggal Lemburan Anda",
                        hintStyle:
                        TextStyle(fontSize: 13),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            "assets/Calendar.svg",
                            color:
                            Colors.black38,
                          ),
                        ),
                        disabledBorder:
                        OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              width: 1,
                          color: Colors.black38
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Text("Keterangan Lembur"),
              SizedBox(height: 15,),
              DropdownSearch<String>(
                items: [
                  "Sakit",
                  "Sakit",
                  "Sakit",
                ],
                popupProps:
                PopupPropsMultiSelection.menu(
                  fit: FlexFit.loose,
                  showSearchBox: false,
                  itemBuilder:
                      (context, item, isSelected) =>
                      ListTile(
                        title: Text(item),
                      ),
                ),
                dropdownBuilder:
                    (context, selectedItem) => Text(
                  status ?? "Pilih Keterangan Lembur Anda",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black38),
                ),
                onChanged: (value) {
                  status = value!;
                },
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    enabled: false,
                    focusedBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide(color: Colors.blue,width: 1)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide(color: Colors.black38,width: 1)
                    ),
                  )
                ),
              ),
              SizedBox(height: 10,),
              Text("Berapa Jam Lembur?"),
              SizedBox(height: 5,),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: 5),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(15),
                ),
                child: TextField(
                  controller:
                  timeController,
                  decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.fromLTRB(
                          10, 3, 10, 3),
                      hintText:
                      "Masukan Jam Lembur",
                      hintStyle:
                      TextStyle(fontSize: 13),
                      suffixText: "Jam",
                      suffixStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            width: 1,
                            color: Colors.black38
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            width: 1,
                            color: Colors.black38
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white),
                ),
              ),
              SizedBox(height: 10,),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                        ),
                        side: MaterialStateProperty.all(
                            BorderSide(color: Colors.blue)),
                        foregroundColor:
                        MaterialStateProperty.all(
                            Colors.blue)),
                    onPressed: (){}, child: Text("Hitung Lemburan Saya",style: TextStyle(fontSize: 15),)),
              ),
              SizedBox(height: 15,),
              Text("HASIL PERHITUNGAN"),
              SizedBox(height: 10,),
              Column(
                children: [
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
                            Text("Masuk ( Hari Libur )"),
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
                                  "Lembur",
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
                                  "Total",
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
              ),
              SizedBox(height: 10,),
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
                    onPressed: (){}, child: Text("Simpan")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
