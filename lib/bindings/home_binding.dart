// Package imports:
import 'package:get/get.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';

// Project imports:
import 'package:sharemoe/controller/collection/collection_selector_controller.dart';
import 'package:sharemoe/controller/global_controller.dart';
import 'package:sharemoe/controller/home_controller.dart';
import 'package:sharemoe/controller/image_down/image_download_controller.dart';
import 'package:sharemoe/controller/theme_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(GlobalController());
    Get.put(ThemeController());
    Get.lazyPut(() => HomePageController());
    Get.lazyPut(() => CollectionSelectorCollector(isCreate: true));
    Get.lazyPut(() => WaterFlowController(model: 'home'), tag: 'home');
    Get.lazyPut(() => WaterFlowController(model: PicModel.UPDATE_MAGA, isManga: true),
        tag: PicModel.UPDATE_MAGA);
    Get.lazyPut(() => WaterFlowController(model: PicModel.UPDATE_ILLUST, isManga: false),
        tag: PicModel.UPDATE_ILLUST);
    Get.lazyPut(() => WaterFlowController(model: 'recommend'),
        tag: 'recommend');
    Get.put(ImageDownLoadController());
  }
}
