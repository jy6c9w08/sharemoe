import 'dart:io';

import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:intl/intl.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/controller/image_controller.dart';
import 'package:sharemoe/controller/sapp_bar_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:bot_toast/bot_toast.dart';

import 'package:sharemoe/data/model/search.dart';
import 'package:sharemoe/data/repository/illust_repository.dart';
import 'package:sharemoe/data/repository/search_repository.dart';
import 'package:sharemoe/routes/app_pages.dart';

class SearchController extends GetxController {
  final hotSearchList = Rx<List<HotSearch>>([]);
  final String _picDateStr = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().subtract(Duration(days: 3)));
  final currentOnLoading = Rx<bool>(true);
  final suggestions = Rx<List<SearchKeywords>>([]);
  final TextZhPappBar texts = TextZhPappBar();
  static final SearchRepository searchRepository=getIt<SearchRepository>();
  static final IllustRepository illustRepository=getIt<IllustRepository>();

  String? searchKeywords;

  @override
  void onInit() {
    currentOnLoading.value = true;
    getEveryoneSearchList().then((value) => hotSearchList.value = value);
    super.onInit();
  }

  Future<List<HotSearch>> getEveryoneSearchList() async {
    return await searchRepository
        .queryHotSearchTags(_picDateStr)
        .then((value) => value);
  }

  getSuggestionList() async {
    if (searchKeywords != null)
      suggestions.value = await searchRepository
          .queryPixivSearchSuggestions(searchKeywords!)
          .then((value) => value);
  }

//翻译然后搜索
  transAndSearchTap(String keyword) {
    searchRepository
        .queryKeyWordsToTranslatedResult(keyword)
        .then((value) {
      Get.find<SappBarController>().searchTextEditingController.text =
          value.keyword;
      searchKeywords = value.keyword;
      if (!currentOnLoading.value) {
        Get.find<WaterFlowController>(tag: 'search')
            .refreshIllustList(searchKeyword: searchKeywords);
      }
      Get.put(
          WaterFlowController(model: 'search', searchKeyword: searchKeywords),
          tag: 'search');
      currentOnLoading.value = false;
    });
  }

  //Id搜画作
  searchIllustById(int illustId) {
    illustRepository.querySearchIllustById(illustId).then((value) {
      Get.put<ImageController>(ImageController(illust: value),
          tag: value.id.toString()+'true');
      Get.toNamed(Routes.DETAIL, arguments: value.id.toString());
    });
  }

  //以图搜图
  searchSimilarPicture(File imageFile) {
    ///添加showLoading
    late CancelFunc cancelLoading;
    cancelLoading=BotToast.showLoading();
     onReceiveProgress(int count, int total) {
      // cancelLoading=BotToast.showLoading();

    }
    illustRepository
        .queryPostImage(imageFile, onReceiveProgress)
        .then((value) {
      print(value);
      cancelLoading();
      if (!currentOnLoading.value) {
        Get.find<WaterFlowController>(
          tag: 'search',
        ).refreshIllustList(imageUrl: value);
      }
      Get.put(
          WaterFlowController(
              model: 'search', searchSimilar: true, imageUrl: value),
          tag: 'search');
      currentOnLoading.value = false;

    });
  }
}
