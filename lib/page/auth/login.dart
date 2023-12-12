import "package:absensi/include/banner_ads.dart";
import "package:absensi/page/auth/signup.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

import "../menu.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Image Asset Login
                    Image.asset(
                      "assets/man_computer.png",
                      height: 275,
                      width: 275,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // Form Section Login
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            "Login",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xFF36454F),
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Selamat Datang Kembali",
                            textAlign: TextAlign.left,
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
                          Form(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                    prefixIcon: const Icon(Icons.email_outlined),
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(15, 30, 15, 0),
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
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    suffixIcon:
                                        const Icon(Icons.visibility_outlined),
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(15, 30, 15, 0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      borderSide: const BorderSide(
                                          width: 1, color: Color(0xFFDEDEDE)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {},
                        child: Text(
                          "Lupa Password?",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF2FA4D9),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (ctx) => Menu()));

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2FA4D9),
                        ),
                        child: const Text(
                          "Login",
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
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Belum punya akun? ",
                            style: TextStyle(
                              color: Color(0xFF374253),
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: 'Daftar',
                            style: TextStyle(
                              color: Color(0xFF2FA4D9),
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Move Page Ke SignUpPage
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpPage(),
                                  ),
                                );
                              },
                          ),
                        ],
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
