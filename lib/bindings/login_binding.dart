// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/controller/login_controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
