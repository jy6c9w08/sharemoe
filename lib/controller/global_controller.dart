import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/basic/util/pic_url_util.dart';
import 'package:sharemoe/data/repository/vip_repository.dart';

class GlobalController extends GetxController {
  final isLogin = Rx<bool>(false);

  checkLogin() {
    if (UserService.queryToken() == '') {
      isLogin.value = false;
    } else {
      isLogin.value = true;
      if (AuthBox().permissionLevel > 2)
        getIt<VIPRepository>()
            .queryGetHighSpeedServer()
            .then((value) => vipUrl = value[1].serverAddress);
    }
  }

  @override
  void onInit() {
    //checkLogin();
    super.onInit();
  }
}
