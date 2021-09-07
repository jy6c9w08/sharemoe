// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/upgrade_service.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/data/model/app_info.dart';
import 'package:sharemoe/data/repository/app_repository.dart';
import 'package:sharemoe/data/repository/user_base_repository.dart';

class GlobalController extends GetxController {
  final isLogin = Rx<bool>(false);
  static final UserService userService = getIt<UserService>();
  static final UpgradeService upgradeService = getIt<UpgradeService>();
  late String time;

  late CookieManager cookieManager = CookieManager.instance();
  late Cookie? cookie = Cookie(name: '', value: '');

// set the expiration date for the cookie in milliseconds
  final expiresDate =
      DateTime.now().add(Duration(days: 30)).millisecondsSinceEpoch;
  final url = Uri.parse("https://discuss.sharemoe.net/");

// set the cookie
  Future setCookie() async {
    await cookieManager.setCookie(
      url: url,
      name: "flarum_remember",
      value: await getIt<UserBaseRepository>().queryDiscussionToken(),
      domain: ".discuss.sharemoe.net",
      expiresDate: expiresDate,
      isSecure: true,
    );
    cookie = await cookieManager.getCookie(url: url, name: "myCookie");
  }

  checkLogin() {
    if (userService.isLogin()) {
      isLogin.value = true;
    } else {
      isLogin.value = false;
      // if (AuthBox().permissionLevel > 2)
      //   getIt<VIPRepository>()
      //       .queryGetHighSpeedServer()
      //       .then((value) => vipUrl = value[1].serverAddress);
    }
  }

  checkVersion(bool fromAboutPage) async {
    APPInfo? appInfo;
    try {
      appInfo = await getIt<AppRepository>()
          .queryUpdateInfo(upgradeService.appInfo().version);
    } catch (e) {}
    if (appInfo!=null)
      return Get.dialog(AlertDialog(
        title: Text('更新'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(appInfo.version),
            Flexible(
              child: Html(
                data: appInfo.updateLog,
                shrinkWrap: true,
              ),
            ),
            Text(appInfo.androidLink)
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('更新'))
        ],
      ));
    if (fromAboutPage) return BotToast.showSimpleNotification(title: '已是最新版');
  }

  @override
  void onInit() {
    //打开应用时间
    time = DateTime.now().millisecondsSinceEpoch.toString();
    checkLogin();
    Future.delayed(Duration(seconds: 2)).then((value) => checkVersion(false));
    setCookie();
    super.onInit();
  }
}

//main
void mina() {
  int a = 1;
  changeNumber(a);
  print(a); //a=1
}

void changeNumber(int a) {
  a = 2;
  print("this is number is $a"); //a=2
}
