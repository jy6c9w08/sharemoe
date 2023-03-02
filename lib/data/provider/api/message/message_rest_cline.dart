// Package imports:
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

// Project imports:
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/data/model/message.dart';
import 'package:sharemoe/data/model/result.dart';

part 'message_rest_cline.g.dart';

@Injectable()
@RestApi(baseUrl: PicDomain.DOMAIN)
abstract class MessageRestClient {
  @factoryMethod
  factory MessageRestClient(Dio dio) = _MessageRestClient;

//获取某个分类下的消息列表
// 类型 分别有1（评论与回复）2（点赞）3（收藏）4（关注）
  @GET("/users/{userId}/reminds")
  Future<Result<List<Message>>> queryMessageListInfo(
    @Path("userId") int userId,
    @Query("type") int type,
    @Query("offset") int offset,
  );

  //获取总未读消息数量
  @GET("/users/{userId}/unreadRemindsCount")
  Future<Result<int>> queryUnReadMessageInfo(
    @Path("userId") int userId,
  );

  //获取某个分类下的消息列表
  @GET("/users/{userId}/remindSummary")
  Future<Result<List>> queryUnReadMessageByTypeInfo(
    @Path("userId") int userId,
  );

  //清空某分类下未读消息数量
  @PUT("/users/{userId}/unreadRemindsCount")
  Future<Result<bool>> queryDeleteUnReadMessageByTypeInfo(
    @Path("userId") int userId,
    @Body() Map<String, dynamic> body,
  );
}
