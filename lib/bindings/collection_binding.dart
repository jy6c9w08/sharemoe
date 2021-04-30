import 'package:get/get.dart';
import 'package:sharemoe/controller/collection/collection_controller.dart';
import 'package:sharemoe/controller/collection/collection_detail_controller.dart';
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
  }
}