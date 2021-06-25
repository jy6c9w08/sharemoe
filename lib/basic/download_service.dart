import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/data/model/image_download_info.dart';

import 'config/get_it_config.dart';
import 'config/hive_config.dart';

class DownloadState {
//下载中
  static const String Downloading = 'downloading';

//下载完成
  static const String Completed = 'completed';

//下载失败
  static const String Error = 'error';
}

@lazySingleton
class DownloadService {
  //三个下载列表
  late Box<ImageDownloadInfo> _downloading;
  late Box<ImageDownloadInfo> _completed;
  late Box<ImageDownloadInfo> _error;
  final Dio _downloadDio = _initDownloadDio();
  late Logger logger;

  @factoryMethod
  static Future<DownloadService> create(Logger logger) async {
    DownloadService downloadService = new DownloadService();
    await downloadService.init(logger);
    return downloadService;
  }

  DownloadService() {}

  Future init(Logger logger) async {
    this.logger = logger;
    this._downloading = await Hive.openBox(DownloadState.Downloading);
    this._completed = await Hive.openBox(DownloadState.Completed);
    this._error = await Hive.openBox(DownloadState.Error);
  }


  Future<void> download(ImageDownloadInfo imageDownloadInfo) async {
    addToDownloading(imageDownloadInfo);
    final req = await _downloadDio
        .get(
      imageDownloadInfo.imageUrl,
      onReceiveProgress: imageDownloadInfo.updateDownloadPercent,
      options: Options(headers: {
        'authorization': AuthBox().auth,
        'Referer': 'https://m.sharemoe.net/'
      }, responseType: ResponseType.bytes),
    )
        .catchError((e) {
      deleteFromDownloading(imageDownloadInfo.id);
      addToError(imageDownloadInfo);
      return null;
    });
    if (req != null) {
      File file = File(await downloadPath(imageDownloadInfo));
      file.writeAsBytesSync(Uint8List.fromList(req.data),
          mode: FileMode.append);
      await PhotoManager.editor.saveImageWithPath(file.path).then((value) {
        deleteFromDownloading(imageDownloadInfo.id);
        addToCompleted(imageDownloadInfo);
      }).catchError((e) {
        deleteFromDownloading(imageDownloadInfo.id);
        addToError(imageDownloadInfo);
      });
    }
  }

  Future<String> downloadPath(ImageDownloadInfo imageDownloadInfo) async {
    String dir;
    if (GetPlatform.isIOS || GetPlatform.isMacOS) {
      dir = (await getApplicationSupportDirectory()).absolute.path;
    } else if (GetPlatform.isAndroid) {
      dir = (await getExternalStorageDirectories(
        type: StorageDirectory.downloads,
      ))![0]
          .absolute
          .path;
    } else {
      dir = (await getDownloadsDirectory())!.absolute.path;
    }
    return "$dir/${imageDownloadInfo.fileName}.jpg";
  }

  Box<ImageDownloadInfo> queryDownloading() {
    return _downloading;
  }

  void addToDownloading(ImageDownloadInfo imageDownloadInfo) async {
    logger.i(
        "画作id:${imageDownloadInfo.id}的第${imageDownloadInfo.pageCount}张图片添加到下载序列");
    imageDownloadInfo.id = await _downloading.add(imageDownloadInfo);
  }

  void deleteFromDownloading(int imageDownloadInfoId) {
    _downloading.deleteAt(imageDownloadInfoId);
  }

  Box<ImageDownloadInfo> queryCompleted() {
    return _completed;
  }

  void addToCompleted(ImageDownloadInfo imageDownloadInfo) {
    logger.i(
        "画作id:${imageDownloadInfo.id}的第${imageDownloadInfo.pageCount}张图片下载成功，已添加到已下载序列");
    _completed.add(imageDownloadInfo);
  }

  void deleteFromCompleted(int imageDownloadInfoId) {
    _completed.deleteAt(imageDownloadInfoId);
  }

  Box<ImageDownloadInfo> queryError() {
    return _error;
  }

  void addToError(ImageDownloadInfo imageDownloadInfo) {
    logger.i(
        "画作id:${imageDownloadInfo.id}的第${imageDownloadInfo.pageCount}张图片下载失败，已添加到失败序列");
    _error.add(imageDownloadInfo);
  }

  void deleteFromError(int imageDownloadInfoId) {
    _error.deleteAt(imageDownloadInfoId);
  }
}

Dio _initDownloadDio() {
  Logger logger = getIt<Logger>();
  Dio dioPixivic =
      Dio(BaseOptions(connectTimeout: 150000, receiveTimeout: 150000));
  dioPixivic.interceptors.add(
      InterceptorsWrapper(onRequest: (RequestOptions options, handler) async {
    //TODO 如果有token将token添加到url参数中
    logger.i(options.uri);
    logger.i(options.headers);
    handler.next(options);
  }, onError: (DioError e, handler) async {
    logger.i('==== DioPixivic Catch ====');
    logger.i(e.response!.statusCode);
    logger.i(e.response!.data);
    logger.i(e.response!.headers);
    return handler.next(e);
  }));
  logger.i("Dio初始化完毕");
  return dioPixivic;
}
