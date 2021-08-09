// Package imports:
import 'package:get/get.dart';

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
            model: 'artist',
            isManga: false,
            artistId: int.parse(
                (Get.arguments as String).replaceAll("fromList", ''))),
        tag:
            'artist${(Get.arguments as String).replaceAll("fromList", '')}false');
    Get.lazyPut(
        () => WaterFlowController(
            model: 'artist',
            isManga: true,
            artistId: int.parse(
                (Get.arguments as String).replaceAll("fromList", ''))),
        tag:
            'artist${(Get.arguments as String).replaceAll("fromList", '')}true');
  }
}
