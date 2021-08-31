// Package imports:
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/upgrade_service.dart';
import 'package:sharemoe/basic/service/user_service.dart';

class GlobalController extends GetxController {
  final isLogin = Rx<bool>(false);
  static final UserService userService = getIt<UserService>();
  static final UpgradeService upgradeService = getIt<UpgradeService>();
  late String time;

  checkLogin() {
    if (userService.isLogin()) {
      isLogin.value = true;
      checkVersion();
    } else {
      isLogin.value = false;
      // if (AuthBox().permissionLevel > 2)
      //   getIt<VIPRepository>()
      //       .queryGetHighSpeedServer()
      //       .then((value) => vipUrl = value[1].serverAddress);
    }
  }

  checkVersion() {
    //TODO 请求最新的版本号 newVersion和versionBox中的version对比 小于出现更新弹窗 执行对应平台的 service.upgrade
    print(upgradeService.version());
    Get.dialog(AlertDialog(
      title: Text('更新'),
      content: Text(upgradeService.version()),
      actions: [TextButton(onPressed: (){




      }, child: Text('更新'))],
    ));
  }

  @override
  void onInit() {
    //打开应用时间
    SchedulerBinding.instance!.addPostFrameCallback((_) => checkVersion());
    time = DateTime.now().millisecondsSinceEpoch.toString();
    super.onInit();
  }
}
