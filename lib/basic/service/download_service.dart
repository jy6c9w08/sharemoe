// Dart imports:
import 'dart:io';
import 'dart:typed_data';

// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:get/get.dart' hide Response;
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

// Project imports:
import 'package:sharemoe/basic/constant/ImageUrlLevel.dart';
import 'package:sharemoe/basic/constant/download_state.dart';
import 'package:sharemoe/basic/constant/event_type.dart';
import 'package:sharemoe/basic/domain/event.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/basic/util/pic_url_util.dart';
import 'package:sharemoe/controller/image_down/image_download_controller.dart';
import 'package:sharemoe/data/model/image_download_info.dart';

@singleton
@preResolve
class DownloadService {
  //三个下载列表
  late Box<ImageDownloadInfo> _downloading;
  late Box<ImageDownloadInfo> _completed;
  late Box<ImageDownloadInfo> _error;
  late Dio _downloadDio;
  String? _downloadPath;
  late PicUrlUtil picUrlUtil;
  late EventBus eventBus;
  late UserService userService;
  late Logger logger;

  @factoryMethod
  static Future<DownloadService> create(Logger logger, PicUrlUtil picUrlUtil,
      EventBus eventBus, UserService userService) async {
    DownloadService downloadService = new DownloadService();
    downloadService.picUrlUtil = picUrlUtil;
    downloadService.eventBus = eventBus;
    downloadService.logger = logger;
    downloadService.userService = userService;
    await downloadService._init();
    downloadService.registerToBus();
    return downloadService;
  }

  void registerToBus() {
    eventBus.on<Event>().listen((event) async {
      switch (event.eventType) {
        case EventType.signOut:
          break;
        case EventType.signIn:
          await _init();
          break;
        case EventType.signOutByExpire:
          break;
      }
    });
  }

  Future _init() async {
    logger.i("下载服务开始初始化");
    int userid = userService.isLogin() ? userService.userInfo()!.id : 0;
    logger.i(userid);
    this.logger = logger;
    this._downloading =
        await Hive.openBox(DownloadState.Downloading + userid.toString());
    this._completed =
        await Hive.openBox(DownloadState.Completed + userid.toString());
    this._error = await Hive.openBox(DownloadState.Error + userid.toString());
    this._downloadDio = _initDownloadDio();
    logger.i("下载服务初始化完毕");
  }

//适用于version小于29以及iphone
  Future<String> downloadForAndroidOrIOS(ImageDownloadInfo imageDownloadInfo, var req) async {
    File file = File("$_downloadPath/${imageDownloadInfo.fileName}");
      await file
        .writeAsBytes(Uint8List.fromList(req.data), mode: FileMode.append);
   await PhotoManager.editor
        .saveImageWithPath(file.path, title: imageDownloadInfo.fileName);
   return file.path;
  }

  //下载，外部调用download方法 不需要加await
  Future<void> download(ImageDownloadInfo imageDownloadInfo) async {
    if (this._downloadPath == null) {
      this._downloadPath = await _getDownloadPath();
    }
    _addToDownloading(imageDownloadInfo).then((id) {
      imageDownloadInfo.id = id;
      //保存添加到下载队列的id 否则id默认为0
      imageDownloadInfo.save();
      Get.find<ImageDownLoadController>().downloadingList.value =
          _downloading.values.toList();
      return _downloadDio.get(
          picUrlUtil.dealUrl(
              imageDownloadInfo.imageUrl, ImageUrlLevel.original),
          onReceiveProgress: imageDownloadInfo.updateDownloadPercent);
    }).then((req) async {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      if (GetPlatform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

        if (androidInfo.version.sdkInt >= 29) {
          imageDownloadInfo.filePath =
              "$_downloadPath/${imageDownloadInfo.fileName}";
          return PhotoManager.editor.saveImage(Uint8List.fromList(req.data),
              title: imageDownloadInfo.fileName,
              relativePath: 'Pictures/sharemoe');
        } else
        imageDownloadInfo.filePath= await downloadForAndroidOrIOS(imageDownloadInfo, req);
      } else
        imageDownloadInfo.filePath= await  downloadForAndroidOrIOS(imageDownloadInfo, req);
    }).then((value) async {
      //更新序列
      imageDownloadInfo.save();
      await deleteFromDownloading(imageDownloadInfo.id);
      _addToCompleted(imageDownloadInfo);
    }).catchError((e) {
      logger.e(e);
      //更新序列
      deleteFromDownloading(imageDownloadInfo.id);
      addToError(imageDownloadInfo);
      return null;
    });
  }

