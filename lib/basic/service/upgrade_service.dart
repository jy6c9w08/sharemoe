// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

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
    APPInfo appInfo = APPInfo.fromJson(json.decode(data));
    _versionBox = await Hive.openBox('appInfo')
      ..put('appInfo', appInfo);
    logger.i("更新服务初始化完毕");
  }

  upgrade() {
    if (GetPlatform.isIOS || GetPlatform.isMacOS)
      _upgradeForIOS();
    else
      _upgradeForAndroid('https://url.ipv4.host/app-android-64');
  }

  Future _upgradeForAndroid(String link) async {
    if (this._downloadPath == null)
      this._downloadPath = await _getDownloadPathForAndroid();
    downloading = true;
    return new Dio()
        .download(link, _downloadPath! + '/sharemoe.apk',
            onReceiveProgress: showDownloadProgress)
        .whenComplete(() {
      downloading = false;
      OpenFile.open(_downloadPath! + '/sharemoe.apk');
    }).catchError((e) {
      logger.e(e);
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
      downloadPercent.value =
          int.parse((received / total * 100).toStringAsFixed(0));
      print((received / total * 100).toStringAsFixed(0) + '%');
    }
  }

  APPInfo appInfo() {
    return _versionBox.get('appInfo')!;
  }
}