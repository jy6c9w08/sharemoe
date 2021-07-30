import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:bot_toast/bot_toast.dart';

import 'package:sharemoe/data/model/artist.dart';
import 'package:sharemoe/data/model/collection.dart';
import 'package:sharemoe/data/model/comment.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/model/message.dart';
import 'package:sharemoe/data/model/post_image_info.dart';
import 'package:sharemoe/data/provider/api/collection/collection_rest_client.dart';
import 'package:sharemoe/data/provider/api/comment/comment_rest_client.dart';
import 'package:sharemoe/data/provider/api/message/message_rest_cline.dart';
import 'package:sharemoe/data/provider/api/user/user_rest_client.dart';

@lazySingleton
class UserRepository {
  final UserRestClient _userRestClient;
  final CollectionRestClient _collectionRestClient;
  final MessageRestClient _messageRestClient;
  final CommentRestClient _commentRestClient;

  UserRepository(this._userRestClient, this._collectionRestClient,
      this._messageRestClient, this._commentRestClient);

  processDioError(obj) {
    final res = (obj as DioError).response;
    if (res!.statusCode == 400)
      BotToast.showSimpleNotification(title: '请登录后再重新加载画作');
    BotToast.showSimpleNotification(title: '获取画作信息失败，请检查网络');
  }

  Future<List<Artist>> queryFollowedWithRecentlyIllusts(int illustId, int page,
      int pageSize) {
    return _userRestClient
        .queryFollowedWithRecentlyIllustsInfo(illustId, page, pageSize)
        .then((value) => value.data);
  }

//画师最新画作
  Future<List<Illust>> queryUserFollowedLatestIllustList(int userId,
      String type, int page, int pageSize) {
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
    });
  }

//获取收藏的画作
  Future<List<Illust>> queryUserCollectIllustList(int userId, String type,
      int page, int pageSize) {
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

  Future<List<Illust>> queryOldHistoryList(String userId, int page,
      int pageSize) {
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

  Future<List<Illust>> queryGetCollectionList(int collectionId, int page,
      int pageSize) {
    return _userRestClient
        .queryGetCollectionListInfo(collectionId, page, pageSize)
        .then((value) => value.data);
  }

  Future<String> queryUserCancelMarkArtist(Map<String, dynamic> body) {
    return _userRestClient
        .queryUserCancelMarkArtistInfo(body)
        .then((value) => value);
  }

  Future<String> queryUserMarkArtist(Map<String, dynamic> body) {
    return _userRestClient.queryUserMarkArtistInfo(body).then((value) => value);
  }

  Future<String> queryNewUserViewIllustHistory(int userId,
      Map<String, dynamic> body) {
    return _userRestClient
        .queryNewUserViewIllustHistoryInfo(userId, body)
        .then((value) => value);
  }

  Future<List<Collection>> queryViewUserCollection(int userId, int page,
      int pageSize) {
    return _collectionRestClient
        .queryViewUserCollectionInfo(userId, page, pageSize)
        .then((value) => value.data);
  }

  Future<String> queryUserMarkIllust(Map<String, dynamic> body) {
    return _userRestClient.queryUserMarkIllustInfo(body).then((value) => value);
  }

  Future<String> queryUserCancelMarkIllust(Map<String, dynamic> body) {
    return _userRestClient
        .queryUserCancelMarkIllustInfo(body)
        .then((value) => value);
  }

  Future<PostImageInfo> queryPostAvatar(File body) {
    return _userRestClient
        .queryPostAvatarInfo(body)
        .then((value) => value.data);
  }

  Future<List<Message>> queryMessageList(int userId, int type, int offset) {
    return _messageRestClient
        .queryMessageListInfo(userId, type, offset)
        .then((value) => value.data);
  }

  Future queryUnReadMessage(int userId) {
    return _messageRestClient
        .queryUnReadMessageInfo(userId)
        .then((value) => value.data);
  }

  Future <Comment> queryGetSingleComment(int commentId) {
    return _commentRestClient
        .queryGetSingleCommentInfo(commentId)
        .then((value) => value.data);
  }


}
