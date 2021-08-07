// Package imports:
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

// Project imports:
import 'package:sharemoe/data/model/daily.dart';
import 'package:sharemoe/data/model/result.dart';
import 'package:sharemoe/data/model/user_info.dart';
import 'package:sharemoe/data/model/verification.dart';

part 'user_base_rest_client.g.dart';

@Injectable()
@RestApi(baseUrl: "https://pix.ipv4.host")
abstract class UserBaseRestClient {
  @factoryMethod
  factory UserBaseRestClient(Dio dio) = _UserBaseRestClient;

//获取图形验证码
  @GET("/verificationCode")
  Future<Result<Verification>> queryVerificationCodeInfo();

//获取手机验证码
  @GET("/messageVerificationCode")
  Future<Result> queryMessageVerificationCodeInfo(
    @Query('vid') String vid,
    @Query('value') String code,
    @Query('phone') int phone,
  );

//验证邮箱是否可用
  @GET("/users/emails/{emialAddr}")
  Future queryVerifyEmailIsAvailableInfo(
      @Path("emialAddr") String emialAddr);

//验证用户名可用性
  @GET("/users/usernames/{username}")
  Future queryVerifyUserNameIsAvailableInfo(@Path("username") String username);

//用户注册
  @POST("/users")
  Future<Result> queryUserRegistersInfo(
    @Query("vid") String vid,
    @Query("value") String code,
    @Body() Map<String, dynamic> body,
  );

  //用户登录
  @POST("/users/token")
  Future<Result<UserInfo>> queryUserLoginInfo(
    @Query("vid") String vid,
    @Query("value") String code,
    @Body() Map<String, dynamic> body,
  );

  //用户绑定QQ
  @PUT("/users/{userId}/qqAccessToken")
  Future<String> queryBindQQInfo(
    @Path("userId") int userId,
    @Query("qqAccessToken") String qqAccessToken,
  );

  //发送密码重置邮件
  @GET("/users/emails/{emailAddr}/resetPasswordEmail")
  Future<Result> queryResetPasswordByEmailInfo(
    @Path("emailAddr") String emailAddr,
  );

  //用户重置密码
  @GET("/users/password")
  Future<String> queryUserResetPasswordInfo(
    @Query("vid") String vid,
    @Query("value") String code,
  );

  //用户验证新邮箱
  @GET("/users/emails/{email}/checkEmail")
  Future<String> queryUserVerifyNewEmailInfo(
    @Path("email") String email,
  );

  //用户设置邮箱
  @GET("/users/{userId}/email")
  Future<String> queryUserSetEmailInfo(
    @Path("userId") int userId,
    @Query("vid") String vid,
    @Query("value") String code,
    @Query("email") String email,
  );

  //获取用户是否验证邮箱
  @GET("/users/{userId}/email/isCheck")
  Future<Result<bool>> queryIsUserVerifyEmailInfo(
    @Path("userId") int userId,
  );

  //QQ登录
  @GET("/users/tokenWithQQ")
  Future<String> queryLoginByQQInfo(
    @Query("qqAccessToken") String qqAccessToken,
  );

  //检查是否绑定QQ
  @GET("/users/{userId}/isBindQQ")
  Future<Result<bool>> queryIsBindQQInfo(
    @Path("userId") int userId,
  );

  //查看用户信息
  @GET("/users/{userId}")
  Future<Result<UserInfo>> querySearchUserInfo(
    @Path("userId") int userId,
  );

  //更新用户信息
  //不确定返回类型
  @PUT("/{userId}")
  Future queryUpdateUserInfo(
    @Path("userId") int userId,
    @Body() Map<String, dynamic> body,
  );

  //解绑QQ
  @DELETE("/users/{userId}/qqAccessToken")
  Future<Result<bool>> queryUntieQQInfo(
    @Path("userId") int userId,
  );

  //查看用户最近积分历史
  // @GET("/users/{userId}/creditHistory")
  // Future<Result<bool>> queryUserCreditHistoryInfo(
  //   @Path("userId") int userId,
  // );

  //获取签到状态
  @GET("/users/check-in")
  Future<Result<bool>> queryGetSignInfo();

//每日签到
  @POST("/users/check-in")
  Future<Result<DailyModel>> queryPostSignInfo();

  //修改用户名
  @PUT("/{userId}/username")
  Future<Result<UserInfo>> queryModifyUserNameInfo(
    @Path("userId") int userId,
    @Query("username") String userName,
  );


  //检验手机号可用
  @GET("/users/phones/{phone}")
  Future queryIsUserVerifyPhoneInfo(@Path("phone") String phone);
}
