// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/controller/collection/collection_controller.dart';
import 'package:sharemoe/data/model/collection.dart';
import 'collection_selector_controller.dart';

class CollectionDetailController extends GetxController {
  final int index = Get.arguments;
  late Collection collection;
  List<TagList> tagAdvice = [];
  final CollectionSelectorCollector collectionSelectorCollector =
      Get.find<CollectionSelectorCollector>();

  // final collection=Rx<Collection>();
  late int currentPage;

  @override
  void onInit() {
    collection = Get.find<CollectionController>().collectionList.value[index];
    collectionSelectorCollector.isCreate = false;
    collectionSelectorCollector.selectMode = false;
    collectionSelectorCollector.collection = collection;

    super.onInit();
  }

  @override
  void onClose() {
    collectionSelectorCollector.title.clear();
    collectionSelectorCollector.caption.clear();
    collectionSelectorCollector.isCreate = true;
    Get.find<CollectionSelectorCollector>().selectMode = true;
    Get.find<CollectionSelectorCollector>().clearSelectList();
  }
}
