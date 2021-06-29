import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sharemoe/basic/service/user_service.dart';

import 'logger_config.dart';

Dio initDio() {
  logger.i("Dio开始初始化");
  Dio dioPixivic = Dio(BaseOptions(
      baseUrl: 'https://pix.ipv4.host',
      connectTimeout: 150000,
      receiveTimeout: 150000));
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
    }
    if (response.data is Map) {
      if (response.data['data'] == null) response.data['data'] = [];
    }
    return handler.next(response);
  }, onError: (DioError e, handler) async {
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
          BotToast.showSimpleNotification(
              title: '参数错误：${e.response!.data['message']}');
          break;
        case 500:
          BotToast.showSimpleNotification(title: '${e.response!.data}');
          break;
        case 401:
        case 403:
          UserService.signOutByTokenExpired();
          BotToast.showSimpleNotification(
              title: '${e.response!.data['message']}',
              duration: null,
              onClose: () {});
          break;
        default:
          {
            if (e.message != '')
              BotToast.showSimpleNotification(title: '${e.response!.data}');
          }
      }
    } else {
      // Something happened in setting up or sending the request that triggered an Error
      if (e.message != '') BotToast.showSimpleNotification(title: e.message);
      logger.i(e.message);
    }
    return handler.next(e);
  }));
  logger.i("Dio初始化完毕");
  return dioPixivic;
}

@module
abstract class HttpClientConfig {
  @singleton
  @preResolve
  Future<Dio> get dio => Future.value(initDio());
}
