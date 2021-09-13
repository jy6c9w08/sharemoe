// Package imports:
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/controller/search_controller.dart';
import 'package:sharemoe/data/model/artist.dart';
import 'package:sharemoe/data/repository/artist_repository.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

class ArtistListController extends GetxController
    with StateMixin<List<Artist>> {
  final artistList = Rx<List<Artist>>([]);
  final String model;
  late int currentPage;
  static final UserService userService = getIt<UserService>();
  static final UserRepository userRepository = getIt<UserRepository>();
  static final ArtistRepository artistRepository = getIt<ArtistRepository>();
  late ScrollController scrollController;

  ArtistListController({required this.model});

  void onInit() {
    scrollController = ScrollController(initialScrollOffset: 0.0)
      ..addListener(listenTheList);
    getArtistListData().then((value) {
      if (value.isNotEmpty) {
        artistList.value = value;
        change(artistList.value, status: RxStatus.success());
      } else {
        change(artistList.value, status: RxStatus.empty());
      }
    });
    super.onInit();
  }

  refreshArtistList() {
    getArtistListData().then((value) {
      if (value.isNotEmpty) {
        artistList.value = value;
        change(artistList.value, status: RxStatus.success());
      } else {
        change(artistList.value, status: RxStatus.empty());
      }
      scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  listenTheList() {}

  Future<List<Artist>> getArtistListData({currentPage = 1}) async {
    switch (model) {
      case 'follow':
        return await userRepository.queryFollowedWithRecentlyIllusts(
            Get.arguments, currentPage, 30);
      // case model:
      //   return await artistRepository.querySearchArtist(
      //       Get.find<SearchController>(tag: model).searchKeywords!, currentPage, 30);
      case 'guessLike':
        return artistRepository
            .queryGuessLikeArtist(getIt<UserService>().userInfo()!.id);
      default:
        return await artistRepository.querySearchArtist(
            Get.find<SearchController>(tag: model).searchKeywords!,
            currentPage,
            30);
    }
  }
}
