import 'package:get/get.dart';
import 'package:sharemoe/controller/user/type_controller.dart';

class TypeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TypeController());
  }
}