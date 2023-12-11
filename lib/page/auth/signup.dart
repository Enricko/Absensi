import 'package:absensi/include/banner_ads.dart';
import 'package:absensi/page/auth/login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 30, 15, 0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide: const BorderSide(
                                    width: 1, color: Color(0xFFDEDEDE)),
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
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 30, 15, 0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide: const BorderSide(
                                    width: 1, color: Color(0xFFDEDEDE)),
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
                              suffixIcon: const Icon(Icons.visibility_outlined),
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 30, 15, 0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide: const BorderSide(
                                    width: 1, color: Color(0xFFDEDEDE)),
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
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 30, 15, 0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide: const BorderSide(
                                    width: 1, color: Color(0xFFDEDEDE)),
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
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
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
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 30, 15, 0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide: const BorderSide(
                                    width: 1, color: Color(0xFFDEDEDE)),
                              ),
                            ),
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
                        onPressed: () {},
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
                  ],
                ),
              ),
            ),
            BannerAds(),
          ],
        ),
      ),
    );
  }
}
