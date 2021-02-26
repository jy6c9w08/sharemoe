import 'package:get/get.dart';

import 'package:sharemoe/controller/home_controller.dart';
import 'package:sharemoe/controller/sapp_bar_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomePageController());
    Get.lazyPut(() => SappBarController());
  }
}
