// Dart imports:
import 'dart:io';

// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:sharemoe/data/model/bookmarked_user.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/provider/api/illust/illust_rest_client.dart';
import 'package:sharemoe/data/provider/api/rank/rank_rest_client.dart';
import 'package:sharemoe/data/provider/api/recommend/recommend_rest_client.dart';
import 'package:sharemoe/data/provider/api/search/search_rest_client.dart';
import 'package:sharemoe/data/provider/api/search_for_picture/search_for_picture_client.dart';
import 'package:sharemoe/data/provider/api/user/user_rest_client.dart';

@lazySingleton
class IllustRepository {
  final RankRestClient _rankRestClient;
  final SearchRestClient _searchRestClient;
  final RecommendRestClient _recommendRestClient;
  final IllustRestClient _illustRestClient;
  final UserRestClient _userRestClient;
  final SearchForPictureClient _searchForPictureClient;

  IllustRepository(
      this._rankRestClient,
      this._searchRestClient,
      this._recommendRestClient,
      this._illustRestClient,
      this._userRestClient,
      this._searchForPictureClient);

  Future<List<Illust>> queryIllustRank(
      String date, String mode, int page, int pageSize) {
    return _rankRestClient
        .queryIllustRankInfo(date, mode, page, pageSize)
        .then((value) => value.data);
  }

  Future<List<Illust>> querySearch(String keyword, int page, int pageSize) {
    return _searchRestClient
        .querySearchListInfo(keyword, page, pageSize)
        .then((value) => value.data);
  }

//以图搜图
  Future<List<Illust>> querySearchForPictures(String imageUrl) {
    return _searchRestClient
        .querySearchForPicturesInfo(imageUrl)
        .then((value) => value.data);
  }

  //推荐收藏画作
  Future<List<Illust>> queryRecommendCollectIllust(int userId) {
    return _recommendRestClient
        .queryRecommendCollectIllustInfo(userId)
        .then((value) => value.data);
  }

  //Id查画作
  Future<Illust> querySearchIllustById(
    int illustId,
  ) {
    return _illustRestClient
        .querySearchIllustByIdInfo(illustId)
        .then((value) => value.data);
    //     .catchError((Object obj) {
    //   switch (obj.runtimeType) {
    //     case DioError:
    //       final res = (obj as DioError).response;
    //       print(res.statusCode);
    //       BotToast.showSimpleNotification(title: res.data['message']);
    //       break;
    //     default:
    //       return false;
    //   }
    // });
  }

//关联画作
  Future<List<Illust>> queryRelatedIllustList(
      num relatedId, int page, int pageSize) {
    return _illustRestClient
        .queryRelatedIllustListInfo(relatedId, page, pageSize)
        .then((value) => value.data);
  }

//标签下画作列表

  // Future<List<Illust>> queryIllustUnderTagList(
  //     int categotyId, int tagId, String type, double offset, int pageSize) {
  //   return _wallpaperRestClient
  //       .queryIllustUnderTagListInfo(categotyId, tagId, type, offset, pageSize)
  //       .then((value) => value.data);
  // }

  Future<List<BookmarkedUser>> queryUserOfCollectionIllustList(
      num userId, int page, int pageSize) {
    return _illustRestClient
        .queryUserOfCollectionIllustListInfo(userId, page, pageSize)
        .then((value) => value.data);
  }

  Future<List<Illust>> queryUserCollectIllustList(
      int userId, String type, int page, int pageSize) {
    return _userRestClient
        .queryUserCollectIllustListInfo(userId, type, page, pageSize)
        .then((value) => value.data);
  }

  Future<String> queryPostImage(File body,void onReceiveProgress(int a,int b)) {
    return _searchForPictureClient
        .queryPostImageInfo(body,onReceiveProgress)
        .then((value) => value.data);
  }

  Future<List<Illust>> querySearchIllust(String imageUrl) {
    return _searchForPictureClient
        .querySearchIllustInfo(imageUrl)
        .then((value) => value.data);
  }
}
