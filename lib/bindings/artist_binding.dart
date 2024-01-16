// Package imports:
import 'package:get/get.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';

// Project imports:
import 'package:sharemoe/controller/water_flow_controller.dart';

class ArtistListBinding implements Bindings {
  @override
  void dependencies() {
    // Get.put(ArtistListController(model: Get.arguments), tag: Get.arguments);
  }
}

class ArtistDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
        () => WaterFlowController(
            model: PicModel.ARTIST_ILLUST,
            isManga: false,
            artistId: int.parse(Get.arguments as String)),
        tag: PicModel.ARTIST_ILLUST + Get.arguments);
    Get.lazyPut(
        () => WaterFlowController(
            model: PicModel.ARTIST_MAGA,
            isManga: true,
            artistId: int.parse(Get.arguments as String)),
        tag: PicModel.ARTIST_MAGA + Get.arguments);
  }
}
