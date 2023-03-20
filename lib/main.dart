import 'package:ahadu/controller/adService.dart';
import 'package:ahadu/screen/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final adService = AdService(MobileAds.instance);
  GetIt.instance.registerSingleton<AdService>(adService);

  // TODO it's best to do this kind of loading in a splash screen. If you await
  // too long in main your users will just see a black screen for that time
  await adService.init();
  await Hive.initFlutter();
  await Hive.openBox(FAVORITE_BOX);
  runApp(const MyApp());

  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId("fd6ff375-47c9-4a42-8862-9a64e9a5a508");
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
