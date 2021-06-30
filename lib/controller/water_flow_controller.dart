import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/controller/home_controller.dart';
import 'package:sharemoe/controller/pic_controller.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/model/user_info.dart';
import 'package:sharemoe/data/repository/artist_repository.dart';
import 'package:sharemoe/data/repository/collection_repository.dart';
import 'package:sharemoe/data/repository/illust_repository.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

class WaterFlowController extends GetxController
    with SingleGetTickerProviderMixin, StateMixin<List<Illust>> {
  WaterFlowController(
      {required this.model,
      this.searchKeyword,
      this.relatedId,
      this.isManga,
      this.artistId,
      this.collectionId,
      this.searchSimilar = false,
      this.imageUrl});

  final illustList = Rx<List<Illust>>([]);
  static final UserService userService=getIt<UserService>();
  static final UserRepository userRepository=getIt<UserRepository>();
  static final CollectionRepository collectionRepository=getIt<CollectionRepository>();
  static final ArtistRepository artistRepository=getIt<ArtistRepository>();
  static final IllustRepository illustRepository=getIt<IllustRepository>();

  // final isLike = Rx<bool>(true);
  final HomePageController homePageController = Get.find<HomePageController>();
  final ScreenUtil screen = ScreenUtil();
  int currentPage = 1;
  bool loadMore = true;
  DateTime? picDate;
  String? rankModel = 'day';
  String model;
  String? searchKeyword;
  num? relatedId;
  String? userId;
  int? artistId;
  bool? isManga;
  int? collectionId;
  bool searchSimilar;
  String? imageUrl;

  @override
  onInit() {
    UserInfo? userInfo=userService.userInfo();
    if(userInfo!=null){
      userId=userInfo.id.toString();
    }
    this.picDate = DateTime.now().subtract(Duration(hours: 39));
    getList().then((value) {
      if (value.isNotEmpty) {
        illustList.value = value;
        change(illustList.value, status: RxStatus.success());
      } else {
        change(illustList.value, status: RxStatus.empty());
      }
    });
    super.onInit();
  }

  Future<List<Illust>> getList({currentPage = 1}) async {
    switch (model) {
      case 'home':
        return await illustRepository.queryIllustRank(
            DateFormat('yyyy-MM-dd').format(picDate!),
            rankModel!,
            currentPage,
            30);
      case 'search':
        return searchSimilar
            ? await illustRepository.querySearchIllust(imageUrl!)
            : await illustRepository
                .querySearch(searchKeyword!, 30, currentPage);
      case 'related':
        return await illustRepository
            .queryRelatedIllustList(relatedId!, currentPage, 30);
      case 'bookmark':
        return isManga!
            ? await illustRepository.queryUserCollectIllustList(
                int.parse(userId!), PicType.manga, currentPage, 30)
            : await illustRepository.queryUserCollectIllustList(
                int.parse(userId!), PicType.illust, currentPage, 30);
      case 'artist':
        return isManga!
            ? await artistRepository.queryArtistIllustList(
                artistId!, PicType.manga, currentPage, 30, 10)
            : await artistRepository.queryArtistIllustList(
                artistId!, PicType.illust, currentPage, 30, 10);

      case 'history':
        return await userRepository
            .queryHistoryList(userId!, currentPage, 30);
      case 'oldHistory':
        return await userRepository
            .queryOldHistoryList(userId!, currentPage, 30);
      case 'update':
        return isManga!
            ? await userRepository.queryUserFollowedLatestIllustList(
                int.parse(userId!), PicType.manga, currentPage, 10)
            : await userRepository.queryUserFollowedLatestIllustList(
                int.parse(userId!),
                PicType.illust,
                currentPage,
                30,
              );
      case 'collection':
        return await collectionRepository
            .queryViewCollectionIllust(collectionId!, currentPage, 10);
      default:
        return await illustRepository.queryIllustRank(
            DateFormat('yyyy-MM-dd').format(picDate!),
            rankModel!,
            currentPage,
            30);
    }
  }

  refreshIllustList(
      {String? rankModel,
      DateTime? picDate,
      String? searchKeyword,
      String? imageUrl}) {
    this.rankModel = rankModel ?? this.rankModel;
    this.picDate = picDate ?? this.picDate;
    this.searchKeyword = searchKeyword ?? this.searchKeyword;
    this.imageUrl = imageUrl ?? this.imageUrl;
    getList().then((value) => illustList.value = value);
    Get.find<PicController>(tag: model).scrollController.animateTo(0.0,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  loadData() {
    loadMore = false;
    currentPage++;
    if (!searchSimilar)
      getList(currentPage: currentPage).then((list) {
        if (list.length != 0) {
          illustList.value = illustList.value + list;
          loadMore = true;
        }
      });
  }

  @override
  void onClose() {
    super.onClose();
  }
}
