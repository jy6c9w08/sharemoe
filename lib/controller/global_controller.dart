import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/basic/pic_urls.dart';
import 'package:sharemoe/data/repository/vip_repository.dart';

class GlobalController extends GetxController {
  final isLogin = Rx<bool>(false);

  checkLogin() {
    if (PicBox().auth == '') {
      isLogin.value = false;
    } else {
      isLogin.value = true;
      if (PicBox().permissionLevel > 2)
        getIt<VIPRepository>()
            .queryGetHighSpeedServer()
            .then((value) => vipUrl = value[1].serverAddress);
    }
  }

  @override
  void onInit() {
    checkLogin();
    super.onInit();
  }
}
