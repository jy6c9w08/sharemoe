// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/data/model/app_info.dart';

@singleton
@preResolve
class UpgradeService {
  late Logger logger;
  late Dio _upgradeDio;
  late UserService userService;
  String? _downloadPath;
  late Box<APPInfo> _versionBox;
  Rx<int> downloadPercent = Rx<int>(0);
  Rx<int> fileTotal = Rx<int>(0);

  @factoryMethod
  static Future<UpgradeService> create(
      Logger logger, UserService userService) async {
    UpgradeService upgradeService = new UpgradeService();
    upgradeService.logger = logger;
    upgradeService.userService = userService;
    await upgradeService._init();
    return upgradeService;
  }

  Future _init() async {
    logger.i("更新服务开始初始化");
    this.logger = logger;

    this._upgradeDio = _initDownloadDio();
    String data = await rootBundle.loadString('assets/version.json');
    APPInfo appInfo = APPInfo.fromJson(json.decode(data));
    _versionBox = await Hive.openBox('appInfo')
      ..put('appInfo', appInfo);
    logger.i("更新服务初始化完毕");
  }

  Future upgradeForAndroid() async {
    if (this._downloadPath == null)
      this._downloadPath = await _getDownloadPathForAndroid();

    return _upgradeDio
        .download(
            PicExternalLinkLink.APP_ANDROID_64, _getDownloadPathForAndroid(),
            onReceiveProgress: showDownloadProgress)
        .whenComplete(() {
      OpenFile.open(_downloadPath);
    }).catchError((e) {
      logger.e(e);
    });
  }

  Future upgradeForIOS() async {
    ///TODO launcher_url
  }

  Future<String> _getDownloadPathForAndroid() async {
    PermissionStatus status = await Permission.storage.status;
    if (status != PermissionStatus.granted) await Permission.storage.request();

    String dir;

    final Directory picDirFolder = Directory(
        '${Platform.pathSeparator}storage${Platform.pathSeparator}emulated${Platform.pathSeparator}0${Platform.pathSeparator}sharemoe/apk/sharemoe.apk');
    if (!await picDirFolder.exists()) {
      await picDirFolder.create(recursive: true);
    }
    dir = picDirFolder.path;
    return dir;
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + '%');
    }
  }

  APPInfo appInfo() {
    return _versionBox.get('appInfo')!;
  }

  Dio _initDownloadDio() {
    Dio downloadDio = Dio(
      BaseOptions(
          connectTimeout: 150000,
          receiveTimeout: 150000,
          headers: {
            'Referer': 'https://pixivic.com',
          },
          responseType: ResponseType.bytes),
    );
    downloadDio.interceptors.add(
        InterceptorsWrapper(onRequest: (RequestOptions options, handler) async {
      //处理请求参数
      String? token = await UserService.queryToken();
      if (token != '') {
        options.headers['authorization'] = token;
      }
      logger.i('${options.uri}');
      handler.next(options);
    }, onResponse: (Response response, handler) async {
      logger.i(response.headers['Content-Length']);
      return handler.next(response);
    }, onError: (DioError e, handler) async {
      logger.i(e);
      return handler.next(e);
    }));
    return downloadDio;
  }
}
