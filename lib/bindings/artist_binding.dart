// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/controller/water_flow_controller.dart';

class ArtistBinding implements Bindings {
  @override
  void dependencies() {}
}

class ArtistDetailBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(
    //     () => ArtistDetailController(
    //         artistId: (Get.arguments as ArtistPreView).id!),
    //     tag: 'artist');
    Get.lazyPut(
        () => WaterFlowController(
            model: 'artist',
            isManga: false,
            artistId: int.parse(Get.arguments)),
        tag: 'artist_false');
    Get.lazyPut(
        () => WaterFlowController(
            model: 'artist', isManga: true, artistId: int.parse(Get.arguments)),
        tag: 'artist_true');
  }
}
