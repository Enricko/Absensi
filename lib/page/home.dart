import 'package:absensi/include/banner_ads.dart';
import 'package:absensi/page/auth/login.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Pages Section
            LoginPage(),
        
            // Banner Ad Section
            BannerAds(),
          ],
        ),
      ),
    );
  }
}
