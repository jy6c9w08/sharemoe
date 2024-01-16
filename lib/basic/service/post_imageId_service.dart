import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/data/model/expose_illust.dart';

@singleton
@preResolve
class PostImageIdService {
  late UserService userService;
  ReceivePort receivePort = ReceivePort();
  late SendPort _sendPort;

  PostImageIdService(UserService userService) {
    this.userService = userService;
  }

  @factoryMethod
  static Future<PostImageIdService> create(
      Logger logger, UserService userService) async {
    logger.i("上传图片id服务初始化");
    PostImageIdService postImageIdService = PostImageIdService(userService);
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

  Future<void> sendId(int illustId) async {
    String? token = userService.queryTokenByMem();
    _sendPort
        .send([illustId, DateTime.now().millisecondsSinceEpoch ~/ 1000, token]);
  }

  static void entryPoint(SendPort sendPort) {
    Dio postDio = _initPostDio();
    List<ExposeIllust> ExposeIllustList = [];
    Set<int> added={};
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    receivePort.listen((message) {
      //postDio.
      int illustId = message[0] as int;
      int createTime = message[1] as int;
      String? token = message[2] as String?;
      //print("子isolate接收到main的消息了：$message");
      print(illustId);
      if(token != null){
        if(!added.contains(illustId)){
          ExposeIllustList.add(new ExposeIllust(illustId: illustId, createTime: createTime));
          added.add(illustId);
        }
        if (ExposeIllustList.length >= 60) {
          //post
          log(ExposeIllustList.toString());
          ExposeIllustList.clear();
          added.clear();
        }
      }



    });
    // Timer.periodic(Duration(seconds: 5), (Timer t) {
    // // 每个5秒上传一次已打开图片的id
    //   print(imageIdList);
    // });
  }

  static Dio _initPostDio() {
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
      handler.next(options);
    }, onResponse: (Response response, handler) async {
      return handler.next(response);
    }, onError: (DioError e, handler) async {
      return handler.next(e);
    }));
    return postDio;
  }
}
