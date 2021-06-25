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
import 'package:sharemoe/basic/constant/download_state.dart';

import 'config/get_it_config.dart';
import 'config/hive_config.dart';



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
    await downloadService._init(logger);
    return downloadService;
  }

  Future _init(Logger logger) async {
    logger.i("下载服务开始初始化");
    this.logger = logger;
    this._downloading = await Hive.openBox(DownloadState.Downloading);
    this._completed = await Hive.openBox(DownloadState.Completed);
    this._error = await Hive.openBox(DownloadState.Error);
    logger.i("下载服务初始化完毕");
  }

  //下载，外部调用download方法 不需要加await
  Future<void> download(ImageDownloadInfo imageDownloadInfo) async {
    _addToDownloading(imageDownloadInfo);
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
      _deleteFromDownloading(imageDownloadInfo.id);
      _addToError(imageDownloadInfo);
      return null;
    });
    if (req != null) {
      File file = File(await _downloadPath(imageDownloadInfo));
      file.writeAsBytesSync(Uint8List.fromList(req.data),
          mode: FileMode.append);
      await PhotoManager.editor.saveImageWithPath(file.path).then((value) {
        _deleteFromDownloading(imageDownloadInfo.id);
        _addToCompleted(imageDownloadInfo);
      }).catchError((e) {
        _deleteFromDownloading(imageDownloadInfo.id);
        _addToError(imageDownloadInfo);
      });
    }
  }

  //重新下载
  void reDownload(ImageDownloadInfo imageDownloadInfo) {
    _deleteFromError(imageDownloadInfo.id);
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

  Future<String> _downloadPath(ImageDownloadInfo imageDownloadInfo) async {
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

  void _addToDownloading(ImageDownloadInfo imageDownloadInfo) async {
    logger.i(
        "画作id:${imageDownloadInfo.id}的第${imageDownloadInfo.pageCount}张图片添加到下载序列");
    imageDownloadInfo.id = await _downloading.add(imageDownloadInfo);
  }

  void _deleteFromDownloading(int imageDownloadInfoId) {
    _downloading.deleteAt(imageDownloadInfoId);
  }

  void _addToCompleted(ImageDownloadInfo imageDownloadInfo) {
    logger.i(
        "画作id:${imageDownloadInfo.id}的第${imageDownloadInfo.pageCount}张图片下载成功，已添加到已下载序列");
    _completed.add(imageDownloadInfo);
  }

  void _deleteFromCompleted(int imageDownloadInfoId) {
    _completed.deleteAt(imageDownloadInfoId);
  }

  void _addToError(ImageDownloadInfo imageDownloadInfo) {
    logger.i(
        "画作id:${imageDownloadInfo.id}的第${imageDownloadInfo.pageCount}张图片下载失败，已添加到失败序列");
    _error.add(imageDownloadInfo);
  }

  void _deleteFromError(int imageDownloadInfoId) {
    _error.deleteAt(imageDownloadInfoId);
  }
}

Dio _initDownloadDio() {
  Logger logger = getIt<Logger>();
  Dio downloadDio =
      Dio(BaseOptions(connectTimeout: 150000, receiveTimeout: 150000));
  downloadDio.interceptors.add(
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
  return downloadDio;
}
