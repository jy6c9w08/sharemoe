
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/bindings/home_binding.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';

void main()  {
  //WidgetsFlutterBinding.ensureInitialized();
  configureDependencies().then((value) {
    try {
      //某些无法在injectable初始化的组件在这里初始化
      init();
    } catch (e) {}
  }).whenComplete(() async =>
  //初始化错误上报
  // TODO 将dsn改为从配置文件获取
  await SentryFlutter.init(
      (options) {
    options.dsn = 'https://f8571d8c079e491ba80cbfa72032a3a1@o997704.ingest.sentry.io/5956031';
  },
  appRunner: () => runApp(MyApp()),
  ));
}

//初始化备用
init() async {

}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(324, 576),
      builder: () => GetMaterialApp(
        //smartManagement: SmartManagement.onlyBuilder,
        title: 'ShareMoe',
        navigatorObservers: [BotToastNavigatorObserver()],
        initialBinding: HomeBinding(),
        initialRoute: Routes.HOME,
        getPages: AppPages.pages,
        builder: BotToastInit(),
      ),
    );
  }
}
