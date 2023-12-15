import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAds {
  static InterstitialAd? _interstitialAd;

  /// Loads an interstitial ad.
  static void loadAd() {
    // TODO: replace this test ad unit with your own ad unit.
    final adUnitId = Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/1033173712' // Android Ad Unit Id
        : 'ca-app-pub-3940256099942544/4411468910'; // iOS Ad Unit Id
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {},
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {},
              // Called when the ad failed to show full screen content.
              onAdFailedToShowFullScreenContent: (ad, err) {
                // Dispose the ad here to free resources.
                ad.dispose();
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                // Dispose the ad here to free resources.
                ad.dispose();
              },
              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {});

          debugPrint('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
          _interstitialAd = ad;
          // Iklan bakal muncul jika ini mendapatkan 1 dan memiliki chance 1/3 atau 33.3%
          // Kenapa saya kasih begini agar pindah page ti dak selalu iklan
          // Agar user tidak terlalu merasa risih dengan iklan
          int random = Random().nextInt(3);
          print("random : $random");
          if (random == 1) {
            _interstitialAd!.show();
          }
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );
  }
}

// class InterstitalAds extends StatefulWidget {
//   const InterstitalAds({super.key});

//   @override
//   State<InterstitalAds> createState() => _InterstitalAdsState();
// }

// class _InterstitalAdsState extends State<InterstitalAds> {
  

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
