import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sharemoe/basic/service/user_service.dart';

@singleton
@preResolve
class PostImageIdService {
  ReceivePort receivePort = ReceivePort();
  late SendPort _sendPort;
  @factoryMethod
  static Future<PostImageIdService> create(Logger logger) async {
    logger.i("上传图片id服务初始化");
    PostImageIdService postImageIdService = PostImageIdService();
    await postImageIdService._init();
    logger.i("上传图片id服务初始化完毕");
    return postImageIdService;
  }

  Future<void> _init() async {
    //创建线程
   await Isolate.spawn(entryPoint, receivePort.sendPort);
   receivePort.listen((message) {
     if (message is SendPort) {
       print("main接收到子isolate的发送器了");
       _sendPort = message;
     } else {
       print(message);
     }
   });
  }
 void sendId(int id){
  _sendPort.send(id);
}
  static void entryPoint(SendPort sendPort) {
    Dio _postDio=_initPostDio();
    List<int> imageIdList = [];
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    receivePort.listen((message) {
      print("子isolate接收到main的消息了：$message");
      imageIdList.add(message as int);
      print(imageIdList.length);
    });
    // Timer.periodic(Duration(seconds: 5), (Timer t) {
    // // 每个5秒上传一次已打开图片的id
    //   print(imageIdList);
    // });
  }
  Dio _initPostDio() {
    Dio postDio = Dio(
      BaseOptions(
          connectTimeout: Duration(milliseconds: 150000),
          receiveTimeout: Duration(milliseconds: 150000),
          headers: {
            'Referer': 'https://pixivic.com',
          },
          responseType: ResponseType.bytes),
    );
    postDio.interceptors.add(
        InterceptorsWrapper(onRequest: (RequestOptions options, handler) async {
          //处理请求参数
          String? token = await UserService.queryToken();
          if (token != '') {
            options.headers['authorization'] = token;
          }
          handler.next(options);
        }, onResponse: (Response response, handler) async {
          return handler.next(response);
        }, onError: (DioError e, handler) async {
          return handler.next(e);
        }));
    return postDio;
  }
}
