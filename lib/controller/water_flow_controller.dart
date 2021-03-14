import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/basic/texts.dart';
import 'package:sharemoe/controller/home_controller.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/repository/illust_repository.dart';

class WaterFlowController extends GetxController
    with SingleGetTickerProviderMixin {
  WaterFlowController(
      {this.model,
      this.searchKeyword,
      this.relatedId,
      this.userId,
      this.isManga});

  final illustList = Rx<List<Illust>>();
  final HomePageController homePageController = Get.find<HomePageController>();
  final ScreenUtil screen = ScreenUtil();
  ScrollController scrollController;
  int currentPage = 1;
  bool loadMore = true;
  DateTime picDate;
  String rankModel = 'day';
  String model = 'home';
  String searchKeyword;
  num relatedId;
  String userId;
  bool isManga;

  @override
  onInit() {
    print("WaterFlow Controller");
    this.picDate = DateTime.now().subtract(Duration(hours: 39));
    // this.rankModel = 'day';
    // this.model = 'home';
    getList().then((value) => illustList.value = value);
    initScrollController();
    super.onInit();
  }

  initScrollController() {
    scrollController = ScrollController(initialScrollOffset: 0.0)
      ..addListener(listenTheList);
  }

  Future<List<Illust>> getList({currentPage = 1}) async {
    switch (model) {
      case 'home':
        return await getIt<IllustRepository>().queryIllustRank(
            DateFormat('yyyy-MM-dd').format(picDate),
            rankModel,
            currentPage,
            30);
      case 'search':
        return await getIt<IllustRepository>()
            .querySearch(searchKeyword, 30, currentPage);
      case 'related':
        return await getIt<IllustRepository>()
            .queryRelatedIllustList(relatedId, currentPage, 30);
      case 'bookmarkManga':
        return await getIt<IllustRepository>().queryUserCollectIllustList(
            int.parse(userId), AppType.manga, currentPage, 30);
      case 'bookmarkIllust':
        return await getIt<IllustRepository>().queryUserCollectIllustList(
            int.parse(userId), AppType.illust, currentPage, 30);
      default:
        return await getIt<IllustRepository>().queryIllustRank(
            DateFormat('yyyy-MM-dd').format(picDate),
            rankModel,
            currentPage,
            30);
    }
  }

  refreshIllustList(
      {String rankModel, DateTime picDate, String searchKeyword}) {
    this.rankModel = rankModel ?? this.rankModel;
    this.picDate = picDate ?? this.picDate;
    this.searchKeyword = searchKeyword ?? this.searchKeyword;
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
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
