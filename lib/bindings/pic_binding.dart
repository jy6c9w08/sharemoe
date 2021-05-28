import 'package:get/get.dart';

import 'package:sharemoe/controller/search_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';

class PicBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WaterFlowController(model: 'home'));
  }
}
