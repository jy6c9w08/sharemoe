// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/controller/collection/collection_selector_controller.dart';
import 'package:sharemoe/controller/global_controller.dart';
import 'package:sharemoe/controller/home_controller.dart';
import 'package:sharemoe/controller/image_down/image_download_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(GlobalController());
    Get.lazyPut(() => HomePageController());
    Get.lazyPut(() => CollectionSelectorCollector(isCreate: true));
    Get.lazyPut(() => WaterFlowController(model: 'home'), tag: 'home');
    Get.lazyPut(() => WaterFlowController(model: 'update', isManga: true),
        tag: 'update_true');
    Get.lazyPut(() => WaterFlowController(model: 'update', isManga: false),
        tag: 'update_false');
    Get.lazyPut(() => WaterFlowController(model: 'recommend'),
        tag: 'recommend');
    Get.put(ImageDownLoadController());
  }
}
