import 'package:get/get.dart';
import 'package:sharemoe/controller/user/message_controller.dart';

class MessageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MessageController());
  }
}
