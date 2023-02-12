import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

//You have to config the app ID here
const kAndroidBannerUnitId = "ca-app-pub-123/456";
const kIosBannerUnitId = "ca-app-pub-789/012";

const kTestDeviceId = "D1D80B166B9CC47B0472174E59AB6D86";

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
      size: AdSize.banner,
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
    )..load();
  }

  String get _bannerUnitId {
    if (kDebugMode) {
      return BannerAd.testAdUnitId;
    }

    if (Platform.isAndroid) {
      return kAndroidBannerUnitId;
    }

    if (Platform.isIOS) {
      return kIosBannerUnitId;
    }

    throw UnimplementedError(
        "${Platform.operatingSystem} is not implemented for banner ads");
  }
}
