import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormAbsensi extends StatefulWidget {
  const FormAbsensi({Key? key}) : super(key: key);

  @override
  State<FormAbsensi> createState() => _FormAbsensiState();
}

class _FormAbsensiState extends State<FormAbsensi> {
  final formkey = GlobalKey<FormState>();

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  int selectedRadio = 0;
  final String locale = 'id';
  String? status;
  // Format Currency
  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 2,
  );

  Future<String> totalLembur() async {
    // Menyimpan data pada device menggunakan SharedPreferences
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? gajiPokok = pref.getInt('gaji_pokok');

    if (timeController.text != "") {
      return "${timeController.text == "1" ? currencyFormatter.format(int.parse(timeController.text) * 1.5 * (1 / 173) * gajiPokok!) : currencyFormatter.format(int.parse(timeController.text) * 2 * (1 / 173) * gajiPokok!)}";
    }
    return "Rp. 0";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Absensi",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        // efek scrolling
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Silahkan lengkapi formulir dibawah ini untuk mengisi absensi lemburan"),
                SizedBox(
                  height: 10,
                ),
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
                SizedBox(
                  height: 10,
                ),
                Text("Tanggal Lembur"),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () async {
                    showDatePicker(
                      context: context,
                      locale: const Locale("id", "ID"),
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1945),
                      lastDate: DateTime(2030),
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                    ).then((value) {
                      if (value != null) {
                        //format tanggal hari, tanggal bulan tahun dalam bahasa indonesia
                        String formatDate = DateFormat('EEEE, dd MMMM yyyy', "id").format(value);
                        setState(() {
                          dateController.text = formatDate;
                        });
                      }
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: dateController,
                      enabled: false,
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "") {
                          return "Tanggal Lembur harus di isi!";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 3, 1, 3),
                          hintText: "Pilih Tanggal Lemburan Anda",
                          hintStyle: TextStyle(fontSize: 13),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(10),
                            child: SvgPicture.asset(
                              "assets/Calendar.svg",
                              color: Colors.black38,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.black38),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1, color: Colors.redAccent),
                          ),
                          filled: true,
                          fillColor: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text("Keterangan Lembur"),
                SizedBox(
                  height: 15,
                ),
                DropdownSearch<String>(
                  items: [
                    "Sakit",
                    "Sakit",
                    "Sakit",
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty || value == "") {
                      return "Keterangan lembur harus di isi!";
                    }
                    return null;
                  },
                  popupProps: PopupPropsMultiSelection.menu(
                    fit: FlexFit.loose,
                    showSearchBox: false,
                    itemBuilder: (context, item, isSelected) => ListTile(
                      title: Text(item),
                    ),
                  ),
                  dropdownBuilder: (context, selectedItem) => Text(
                    status ?? "Pilih Keterangan Lembur Anda",
                    style: TextStyle(fontSize: 15, color: Colors.black38),
                  ),
                  onChanged: (value) {
                    status = value!;
                  },
                  dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                    enabled: false,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide(color: Colors.blue, width: 1)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide(color: Colors.black38, width: 1)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide(color: Colors.redAccent, width: 1)),
                  )),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Berapa Jam Lembur?"),
                SizedBox(
                  height: 5,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    controller: timeController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {});
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty || value == "") {
                        return "Jam Lembur harus di isi!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                        hintText: "Masukan Jam Lembur",
                        hintStyle: TextStyle(fontSize: 13),
                        suffixText: "Jam",
                        suffixStyle: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(width: 1, color: Colors.black38),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(width: 1, color: Colors.black38),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(width: 1, color: Colors.redAccent),
                        ),
                        filled: true,
                        fillColor: Colors.white),
                  ),
                ),
                // ! Perkiraan tidak di butuhkan

                // SizedBox(
                //   height: 10,
                // ),
                // SizedBox(
                //   width: double.infinity,
                //   child: OutlinedButton(
                //     style: ButtonStyle(
                //         shape: MaterialStateProperty.all(
                //           RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(12),
                //           ),
                //         ),
                //         side: MaterialStateProperty.all(BorderSide(color: Colors.blue)),
                //         foregroundColor: MaterialStateProperty.all(Colors.blue)),
                //     onPressed: () {
                //       setState(() {});
                //     },
                //     child: Text(
                //       "Hitung Lemburan Saya",
                //       style: TextStyle(fontSize: 15),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 15,
                ),
                Text("HASIL PERHITUNGAN"),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
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
                                style: TextStyle(color: Colors.black38),
                              )),
                              Text(
                                  "${dateController.text == '' ? 'Senin, 1 Januari 2000' : dateController.text}"),
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
                              Text("${selectedRadio == 1 ? 'Masuk' : 'Tidak Masuk'}"),
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
                                style: TextStyle(color: Colors.black38),
                              )),
                              Text("${timeController.text == '' ? '0' : timeController.text} Jam"),
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
                                ),
                              ),
                              FutureBuilder<String>(
                                future: totalLembur(),
                                builder: (context, snapshot) {
                                  return Text(
                                    "${snapshot.hasData ? snapshot.data : 'Rp. 0'}",
                                    style: TextStyle(color: Colors.blue),
                                  );
                                },
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
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: () {},
                      child: Text("Simpan")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
