import 'package:get/get.dart';
import 'package:sharemoe/controller/global_controller.dart';

import 'package:sharemoe/controller/home_controller.dart';
import 'package:sharemoe/controller/login_controller.dart';
import 'package:sharemoe/controller/sapp_bar_controller.dart';
import 'package:sharemoe/controller/user_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(GlobalController());
    Get.lazyPut(() => HomePageController());
    Get.lazyPut(() => SappBarController());
    Get.lazyPut(() => UserController());
  }
}
