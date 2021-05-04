import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/controller/collection/collection_controller.dart';
import 'package:sharemoe/data/model/collection.dart';
import 'package:sharemoe/data/repository/collection_repository.dart';
import 'package:flutter/material.dart';

import 'collection_selector_controller.dart';

class CollectionDetailController extends GetxController {
  final int index = Get.arguments;
  Collection collection;
  List<TagList> tagAdvice = [];
  final CollectionSelectorCollector collectionSelectorCollector =
      Get.find<CollectionSelectorCollector>();

  // final collection=Rx<Collection>();
  int currentPage;

  @override
  void onInit() {
    collection = Get.find<CollectionController>().collectionList.value[index];
    collectionSelectorCollector.isCreate=false;
    collectionSelectorCollector.selectMode = false;
    collectionSelectorCollector.collection = collection;

    super.onInit();
  }

  @override
  void onClose() {
    Get.find<CollectionSelectorCollector>().selectMode = true;
    Get.find<CollectionSelectorCollector>().clearSelectList();
  }
}
