// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/controller/search_controller.dart';

class SearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchController(), tag: Get.arguments);
  }
}

class SearchTagBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchController.tag(), tag: Get.arguments);
  }
}
