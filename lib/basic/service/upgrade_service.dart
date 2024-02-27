// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:app_installer/app_installer.dart';
import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/data/model/app_info.dart';

@singleton
@preResolve
class UpgradeService {
  late Logger logger;
  late UserService userService;
  String? _downloadPath;
  late Box<APPInfo> _versionBox;
  Rx<int> downloadPercent = Rx<int>(0);
  Rx<int> fileTotal = Rx<int>(0);
  late bool downloading = false;
  late CancelToken token;

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
    String data = await rootBundle.loadString('assets/version.json');
    //fromJson 前先加入 version 内容
    // var dataJson = json.decode(data);
    // dataJson['version'] = packageInfo.version;
    APPInfo appInfo = APPInfo.fromJson(json.decode(data));
    _versionBox = await Hive.openBox('appInfo')
      ..put('appInfo', appInfo);
    logger.i("更新服务初始化完毕");
  }

  upgrade(String link) {
    if (GetPlatform.isIOS || GetPlatform.isMacOS)
      _upgradeForIOS();
    else
      _upgradeForAndroid(link);
  }

  Future _upgradeForAndroid(String link) async {
    if (this._downloadPath == null)
      this._downloadPath = await _getDownloadPathForAndroid();
    downloading = true;
    return new Dio()
        .download(link, _downloadPath! + '/ShareMoe.apk',
            onReceiveProgress: showDownloadProgress,
            cancelToken: token = CancelToken())
        .whenComplete(() {
      downloading = false;
      AppInstaller.installApk(_downloadPath! + '/ShareMoe.apk');
      // OpenFile.open(_downloadPath! + '/sharemoe.apk');
    }).catchError((e) {
      downloading = false;
      logger.e(e);
      return e;
    });
  }

  Future _upgradeForIOS() async {
    ///TODO launcher_url

    // PermissionStatus status = await Permission.storage.status;
    // if (status != PermissionStatus.granted) await Permission.storage.request();
    // String  dir = (await getApplicationSupportDirectory()).absolute.path;
    // downloading=true;
    // return new Dio()
    //     .download(link, dir+'/sharemoe.apk',
    //     onReceiveProgress: showDownloadProgress)
    //     .whenComplete(() {
    //   downloading=false;
    //   OpenFile.open(dir+'/sharemoe.apk');
    // }).catchError((e) {
    //   logger.e(e);
    // });
  }

  Future<String> _getDownloadPathForAndroid() async {
    // 赋予 storage(写入) 以及 ExternalStorage(创建目录) 两种权限后，
    // 才能创建文件夹以及写入文件

    PermissionStatus status = await Permission.storage.status;
    if (status != PermissionStatus.granted) await Permission.storage.request();
    PermissionStatus externalStorageStatus =
        await Permission.manageExternalStorage.status;
    if (externalStorageStatus != PermissionStatus.granted)
      await Permission.manageExternalStorage.request();

    String dir;

    final Directory picDirFolder = Directory(
        '${Platform.pathSeparator}storage${Platform.pathSeparator}emulated${Platform.pathSeparator}0${Platform.pathSeparator}Download');
    if (!await picDirFolder.exists()) {
      await picDirFolder.create(recursive: true);
    }
    dir = picDirFolder.path;
    return dir;
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      downloadPercent.value =
          int.parse((received / total * 100).toStringAsFixed(0));
      print((received / total * 100).toStringAsFixed(0) + '%');
    }
  }

  APPInfo appInfo() {
    return _versionBox.get('appInfo')!;
  }
}
