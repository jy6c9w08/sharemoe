// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';

class GlobalController extends GetxController {
  final isLogin = Rx<bool>(false);
  static final UserService userService = getIt<UserService>();
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

  checkVersion(){
    //TODO 请求最新的版本号 newVersion和versionBox中的version对比 小于出现更新弹窗 执行对应平台的 service.upgrade

  }

  @override
  void onInit() {
    //打开应用时间
    time = DateTime.now().millisecondsSinceEpoch.toString();
    checkLogin();
    super.onInit();
  }
}
