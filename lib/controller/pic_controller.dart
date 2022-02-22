// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'home_controller.dart';

class PicController extends GetxController {
  final String model;
  late ScrollController scrollController;
  final HomePageController homePageController = Get.find<HomePageController>();
  final ScreenUtil screen = ScreenUtil();

  PicController({required this.model});

  initScrollController() {
    scrollController = ScrollController(initialScrollOffset: 0.0)
      ..addListener(listenTheList);
  }

  listenTheList() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        homePageController.navBarBottom.value = screen.setHeight(-47);
      }
      // 当页面平移时，底部导航栏需重新上浮
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        homePageController.navBarBottom.value = screen.setHeight(25);
      }

  }

  @override
  void onInit() {
    initScrollController();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
