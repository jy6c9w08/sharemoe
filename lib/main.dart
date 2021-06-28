import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/bindings/home_binding.dart';
import 'package:sharemoe/routes/app_pages.dart';

import 'basic/service/user_service.dart';

void main() async {
  /*  DownloadService downloadService=await DownloadService.create(getIt<Logger>());
   downloadService.download(ImageDownloadInfo(
      fileName:
     "test.jpg",
      illustId: 123,
      pageCount: 0  ,//TODO ,
      imageUrl: "https://o.acgpic.net/img-original/img/2021/06/22/00/00/09/90722077_p0.png"));*/
  configureDependencies().then((value) {
    init();

    runApp(MyApp());
  });
}

init() async {
  configureDependencies();
  UserService userService= await getIt.getAsync<UserService>();
  print(userService.userInfo());
  //HiveConfig.initbiz();
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(324, 576),
      builder: () => GetMaterialApp(
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
