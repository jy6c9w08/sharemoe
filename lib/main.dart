// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/basic/util/sharemoe_theme_util.dart';
import 'package:sharemoe/bindings/home_binding.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  await configureDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp // 强制竖屏
  ]);
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://d7a387568e943f7409a06d6cb77b309c@o4506654843011072.ingest.sentry.io/4506654846025728';
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
          locale: Locale("zh", "CH"),
          home: child,
          theme: SharemoeTheme.light(),
          darkTheme: SharemoeTheme.dark(),
          themeMode: getIt<UserService>().themeModelFromHive()!),
    );
  }
}
