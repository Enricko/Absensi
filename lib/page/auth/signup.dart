import 'dart:async';

import 'package:absensi/include/banner_ads.dart';
import 'package:absensi/page/auth/login.dart';
import 'package:absensi/page/screens/home.dart';
import 'package:absensi/system/auth.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Form Key untuk Validasi Form Input
  final formkey = GlobalKey<FormState>();

  // invisible agar icon mata pada password dapat di gunakan semestinya
  bool invisible = true;

  // ignorePointer agar tidak spam click
  bool ignorePointer = false;
  Timer? ignorePointerTimer;

  // Variable Text Editor Controllers
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nomorController = TextEditingController();
  final TextEditingController gajiController = TextEditingController();

  String? waktuKerja;

  // Logic form input SignUp
  void signUp(BuildContext context) {
    // Mengubah Controller menjadi String/huruf
    var nama = namaController.text;
    var email = emailController.text;
    var password = passwordController.text;
    var nomor = nomorController.text;

    // Mengubah format gaji jadi integer
    var gaji = int.parse(gajiController.text.replaceAll(RegExp(r'[^0-9]'), ''));

    // Menjadikan Map agar mudah di pindah ke function lain
    var data = {
      "nama": nama,
      "email": email,
      "password": password,
      "no_telepon": nomor,
      "gaji_pokok": gaji,
      "waktu_kerja": waktuKerja,
    };
    // Menjalankan Logic Class Function Auth Login
    Auth.signUp(data, context);
  }

  void cekUser() {
    // Logic cek Data User apakah sudah pernah login
    if (FirebaseAuth.instance.currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    }
  }

  // Code yang bakal di jalankan pertama kali halaman ini dibuka
  @override
  void initState() {
    // Cek User apakah user sudah pernah login sebelumnya
    cekUser();
    super.initState();
  }

  @override
  void dispose() {
    // Timer pada ignore pointer akan di hapus jika pindah page
    // agar tidak memakan banyak resource device dan tidak error
    if (ignorePointerTimer != null) {
      ignorePointerTimer!.cancel();
    }
    EasyLoading.dismiss();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IgnorePointer(
        // Boolean ignorePointer agar tidak spam click
        ignoring: ignorePointer,
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          // Move Page Ke LoginPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2FA4D9),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Buat Akun Baru',
                        style: TextStyle(
                          color: Color(0xFF36454F),
                          fontSize: 26,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Silahkan lengkapi formulir dibawah ini',
                        style: TextStyle(
                          color: Color(0xFF696F79),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // Form Input Sign Up
                      Form(
                        key: formkey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Nama Lengkap",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Color(0xFF696F79),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: namaController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty || value == "") {
                                  return "Nama Lengkap harus di isi!";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFFCFDFE),
                                hintText: "Masukan Nama Lengkap Anda",
                                hintStyle: const TextStyle(
                                  color: Color(0xFF696F79),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                                isDense: true,
                                contentPadding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  borderSide: const BorderSide(width: 1, color: Color(0xFFDEDEDE)),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 1, color: Colors.redAccent),
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Email",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Color(0xFF696F79),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty || value == "") {
                                  return "The Email field is required.";
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                  return 'Mohon masukkan email yang valid!';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFFCFDFE),
                                hintText: "Masukan Email Anda",
                                hintStyle: const TextStyle(
                                  color: Color(0xFF696F79),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                                isDense: true,
                                contentPadding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  borderSide: const BorderSide(width: 1, color: Color(0xFFDEDEDE)),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 1, color: Colors.redAccent),
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Password",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Color(0xFF696F79),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: passwordController,
                              obscureText: invisible,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty || value == "") {
                                  return "Password harus di isi!";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFFCFDFE),
                                hintText: "Masukan Password Anda",
                                hintStyle: const TextStyle(
                                  color: Color(0xFF696F79),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon((invisible == true) ? Icons.visibility_outlined : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      invisible = !invisible;
                                    });
                                  },
                                ),
                                isDense: true,
                                contentPadding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  borderSide: const BorderSide(width: 1, color: Color(0xFFDEDEDE)),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 1, color: Colors.redAccent),
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Nomor Telepon",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Color(0xFF696F79),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: nomorController,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty || value == "") {
                                  return "Nomor Telepon harus di isi!";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFFCFDFE),
                                hintText: "Masukan Nomor Telepon Anda",
                                hintStyle: const TextStyle(
                                  color: Color(0xFF696F79),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                                isDense: true,
                                contentPadding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  borderSide: const BorderSide(width: 1, color: Color(0xFFDEDEDE)),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 1, color: Colors.redAccent),
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Gaji Pokok",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Color(0xFF696F79),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: gajiController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty || value == "") {
                                  return "Gaji Pokok harus di isi!";
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                                CurrencyTextInputFormatter(
                                  locale: 'ID',
                                  decimalDigits: 0,
                                  symbol: 'Rp. ',
                                ),
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFFCFDFE),
                                hintText: "Masukan Besaran gaji Pokok Anda",
                                hintStyle: const TextStyle(
                                  color: Color(0xFF696F79),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                                isDense: true,
                                contentPadding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  borderSide: const BorderSide(width: 1, color: Color(0xFFDEDEDE)),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 1, color: Colors.redAccent),
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Waktu Kerja",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Color(0xFF696F79),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            DropdownSearch<String>(
                              items: [
                                "5 Hari",
                                "6 Hari",
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty || value == "") {
                                  return "Waktu Kerja harus di isi!";
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
                                waktuKerja ?? "Pilih Waktu Kerja Anda",
                                style: TextStyle(fontSize: 15, color: Colors.black38),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  waktuKerja = value!;
                                });
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
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Validasi Form Input sebelum menjalankan logic sign up
                            if (formkey.currentState!.validate()) {
                              setState(() {
                                ignorePointer = true;
                                ignorePointerTimer = Timer(const Duration(seconds: 2), () {
                                  setState(() {
                                    ignorePointer = false;
                                  });
                                });
                              });
                              // Menjalanan kan logic SignUp
                              signUp(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2FA4D9),
                          ),
                          child: const Text(
                            "Daftar",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFF6F7FB),
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "Sudah punya akun? ",
                                style: TextStyle(
                                  color: Color(0xFF374253),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: 'Login',
                                style: const TextStyle(
                                  color: Color(0xFF2FA4D9),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Move Page Ke LoginPage
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
              const BannerAds(),
            ],
          ),
        ),
      ),
    );
  }
}
