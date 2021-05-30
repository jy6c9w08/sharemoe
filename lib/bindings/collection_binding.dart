import 'package:get/get.dart';
import 'package:sharemoe/controller/collection/collection_controller.dart';
import 'package:sharemoe/controller/collection/collection_detail_controller.dart';
import 'package:sharemoe/controller/collection/collection_selector_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/data/model/collection.dart';

class CollectionBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CollectionController());
  }
}

class CollectionDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CollectionDetailController());
    Get.lazyPut(
        () => WaterFlowController(
            model: 'collection',
            collectionId: Get.find<CollectionController>()
                .collectionList
                .value[Get.arguments as int]
                .id),
        tag: 'collection');
  }
}
