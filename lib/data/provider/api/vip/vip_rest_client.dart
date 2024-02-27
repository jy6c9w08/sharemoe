// Package imports:
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

// Project imports:
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/data/model/result.dart';
import 'package:sharemoe/data/model/server_address.dart';
import 'package:sharemoe/data/model/user_info.dart';

part 'vip_rest_client.g.dart';

@Injectable()
@RestApi(baseUrl: PicDomain.DOMAIN)
abstract class VipRestClient {
  @factoryMethod
  factory VipRestClient(@Named('main') Dio dio) = _VipRestClient;

  //兑换会员码
  @PUT("/users/{userId}/permissionLevel")
  Future queryGetVIPInfo(
    @Path("userId") int userId,
    @Query("exchangeCode") String exchangeCode,
  );

  //获取高速服务器
  @GET("/vipProxyServer")
  Future<Result<List<ServerAddress>>> queryGetHighSpeedServerInfo();

//获取活动可参与状态
  @GET("/vipActivity/{activityName}/canParticipateStatus")
  Future<Result<String>> queryCanParticipateStatusInfo(
      @Path("activityName") String activityName);

  //参与活动
  @PUT("/vipActivity/{activityName}/participateStatus")
  Future<Result<UserInfo>> queryParticipateInfo(
      @Path("activityName") String activityName);
}
