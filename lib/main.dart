// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/bindings/home_binding.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  await configureDependencies();

  await SentryFlutter.init(
        (options) {
      options.dsn = 'https://f8571d8c079e491ba80cbfa72032a3a1@o997704.ingest.sentry.io/5956031';
    },
    appRunner: () => runApp(App()),
  );

}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(324, 576),
      builder: (context, child) => GetMaterialApp(
        //smartManagement: SmartManagement.onlyBuilder,
        title: 'ShareMoe',
        navigatorObservers: [BotToastNavigatorObserver()],
        initialBinding: HomeBinding(),
        initialRoute: Routes.HOME,
        getPages: AppPages.pages,
        builder: BotToastInit(),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'),
          Locale('zh'),
        ],
        locale: Locale("zh","CH"),
        home: child,
      ),
    );
  }
}
