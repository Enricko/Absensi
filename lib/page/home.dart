import 'dart:io';

import 'package:absensi/page/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Ad Unit ID bisa di ubah sesuai yg ada di AdMob
  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111' // Android Ad Unit Id
      : 'ca-app-pub-3940256099942544/2934735716'; // iOS Ad Unit Id
  late BannerAd bannerAd;
  bool isAdLoaded = false;

  // Load BannerAd
  void initBannerAd() {
    bannerAd = BannerAd(
      adUnitId: _adUnitId,
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print("Banner Ad Failed to Load $error");
        },
      ),
      request: const AdRequest(),
    );
    bannerAd.load();
  }

  // Initialize BannerAd
  @override
  void initState() {
    super.initState();
    initBannerAd();
  }

  // Dispose BannerAd
  @override
  void dispose() {
    super.dispose();
    bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LoginPage(),
          if (isAdLoaded ==
              true) // Saat Load BannerAd berhasil tampilan BannerAd akan muncul
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: SizedBox(
                  width: bannerAd.size.width.toDouble(),
                  height: bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: bannerAd),
                ),
              ),
            )
        ],
      ),
    );
  }
}
