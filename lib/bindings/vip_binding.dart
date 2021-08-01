import 'package:get/get.dart';
import 'package:sharemoe/controller/user/vip_controller.dart';

class VIPBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VIPController());
  }
}