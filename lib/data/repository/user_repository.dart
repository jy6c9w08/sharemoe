import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:bot_toast/bot_toast.dart';

import 'package:sharemoe/data/model/artist.dart';
import 'package:sharemoe/data/model/collection.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/provider/api/collection/collection_rest_client.dart';
import 'package:sharemoe/data/provider/api/user/user_rest_client.dart';



@lazySingleton
class UserRepository {
  final UserRestClient _userRestClient;
  final CollectionRestClient _collectionRestClient;

  UserRepository(this._userRestClient, this._collectionRestClient);

  processDioError(obj) {
    final res = (obj as DioError).response;
    if (res.statusCode == 400)
      BotToast.showSimpleNotification(title: '请登录后再重新加载画作');
    BotToast.showSimpleNotification(title: '获取画作信息失败，请检查网络');
  }

  Future<List<Artist>> queryFollowedWithRecentlyIllusts(
      int illustId, int page, int pageSize) {
    return _userRestClient
        .queryFollowedWithRecentlyIllustsInfo(illustId, page, pageSize)
        .then((value) => value.data);
  }

//画师最新画作
  Future<List<Illust>> queryUserFollowedLatestIllustList(
      int userId, String type, int page, int pageSize) {
    return _userRestClient
        .queryUserFollowedLatestIllustListInfo(userId, type, page, pageSize)
        .then((value) => value.data)
        .catchError((Object obj) {
      switch (obj.runtimeType) {
        case DioError:
          processDioError(obj);
          break;
        default:
      }
      return;
    });
  }

//获取收藏的画作
  Future<List<Illust>> queryUserCollectIllustList(
      int userId, String type, int page, int pageSize) {
    return _userRestClient
        .queryUserCollectIllustListInfo(userId, type, page, pageSize)
        .then((value) => value.data)
        .catchError((Object obj) {
      switch (obj.runtimeType) {
        case DioError:
          processDioError(obj);
          break;
        default:
      }
    });
  }

  Future<List<Illust>> queryHistoryList(String userId, int page, int pageSize) {
    return _userRestClient
        .queryHistoryListInfo(userId, page, pageSize)
        .then((value) => value.data)
        .catchError((Object obj) {
      switch (obj.runtimeType) {
        case DioError:
          processDioError(obj);
          break;
        default:
      }
    });
  }

  Future<List<Illust>> queryOldHistoryList(
      String userId, int page, int pageSize) {
    return _userRestClient
        .queryOldHistoryListInfo(userId, page, pageSize)
        .then((value) => value.data)
        .catchError((Object obj) {
      switch (obj.runtimeType) {
        case DioError:
          processDioError(obj);
          break;
        default:
      }
    });
  }

  Future<List<Illust>> queryGetCollectionList(
      int collectionId, int page, int pageSize) {
    return _userRestClient
        .queryGetCollectionListInfo(collectionId, page, pageSize)
        .then((value) => value.data);
  }

  Future<String> queryUserCancelMarkArtist(Map body) {
    return _userRestClient
        .queryUserCancelMarkArtistInfo(body)
        .then((value) => value);
  }

  Future<String> queryUserMarkArtist(Map body) {
    return _userRestClient.queryUserMarkArtistInfo(body).then((value) => value);
  }

  Future<String> queryNewUserViewIllustHistory(int userId, Map body) {
    return _userRestClient
        .queryNewUserViewIllustHistoryInfo(userId, body)
        .then((value) => value);
  }

  Future<List<Collection>> queryViewUserCollection(
      int userId, int page, int pageSize) {
    return _collectionRestClient
        .queryViewUserCollectionInfo(userId, page, pageSize)
        .then((value) => value.data);
  }

  Future<String> queryUserMarkIllust(Map body) {
    return _userRestClient.queryUserMarkIllustInfo(body).then((value) => value);
  }

  Future<String> queryUserCancelMarkIllust(Map body) {
    return _userRestClient
        .queryUserCancelMarkIllustInfo(body)
        .then((value) => value);
  }
}
