import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/repository/illust_repository.dart';

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  final illustList = Rx<List<Illust>>([]);
  ScrollController scrollController;
  int currentPage = 1;
  int listCount;
  bool loadMore = true;

  @override
  onInit() {
    print("home Controller");
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