  //重新下载
  void reDownload(ImageDownloadInfo imageDownloadInfo) {
    deleteFromError(imageDownloadInfo.id);
    download(imageDownloadInfo);
  }

  //按照类型清空下载列表
  void clearDownloadList(String type) {
    switch (type) {
      case DownloadState.Downloading:
        _downloading.clear();
        break;
      case DownloadState.Completed:
        _completed.clear();
        Get.find<ImageDownLoadController>().completeList.value=[];
        break;
      case DownloadState.Error:
        _error.clear();
        break;
    }
  }

//查询正在下载列表
  Box<ImageDownloadInfo> queryDownloading() {
    return _downloading;
  }

//查询完成列表
  Box<ImageDownloadInfo> queryCompleted() {
    return _completed;
  }

//查询下载失败列表
  Box<ImageDownloadInfo> queryError() {
    return _error;
  }

  Future<String> _getDownloadPath() async {
    PermissionStatus status = await Permission.storage.status;
    if (status != PermissionStatus.granted) await Permission.storage.request();
    PermissionStatus externalStorageStatus =
        await Permission.manageExternalStorage.status;
    if (externalStorageStatus != PermissionStatus.granted)
      await Permission.manageExternalStorage.request();
    String dir;
    if (GetPlatform.isIOS || GetPlatform.isMacOS) {
      dir = (await getApplicationSupportDirectory()).absolute.path;
    } else if (GetPlatform.isAndroid) {
      final Directory picDirFolder = Directory(
          '${Platform.pathSeparator}storage${Platform.pathSeparator}emulated${Platform.pathSeparator}0${Platform.pathSeparator}Pictures/sharemoe');
      if (!await picDirFolder.exists()) {
        await picDirFolder.create(recursive: true);
      }
      dir = picDirFolder.absolute.path;
    } else {
      dir = (await getDownloadsDirectory())!.absolute.path;
    }
    return dir;
  }

  Future<int> _addToDownloading(ImageDownloadInfo imageDownloadInfo) async {
    logger.i(
        "画作id:${imageDownloadInfo.illustId}的第${imageDownloadInfo.pageCount}张图片添加到下载序列");
      Get.find<ImageDownLoadController>().downloadingList.value =
          _downloading.values.toList();
    return _downloading.add(imageDownloadInfo);
  }

  Future deleteFromDownloading(int imageDownloadInfoId) async {
    await _downloading.delete(imageDownloadInfoId);
      Get.find<ImageDownLoadController>().downloadingList.value =
          _downloading.values.toList();
  }

  Future _addToCompleted(ImageDownloadInfo imageDownloadInfo) async {
    logger.i(
        "画作id:${imageDownloadInfo.id}的第${imageDownloadInfo.pageCount}张图片下载成功，已添加到完成序列");
    imageDownloadInfo.id = await _completed.add(imageDownloadInfo);
    imageDownloadInfo.save();
      Get.find<ImageDownLoadController>().completeList.value =
          _completed.values.toList();
  }

  Future deleteFromCompleted(int imageDownloadInfoId) async {
    _completed.delete(imageDownloadInfoId);
    Get.find<ImageDownLoadController>().completeList.value =
        _completed.values.toList();
  }

  Future addToError(ImageDownloadInfo imageDownloadInfo) async {
    logger.e(
        "画作id:${imageDownloadInfo.id}的第${imageDownloadInfo.pageCount}张图片下载失败，已添加到失败序列");
    imageDownloadInfo.id = await _error.add(imageDownloadInfo);
    imageDownloadInfo.save();
      Get.find<ImageDownLoadController>().errorList.value =
          _error.values.toList();
  }

  Future deleteFromError(int imageDownloadInfoId) async {
    print(_error.values);
    _error.delete(imageDownloadInfoId);
    Get.find<ImageDownLoadController>().errorList.value =
        _error.values.toList();
  }

  Dio _initDownloadDio() {
    Dio downloadDio = Dio(
      BaseOptions(
          connectTimeout: Duration(milliseconds: 150000),
          receiveTimeout: Duration(milliseconds: 150000),
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
    }, onError: (DioException e, handler) async {
      logger.i(e);
      return handler.next(e);
    }));
    return downloadDio;
  }
}
