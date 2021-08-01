// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/controller/user/setting_controller.dart';

class UserSettingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingController());
  }
}
