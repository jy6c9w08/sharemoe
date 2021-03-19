import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/controller/home_controller.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/repository/illust_repository.dart';

class FlowController extends GetxController with SingleGetTickerProviderMixin {
  final illustList = Rx<List<Illust>>([]);
  final HomePageController homePageController = Get.find<HomePageController>();
  final ScreenUtil screen = ScreenUtil();
  ScrollController scrollController;
  int currentPage = 1;
  bool loadMore = true;
  DateTime picDate;
  String picModel;

  @override
  onInit() {
    print("Flow Controller");
    picDate = DateTime.now().subtract(Duration(hours: 39));
    picModel = 'day';
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
        .queryIllustRank(
            DateFormat('yyyy-MM-dd').format(picDate), picModel, currentPage, 30)
        .then((value) => value);
  }

  refreshIllustList({String picModel, DateTime picDate}) {
    this.picModel = picModel ?? this.picModel;
    this.picDate = picDate ?? this.picDate;
    getList().then((value) => illustList.value = value);
    scrollController.animateTo(0.0,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  loadData() {
    loadMore = false;
    currentPage++;
    getList(currentPage: currentPage).then((list) {
      illustList.value = illustList.value + list;
      loadMore = true;
    });
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
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
