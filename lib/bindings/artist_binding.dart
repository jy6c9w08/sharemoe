// Package imports:
import 'package:get/get.dart';
import 'package:sharemoe/controller/artist/artist_list_controller.dart';

// Project imports:
import 'package:sharemoe/controller/water_flow_controller.dart';

class ArtistListBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ArtistListController(model: Get.arguments), tag: Get.arguments);

  }
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
