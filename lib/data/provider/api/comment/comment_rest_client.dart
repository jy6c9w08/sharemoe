// Package imports:
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

// Project imports:
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/data/model/comment.dart';
import 'package:sharemoe/data/model/result.dart';

part 'comment_rest_client.g.dart';

@lazySingleton
@RestApi(baseUrl: PicDomain.DOMAIN)
abstract class CommentRestClient {
  @factoryMethod
  factory CommentRestClient(Dio dio) =
      _CommentRestClient;

//提交评论
  @POST("/{commentAppType}/{commentAppId}/comments")
  Future <Result<int>>querySubmitCommentInfo(
    @Path("commentAppType") String commentAppType,
    @Path("commentAppId") int illustId,
    @Body() Map<String, dynamic> body,
  );

  //拉取评论
  @GET("/{commentAppType}/{commentAppId}/comments")
  Future<Result<List<Comment>>> queryGetCommentInfo(
      @Path("commentAppType") String commentAppType,
      @Path("commentAppId") int illustId,
      @Query("page") int page,
      @Query("pageSize") int pageSize);

//点赞
  @POST("/user/likedComments")
  Future<String> queryLikedCommentInfo(@Body() Map<String, dynamic> body);

//取消点赞
  @DELETE("/user/likedComments/{commentAppType}/{commentAppId}/{commentId}")
  Future<String> queryCancelLikedCommentInfo(
      @Path("commentAppType") String commentAppType,
      @Path("commentAppId") int commentAppId,
      @Path("commentId") int commentId);

  //获取顶级评论数
  @GET("/{commentAppType}/{commentAppId}/topCommentCount")
  Future<Result<Comment>> queryGetTopCommentCountInfo(
      @Path("commentAppType") String commentAppType,
      @Path("commentAppId") int commentAppId);

  //拉取单条评论
  @GET("/comments/{commentId}")
  Future<Result<Comment>> queryGetSingleCommentInfo(
    @Path("commentId") int commentId,
  );
}
