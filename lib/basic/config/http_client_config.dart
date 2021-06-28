import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'logger_config.dart';

Dio initDio() {
  Dio dioPixivic = Dio(BaseOptions(
      baseUrl: 'https://pix.ipv4.host',
      connectTimeout: 150000,
      receiveTimeout: 150000));
  dioPixivic.interceptors.add(
      InterceptorsWrapper(onRequest: (RequestOptions options, handler) async {
      String token=await UserService.queryToken();
    if ( token!= '') {
      options.headers['authorization'] =token;
    }
    logger.i(options.uri);
    logger.i(options.headers);
    handler.next(options);
  }, onResponse: (Response response, handler) async {
    if (response.statusCode == 200 &&
        response.headers['authorization'] != null) {
      UserService.setToken(response.headers['authorization']![0]);
    }
    if(response.statusCode == 401 ||
        response.statusCode == 403){
      UserService.signOutByTokenExpired();
    }
    if (response.data is Map) {
      if (response.data['data'] == null) response.data['data'] = [];
    }
    return handler.next(response);
  }, onError: (DioError e, handler) async {
    if (e.response != null) {
      logger.i('==== DioPixivic Catch ====');
// logger.i(e.response);
      logger.i(e.response!.statusCode);
      logger.i(e.response!.data);
      logger.i(e.response!.headers);
      // logger.i(e.response.request);
      if (e.response!.statusCode == 400)
        BotToast.showSimpleNotification(title: '请登陆后重新加载页面');
      else if (e.response!.statusCode == 500) {
        logger.i('500 error');
      } else if (e.response!.statusCode == 401 ||
          e.response!.statusCode == 403) {
        BotToast.showSimpleNotification(title: '登陆已失效，请重新登陆');
      } else if (e.response!.data['message'] != '')
        BotToast.showSimpleNotification(title: e.response!.data['message']);
    } else {
// Something happened in setting up or sending the request that triggered an Error
      if (e.message != '') BotToast.showSimpleNotification(title: e.message);
      // logger.i(e.request);
      logger.i(e.message);
    }
    return handler.next(e);
  }));
  logger.i("Dio初始化完毕");
  return dioPixivic;
}

@module
abstract class HttpClientConfig {
  @Named("baseUrl")
  String get baseUrl => "https://pix.ipv4.host";

  @singleton
  @preResolve
  Future<Dio> get dio =>  Future.value(initDio());
}
