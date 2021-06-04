import 'package:get/get.dart';
import 'package:sharemoe/controller/artist/artist_detail_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/data/model/artist.dart';

class ArtistBinding implements Bindings {
  @override
  void dependencies() {}
}

class ArtistDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
        () => ArtistDetailController(
            artistId: (Get.arguments as ArtistPreView).id!),
        tag: 'artist');
    Get.lazyPut(
        () => WaterFlowController(
            model: 'artist',
            isManga: false,
            artistId: (Get.arguments as ArtistPreView).id),
        tag: 'artist_false');
    Get.lazyPut(
        () => WaterFlowController(
            model: 'artist',
            isManga: true,
            artistId: (Get.arguments as ArtistPreView).id),
        tag: 'artist_true');
  }
}
