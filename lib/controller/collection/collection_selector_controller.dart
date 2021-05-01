import 'package:get/get.dart';
import 'package:sharemoe/controller/image_controller.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:flutter/material.dart';

class CollectionSelectorCollector extends GetxController
    with SingleGetTickerProviderMixin {
  List<int> selectList = [];
  AnimationController animationController;
  Animation animation;
  bool selectMode;

  // final collectionList=Rx<List<int>>([]);

  void clearSelectList() {
    for (int i = 0; i < selectList.length; i++) {
      Get.find<ImageController>(tag: selectList[i].toString())
          .isSelector
          .value = false;
    }
    selectList = [];
    animationController.reverse();
    update();
  }

  void addIllustToCollectList(Illust illust) {
    if (selectList.length == 0) animationController.forward();
    selectList.add(illust.id);
    update();
  }

  void removeIllustToCollectList(Illust illust) {
    selectList.removeWhere((element) => element == illust.id);
    if (selectList.length == 0) animationController.reverse();
    update();
  }

  @override
  void onInit() {
    selectMode = true;
    animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    animation =
        Tween<double>(begin: 0.0, end: 40.0).animate(animationController)
          ..addListener(() {
            update();
          });
    super.onInit();
  }
}
