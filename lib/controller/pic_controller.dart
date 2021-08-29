// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sharemoe/controller/artist/artist_detail_controller.dart';
import 'package:sharemoe/controller/other_user/other_user_follow_controller.dart';

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
    if (model == 'home') {
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

    if (model.contains('artist') || model.contains('bookmark')) {
      if (scrollController.position.extentBefore == 0 &&
          scrollController.position.userScrollDirection ==
              ScrollDirection.forward) {
        // onPageTop();

        double position = scrollController.position.extentBefore -
            ScreenUtil().setHeight(350);

        model.contains('artist')
            ? Get.find<ArtistDetailController>(
                    tag: model.replaceAll(RegExp(r'[^0-9]'), ''))
                .scrollController
                .animateTo(position,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut)
            : Get.find<OtherUserFollowController>(
                    tag: model.replaceAll(RegExp(r'[^0-9]'), ''))
                .scrollController
                .animateTo(position,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut);
        print('on page top');
      }
      if (scrollController.position.extentBefore > 150 &&
          scrollController.position.extentBefore < 200 &&
          scrollController.position.userScrollDirection ==
              ScrollDirection.reverse) {
        double position = scrollController.position.extentBefore +
            ScreenUtil().setHeight(550);
        model.contains('artist')
            ? Get.find<ArtistDetailController>(
                    tag: model.replaceAll(RegExp(r'[^0-9]'), ''))
                .scrollController
                .animateTo(position,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut)
            : Get.find<OtherUserFollowController>(
                    tag: model.replaceAll(RegExp(r'[^0-9]'), ''))
                .scrollController
                .animateTo(position,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut);
        // onPageStart();
        print('on page start');
      }
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
