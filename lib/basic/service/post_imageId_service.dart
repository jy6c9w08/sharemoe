import 'dart:async';
import 'dart:isolate';

import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@singleton
@preResolve
class PostImageIdService {
  ReceivePort receivePort = ReceivePort();
  late SendPort sendPort;
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
       sendPort = message;
     } else {
       print(message);
     }
   });
  }
 void sendId(int id){
  sendPort.send(id);
}
  static void entryPoint(SendPort sendPort) {
    List<int> imageIdList = [];
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    receivePort.listen((message) {
      print("子isolate接收到main的消息了：$message");
      imageIdList.add(message as int);
      print(imageIdList.length);
    });
    Timer.periodic(Duration(seconds: 5), (Timer t) {
    // 每个5秒上传一次已打开图片的id
      print(imageIdList);
    });
  }
}
