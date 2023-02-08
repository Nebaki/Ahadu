import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

const kAndroidBannerUnitId = "ca-app-pub-7306154300982030~2795688723";

const kTestDeviceId = "1630739AA7A907A2D01D5D2C47268D3F";

class AdService {
  final MobileAds _mobileAds;

  AdService(this._mobileAds);

  Future<void> init() async {
    await _mobileAds.initialize();
    if (kDebugMode) {
      final cfg = RequestConfiguration(testDeviceIds: [kTestDeviceId]);
      await MobileAds.instance.updateRequestConfiguration(cfg);
    }
  }

  BannerAd getBannerAd() {
    return BannerAd(
      adUnitId: _bannerUnitId,
      size: AdSize.fullBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint("New banner ad loaded");
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          debugPrint("Ad error: $error");
        },
      ),
      // You can fire-and-forget the call to .load(),
      // it does not need to be awaited
    )..load();
  }

  String get _bannerUnitId {
    if (kDebugMode) {
      return BannerAd.testAdUnitId;
    }

    if (Platform.isAndroid) {
      return kAndroidBannerUnitId;
    }

    throw UnimplementedError(
        "${Platform.operatingSystem} is not implemented for banner ads");
  }
}
