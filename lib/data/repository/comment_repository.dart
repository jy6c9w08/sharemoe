import 'package:injectable/injectable.dart';

import 'package:sharemoe/data/provider/api/comment/comment_rest_client.dart';
import 'package:sharemoe/data/model/comment.dart';


@lazySingleton
class CommentRepository {
  final CommentRestClient _commentRestClient;

  CommentRepository(this._commentRestClient);

  Future<List<Comment>> queryGetComment(
      String commentAppType, int illustId, int page, int pageSize) {
    return _commentRestClient
        .queryGetCommentInfo(commentAppType, illustId, page, pageSize)
        .then((value) => value.data);
  }

  Future<String> querySubmitComment(
      String commentAppType, int illustId, Map body,
      {Function onReceiveProgress}) {
    return _commentRestClient
        .querySubmitCommentInfo(
        commentAppType, illustId, body, onReceiveProgress)
        .then((value) => value);
  }

  Future<String> queryLikedComment(
      Map body,
      ) {
    return _commentRestClient
        .queryLikedCommentInfo(body)
        .then((value) => value);
  }

  Future<String> queryCancelLikedComment(
      String commentAppType, int commentAppId, int commentId) {
    return _commentRestClient
        .queryCancelLikedCommentInfo(commentAppType, commentAppId, commentId)
        .then((value) => value);
  }
}
