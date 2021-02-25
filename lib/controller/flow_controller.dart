import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/controller/home_controller.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/repository/illust_repository.dart';

class ShareMoeController extends GetxController
    with SingleGetTickerProviderMixin {
  final illustList = Rx<List<Illust>>([]);
  final HomePageController homePageController = Get.find<HomePageController>();
  final ScreenUtil screen = ScreenUtil();
  ScrollController scrollController;
  int currentPage = 1;
  int listCount;
  bool loadMore = true;

  @override
  onInit() {
    print("ShareMoe Controller");
    getList().then((value) => illustList.value = value);
    initScrollController();
    super.onInit();
  }

  initScrollController() {
    scrollController = ScrollController(initialScrollOffset: 0.0)
      ..addListener(listenTheList);
  }

  Future<List<Illust>> getList({currentPage = 1}) async {
    return await getIt<IllustRepository>()
        .queryIllustRank('2021-02-20', 'day', currentPage, 30)
        .then((value) => value);
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

    if ((scrollController.position.extentAfter < 1200) &&
        (currentPage < 30) &&
        loadMore) {
      loadMore = false;
      currentPage++;
      getList(currentPage: currentPage).then((list) {
        illustList.value = illustList.value + list;
        listCount = illustList.value.length;
        update(['list']);
      });
      Future.delayed(Duration(seconds: 1), () => loadMore = true);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
