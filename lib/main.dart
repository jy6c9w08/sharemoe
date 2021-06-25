import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bot_toast/bot_toast.dart';

import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/bindings/home_binding.dart';
import 'package:sharemoe/routes/app_pages.dart';

void main() async {
  configureDependencies();
  await HiveConfig.initHive();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return ScreenUtilInit(
      designSize: Size(324, 576),
      builder: () => GetMaterialApp(
        navigatorObservers: [BotToastNavigatorObserver()],
        initialBinding: HomeBinding(),
        initialRoute: Routes.HOME,
        getPages: AppPages.pages,
        builder: BotToastInit(),
      ),
    );
  }
}
