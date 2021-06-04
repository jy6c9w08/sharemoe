import 'package:get/get.dart';
import 'package:sharemoe/basic/config/hive_config.dart';

class GlobalController extends GetxController {
  final isLogin = Rx<bool>(false);

  checkLogin() {
    if (picBox.get('auth') == '') {
      isLogin.value = false;
    } else {
      isLogin.value = true;
    }
  }

  @override
  void onInit() {
    checkLogin();
    super.onInit();
  }
}
