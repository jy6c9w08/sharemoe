import 'package:get/get.dart';
import 'package:sharemoe/controller/collection/collection_selector_controller.dart';
import 'package:sharemoe/controller/global_controller.dart';

import 'package:sharemoe/controller/home_controller.dart';
import 'package:sharemoe/controller/sapp_bar_controller.dart';
import 'package:sharemoe/controller/user_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(GlobalController());
    Get.lazyPut(() => HomePageController());
    Get.lazyPut(() => SappBarController());
    Get.lazyPut(() => UserController());
    Get.lazyPut(() => CollectionSelectorCollector(isCreate: true));
    Get.lazyPut(() => WaterFlowController(model: 'home'), tag: 'home');
    Get.lazyPut(() => WaterFlowController(model: 'update', isManga: true),
        tag: 'update_true');
    Get.lazyPut(() => WaterFlowController(model: 'update', isManga: false),
        tag: 'update_false');
  }
}
