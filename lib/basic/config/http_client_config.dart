import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:hive/hive.dart';

import 'get_it_config.dart';
import 'hive_config.dart';

Dio dioPixivic = initDio();

Dio initDio() {
  Logger logger = getIt<Logger>();
  Dio dioPixivic = Dio(BaseOptions(
      baseUrl: 'https://pix.ipv4.host',
      headers: picBox.get('auth') == null
          ? {'Content-Type': 'application/json'}
          : {
        'authorization': picBox.get('auth'),
        'Content-Type': 'application/json'
      },
      connectTimeout: 150000,
      receiveTimeout: 150000));
  dioPixivic.interceptors
      .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
    logger.i(options.uri);
    logger.i(options.headers);
    return options;
  }, onResponse: (Response response) async {
// logger.i(response.data);
// BotToast.showSimpleNotification(title: response.data['message']);
    if (response.statusCode == 200 &&
        response.headers.map['authorization'] != null) {
      picBox.put('auth', response.headers['authorization']);
      // var userInfoBox = await Hive.openBox(HiveBox.USER_INFO);
      // userInfoBox.put('auth', response.headers.map['authorization'][0]);
    }
    return response;
  }, onError: (DioError e) async {
    if (e.response != null) {
      logger.i('==== DioPixivic Catch ====');
// logger.i(e.response);
      logger.i(e.response.statusCode);
      logger.i(e.response.data);
      logger.i(e.response.headers);
      logger.i(e.response.request);
      if (e.response.statusCode == 400)
        BotToast.showSimpleNotification(title: '请登陆后重新加载页面');
      else if (e.response.statusCode == 500) {
        logger.i('500 error');
      } else if (e.response.statusCode == 401 || e.response.statusCode == 403) {
        BotToast.showSimpleNotification(title: '登陆已失效，请重新登陆');
      } else if (e.response.data['message'] != '')
        BotToast.showSimpleNotification(title: e.response.data['message']);
    } else {
// Something happened in setting up or sending the request that triggered an Error
      if (e.message != '') BotToast.showSimpleNotification(title: e.message);
      logger.i(e.request);
      logger.i(e.message);
    }
    return e;
  }));
  logger.i("Dio初始化完毕");
  return dioPixivic;
}

@module
abstract class HttpClientConfig {
  @Named("baseUrl")
  String get baseUrl => "https://pix.ipv4.host";

  @lazySingleton
  Dio get dio => dioPixivic;
}
