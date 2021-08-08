// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/data/model/bookmarked_user.dart';
import 'package:sharemoe/data/repository/illust_repository.dart';

class OtherUserListController extends GetxController {
  final Rx<List<BookmarkedUser>> otherUserList = Rx<List<BookmarkedUser>>([]);
  final int illustId;
  final ScrollController scrollController = ScrollController();
  late bool loadMoreAble = true;
  late int currentPage = 1;

  OtherUserListController({required this.illustId});

  Future getUsersData({int currentPage = 1}) async {
    return await getIt<IllustRepository>()
        .queryUserOfCollectionIllustList(illustId, currentPage, 10);
  }

  _doWhileScrolling() {
    if ((scrollController.position.extentAfter < 500) && loadMoreAble) {
      print("Load Comment");
      loadMoreAble = false;
      currentPage++;
      print('current page is $currentPage');
      getUsersData(currentPage: currentPage).then((value) {
        if (value.isNotEmpty) {
          otherUserList.value = otherUserList.value + value;
          loadMoreAble = true;
        }
      });
    }
  }

  @override
  void onInit() {
    getUsersData().then((value) => otherUserList.value = value);
    scrollController..addListener(_doWhileScrolling);
    super.onInit();
  }
}
