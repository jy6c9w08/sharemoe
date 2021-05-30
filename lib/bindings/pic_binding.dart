import 'package:get/get.dart';

import 'package:sharemoe/controller/search_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';

class PicBinding implements Bindings {
  @override
  void dependencies() {
    switch (Get.arguments as String) {
      case 'bookmark':
        Get.lazyPut(
            () => WaterFlowController(model: 'bookmark', isManga: false),
            tag: 'bookmark_false');
        Get.lazyPut(() => WaterFlowController(model: 'bookmark', isManga: true),
            tag: 'bookmark_true');
        break;
      case 'artist':
        Get.lazyPut(
                () => WaterFlowController(model: 'artist', isManga: false),
            tag: 'artist_false');
        Get.lazyPut(() => WaterFlowController(model: 'artist', isManga: true),
            tag: 'artist_true');
        break;
      case 'history':
        Get.lazyPut(
                () => WaterFlowController(model: 'history'),
            tag: 'history');
        Get.lazyPut(() => WaterFlowController(model: 'oldHistory', isManga: true),
            tag: 'oldHistory');
        break;
    }
  }
}
