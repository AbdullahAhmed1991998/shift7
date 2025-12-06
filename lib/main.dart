import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shift7_app/core/services/cache_helper.dart';
import 'package:shift7_app/core/services/firebase_options.dart';
import 'package:shift7_app/core/services/notification_service.dart';
import 'package:shift7_app/core/services/service_locator.dart';
import 'package:shift7_app/shift7_app.dart';
import 'package:easy_localization/easy_localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  serviceLocatorSetup();
  await getIt<CacheHelper>().cacheInit();
  await registerMessagingBackgroundHandler();
  await NotificationService.instance.initialize();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: Locale('ar'),
      saveLocale: true,
      startLocale: Locale('ar'),
      useOnlyLangCode: true,
      child: const Shift7App(),
    ),
  );
}
