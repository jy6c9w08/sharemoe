import 'package:get/get.dart';
import 'package:sharemoe/controller/collection_controller.dart';


class CollectionBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CollectionController());
  }
}