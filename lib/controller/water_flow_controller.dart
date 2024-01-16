// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/controller/collection/collection_selector_controller.dart';
import 'package:sharemoe/controller/pic_controller.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/repository/artist_repository.dart';
import 'package:sharemoe/data/repository/collection_repository.dart';
import 'package:sharemoe/data/repository/illust_repository.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

class WaterFlowController extends GetxController
    with GetSingleTickerProviderStateMixin, StateMixin<List<Illust>> {
  WaterFlowController(
      {required this.model,
      this.searchKeyword,
      this.relatedId,
      this.isManga,
      this.artistId,
      this.collectionId,
      this.imageUrl,
      this.userId});

  late List<Illust> illustList = [];
  static final UserService userService = getIt<UserService>();
  static final UserRepository userRepository = getIt<UserRepository>();
  static final CollectionRepository collectionRepository =
      getIt<CollectionRepository>();
  static final ArtistRepository artistRepository = getIt<ArtistRepository>();
  static final IllustRepository illustRepository = getIt<IllustRepository>();

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
  String? imageUrl;
  String? dateStart;
  String? dateEnd;
  String? searchType;
  String? illustType;
  int? minWidth;
  int? minHeight;

  @override
  onInit() {
    // UserInfo? userInfo = userService.userInfo();
    // if (userInfo != null) {
    //   userId = userInfo.id.toString();
    // }
    this.picDate = DateTime.now().subtract(Duration(hours: 39));
    getList().then((value) {
      if (value.isNotEmpty) {
        value.forEach((element) {
          if (userService.r16FromHive()!) {
            illustList.add(element);
          } else if (element.sanityLevel < 4) illustList.add(element);
        });
        change(illustList, status: RxStatus.success());
      } else {
        change(illustList, status: RxStatus.empty());
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
      case 'similar':
        return await illustRepository.querySearchIllust(imageUrl!);
      case 'searchByTitle':
        return await illustRepository.querySearchByTitle(
            searchKeyword!, currentPage, 30);
      case 'searchByCriteria':
        return await illustRepository.querySearchByCriteria(
            searchKeyword!,
            currentPage,
            30,
            searchType,
            illustType,
            minWidth,
            minHeight,
            dateStart,
            dateEnd);
      case 'related':
        return await illustRepository.queryRelatedIllustList(
            relatedId!, currentPage, 30);
      case 'bookmarkIllust':
        return await illustRepository.queryUserCollectIllustList(
            int.parse(userId!), PicType.illust, currentPage, 30);
      case 'bookmarkMaga':
        return await illustRepository.queryUserCollectIllustList(
            int.parse(userId!), PicType.manga, currentPage, 30);
      case 'artistIllust':
        return await artistRepository.queryArtistIllustList(
            artistId!, PicType.illust, currentPage, 30, 10);
      case 'artistMaga':
        return await artistRepository.queryArtistIllustList(
            artistId!, PicType.manga, currentPage, 30, 10);

      case 'history':
        return await userRepository.queryHistoryList(
            userService.userInfo()!.id.toString(), currentPage, 30);
      case 'oldHistory':
        return await userRepository.queryOldHistoryList(
            userService.userInfo()!.id.toString(), currentPage, 30);
      case 'updateIllust':
        return await userRepository.queryUserFollowedLatestIllustList(
          int.parse(userService.userInfo()!.id.toString()),
          PicType.illust,
          currentPage,
          30,
        );
      case 'updateMaga':
        return await userRepository.queryUserFollowedLatestIllustList(
            int.parse(userService.userInfo()!.id.toString()),
            PicType.manga,
            currentPage,
            10);
      case 'collection':
        return await collectionRepository.queryViewCollectionIllust(
            collectionId!, currentPage, 10);
      case 'recommend':
        return await illustRepository.queryRecommendCollectIllust(
            int.parse(userService.userInfo()!.id.toString()));
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
      String? imageUrl,
      String? tag,
      String? dateEnd,
      String? dateStart,
      int? minHeight,
      int? minWidth,
      String? illustType,
      String? searchType}) {
    this.rankModel = rankModel ?? this.rankModel;
    this.picDate = picDate ?? this.picDate;
    this.searchKeyword = searchKeyword ?? this.searchKeyword;
    this.imageUrl = imageUrl ?? this.imageUrl;
    this.currentPage = 1;
    this.dateStart = dateStart ?? this.dateStart;
    this.dateEnd = dateEnd ?? this.dateEnd;
    this.minHeight = minHeight ?? this.minHeight;
    this.minWidth = minWidth ?? this.minWidth;
    this.searchType = searchType ?? this.searchType;
    this.illustType = illustType ?? this.illustType;
    loadMore = true;
    getList().then((value) {
      illustList.clear();
      if (value.isNotEmpty) {
        value.forEach((element) {
          if (userService.r16FromHive()!) {
            illustList.add(element);
          } else if (element.sanityLevel < 4) illustList.add(element);
        });
        change(illustList, status: RxStatus.success());
      } else {
        change(illustList, status: RxStatus.empty());
      }
    });

    // change(null, status: RxStatus.success());
    Get.find<PicController>(tag: tag ?? model).scrollController.animateTo(0.0,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  loadData() {
    loadMore = false;
    currentPage++;
    getList(currentPage: currentPage).then((list) {
      if (list.length != 0) {
        list.forEach((element) {
          if (userService.r16FromHive()!) {
            illustList.add(element);
          } else if (element.sanityLevel < 4) illustList.add(element);
        });
        update();
        loadMore = true;
      }
    });
  }

  @override
  void onClose() {
    if (Get.find<CollectionSelectorCollector>().selectList.length != 0)
      Get.find<CollectionSelectorCollector>().clearSelectList();
    super.onClose();
  }
}
