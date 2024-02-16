// Package imports:
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:sharemoe/basic/constant/event_type.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/domain/event.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'get_it_config.dart';
import 'logger_config.dart';

alertByBotToast(String message) {
  //try {
  BotToast.showSimpleNotification(title: message, hideCloseButton: true);
  // } catch (e) {}
}

Dio initSharemoeDio() {
  logger.i("Dio开始初始化");
  Dio dioPixivic = Dio(BaseOptions(
      contentType: "application/json",
      baseUrl: PicDomain.DOMAIN,
      connectTimeout: Duration(milliseconds: 150000),
      receiveTimeout: Duration(milliseconds: 150000)));
  dioPixivic.interceptors.add(
      InterceptorsWrapper(onRequest: (RequestOptions options, handler) async {
    String token = await UserService.queryToken();
    if (token != '') {
      options.headers['authorization'] = token;
    }
    handler.next(options);
  }, onResponse: (Response response, handler) async {
    if (response.statusCode == 200 &&
        response.headers['authorization'] != null) {
      UserService.setToken(response.headers['authorization']![0]);
      // 使用postman需要auth
      // print(response.headers['authorization']![0]);
      // print(getIt<UserService>().userInfo()!.id);
    }
    if (response.data is Map) {
      if (response.data['data'] == null) response.data['data'] = [];
    }
    return handler.next(response);
  }, onError: (DioException e, ErrorInterceptorHandler handler) async {
    if (e.response != null) {
      logger.e('==== 请求异常 ====');
      logger.e("本次异常请求url为：${e.requestOptions.uri}");
      logger.e("本次异常请求体为：${e.requestOptions.data}");
      logger.e("本次异常请求头为：${e.requestOptions.headers}");
      logger.e("本次异常响应状态码为：${e.response!.statusCode}");
      logger.e("本次异常响应头为：${e.response!.headers}");
      logger.e("本次异常响应体为：${e.response!.data}");
      switch (e.response!.statusCode) {
        case 400:
          alertByBotToast('参数错误：${e.response!.data['message']}');
          return handler.next(e);
        case 500:
          alertByBotToast('${e.response!.data}');
          return handler.next(e);
        case 401:
          //case 403:
          //过期登出
          String token = await UserService.queryToken();
          if (token != '') {
            await UserService.signOutByTokenExpired();
            //释放过期登出事件
            getIt<EventBus>().fire(new Event(EventType.signOut, null));
          }
          return handler.next(e);
        case 409:
          alertByBotToast('${e.response!.data['message']}');
          return handler.next(e);
        default:
          {
            if (e.message != '' && e.response!.data['message'] != '')
              alertByBotToast('${e.response!.data['message']}');
            return handler.next(e);
          }
      }
    } else {
      // Something happened in setting up or sending the request that triggered an Error
      // alertByBotToast(e.message!);
      logger.i(e.message);
      return handler.next(e);
    }
  }));
  logger.i("Dio初始化完毕");
  return dioPixivic;
}


Dio initGADio() {
  return Dio()
    ..interceptors.add(
        InterceptorsWrapper(onRequest: (RequestOptions options, handler) async {
      print('GARestDio');
    }));
}

@module
abstract class HttpClientConfig {
  @singleton
  @preResolve
  @Named("main")
  Future<Dio> get mainDio => Future.value(initSharemoeDio());

  @singleton
  @preResolve
  @Named("GARest")
  Future<Dio> get gARestDio => Future.value(initGADio());
}
