// Package imports:
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/data/model/collection.dart';
import 'package:sharemoe/data/repository/collection_repository.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

class CollectionController extends GetxController
    with StateMixin<List<Collection>> {
  late int currentViewerPage = 1;
  late int userId;
  late ScrollController scrollController;
  late bool loadMoreAble = true;

  final collectionList = Rx<List<Collection>>([]);
  static final UserService userService = getIt<UserService>();
  static final UserRepository userRepository = getIt<UserRepository>();
  static CollectionRepository collectionRepository =
      getIt<CollectionRepository>();

  Future<List<Collection>> getCollectionList({currentViewerPage = 1}) async {
    return await userRepository.queryViewUserCollection(
        userId, currentViewerPage, 10);
  }

//TODO 用户获取自己的画集摘要列表（用于快速添加）
  getCollectionsDigest() {}

  void updateCollection() {
    update(['collection']);
  }

  void deleteCollect(int index) {
    collectionList.value.removeAt(index);
    update();
  }

  void refreshList() {
    getCollectionList().then((value) {
      if (value.isNotEmpty) {
        collectionList.value = value;
        change(collectionList.value, status: RxStatus.success());
      } else
        change(collectionList.value, status: RxStatus.empty());
    });
  }

  _autoLoading() {
    if ((scrollController.position.extentAfter < 500) && loadMoreAble) {
      print("Load collectionList");
      loadMoreAble = false;
      currentViewerPage++;
      print('current page is $currentViewerPage');
      getCollectionList(currentViewerPage: currentViewerPage).then((value) {
        if (value.isNotEmpty) {
          collectionList.value.addAll(value);
          loadMoreAble = true;
          change(collectionList.value, status: RxStatus.success());
        }
      });
    }
  }

  @override
  void onInit() {
    userId = userService.userInfo()!.id;
    scrollController = ScrollController()..addListener(_autoLoading);
    getCollectionList().then((value) {
      if (value.isNotEmpty) {
        collectionList.value = value;
        change(collectionList.value, status: RxStatus.success());
      } else
        change(collectionList.value, status: RxStatus.empty());
      // return collectionList.value = value;
    });
    super.onInit();
  }
}
