import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardAds {
  static RewardedInterstitialAd? rewardedInterstitialAd;

  static void loadAd() {
    RewardedInterstitialAd.load(
        adUnitId:
            Platform.isAndroid ? 'ca-app-pub-3940256099942544/5354046379' : 'ca-app-pub-3940256099942544/6978759866',
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            print("Print ad : $ad");
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                // onAdFailedToShowFullScreenContent: (ad, err) {
                //   // Dispose the ad here to free resources.
                //   ad.dispose();
                // },
                // // Called when the ad dismissed full screen content.
                // onAdDismissedFullScreenContent: (ad) {
                //   // Dispose the ad here to free resources.
                //   ad.dispose();
                // },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            rewardedInterstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedInterstitialAd failed to load: $error');
          },
        ));
  }
}
