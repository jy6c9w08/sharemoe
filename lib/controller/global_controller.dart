// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/upgrade_service.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/data/model/app_info.dart';
import 'package:sharemoe/data/repository/app_repository.dart';

class GlobalController extends GetxController {
  final isLogin = Rx<bool>(false);
  static final UserService userService = getIt<UserService>();
  static final UpgradeService upgradeService = getIt<UpgradeService>();
  late String time;

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
    //TODO 请求最新的版本号 newVersion和versionBox中的version对比 小于出现更新弹窗 执行对应平台的 service.upgrade

    APPInfo appInfo = await getIt<AppRepository>()
        .queryUpdateInfo('1.0.0');

    if (appInfo.version != upgradeService.appInfo().version)
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
    // SchedulerBinding.instance!.addPostFrameCallback((_) => checkVersion(false));
    Future.delayed(Duration(seconds: 2)).then((value) => checkVersion(false));
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
