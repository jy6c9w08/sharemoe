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
    } else {
      isLogin.value = false;
      // if (AuthBox().permissionLevel > 2)
      //   getIt<VIPRepository>()
      //       .queryGetHighSpeedServer()
      //       .then((value) => vipUrl = value[1].serverAddress);
    }
  }

  @override
  void onInit() {
    //打开应用时间
    time = DateTime.now().millisecondsSinceEpoch.toString();
    checkLogin();
    super.onInit();
  }
}
