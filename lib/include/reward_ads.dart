import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardAds{
  static RewardedAd? rewardedAd;
  static void loadRewardAd(){
    RewardedAd.load(
        adUnitId : Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/5354046379'
            : 'ca-app-pub-3940256099942544/6978759866',
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad){
              rewardedAd = ad;
              // ad.fullScreenContentCallback = FullScreenContentCallback(
              //     onAdShowedFullScreenContent: (ad) {},
              //     onAdImpression: (ad) {},
              //     onAdFailedToShowFullScreenContent: (ad, err) {
              //       // ad.dispose();
              //     },
              //     onAdDismissedFullScreenContent: (ad) {
              //       // ad.dispose();
              //     },
              //     onAdClicked: (ad) {});

              // debugPrint('$ad loaded.');
              // _rewardedAd = ad;
              // Iklan bakal muncul jika ini mendapatkan 1 dan memiliki chance 1/3 atau 33.3%
              // Kenapa saya kasih begini agar pindah page ti dak selalu iklan
              // Agar user tidak terlalu merasa risih dengan iklan
              // int random = Random().nextInt(5);
              // print("random : $random");
              // if (random == 1) {
              //   _rewardedAd!.show();
              // }
              // _rewardedAd.show(onUserEarnedReward: (ad, reward) {
              //
              // },
              // );
            },
            onAdFailedToLoad: (LoadAdError error) {
              rewardedAd = null;
            }
          // print("iklan null");

        )
    );
  }
}