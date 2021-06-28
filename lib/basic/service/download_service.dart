import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sharemoe/basic/constant/download_state.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/data/model/image_download_info.dart';

@singleton
class DownloadService {
  //三个下载列表
  late Box<ImageDownloadInfo> _downloading;
  late Box<ImageDownloadInfo> _completed;
  late Box<ImageDownloadInfo> _error;
  late Dio _downloadDio;
  late String _downloadPath;

  late Logger logger;

  @factoryMethod
  @preResolve
  static Future<DownloadService> create(Logger logger) async {
    DownloadService downloadService = new DownloadService();
    await downloadService._init(logger);
    return downloadService;
  }

  Future _init(Logger logger) async {
    logger.i("下载服务开始初始化");
    this.logger = logger;
    this._downloadPath = await _getDownloadPath();
    this._downloading = await Hive.openBox(DownloadState.Downloading);
    this._completed = await Hive.openBox(DownloadState.Completed);
    this._error = await Hive.openBox(DownloadState.Error);
    this._downloadDio = _initDownloadDio();
    logger.i("下载服务初始化完毕");
  }

  //下载，外部调用download方法 不需要加await
  Future<void> download(ImageDownloadInfo imageDownloadInfo) async {
    _addToDownloading(imageDownloadInfo).then((id) {
      imageDownloadInfo.id = id;
      return _downloadDio.get(imageDownloadInfo.imageUrl,
          onReceiveProgress: imageDownloadInfo.updateDownloadPercent);
    }).then((req) {
      //保存成临时文件
      String filename = imageDownloadInfo.imageUrl
          .substring(imageDownloadInfo.imageUrl.lastIndexOf("/") + 1);
      imageDownloadInfo.fileName = filename;
      File file = File("${_downloadPath}/${filename}");
      return file.writeAsBytes(Uint8List.fromList(req.data),
          mode: FileMode.append);
    }).then((file) {
      //临时文件存到相册
      return PhotoManager.editor
          .saveImageWithPath(file.path, title: imageDownloadInfo.fileName);
    }).whenComplete(() {
      //更新序列
      _deleteFromDownloading(imageDownloadInfo.id)
          .whenComplete(() => _addToCompleted(imageDownloadInfo));
    }).catchError((e) {
      logger.e(e);
      //更新序列
      _deleteFromDownloading(imageDownloadInfo.id);
      _addToError(imageDownloadInfo);
      return null;
    });
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

  Future<String> _getDownloadPath() async {
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
    return dir;
  }

  Future<int> _addToDownloading(ImageDownloadInfo imageDownloadInfo) async {
    logger.i(
        "画作id:${imageDownloadInfo.id}的第${imageDownloadInfo.pageCount}张图片添加到下载序列");
    return _downloading.add(imageDownloadInfo);
  }

  Future _deleteFromDownloading(int imageDownloadInfoId) async {
    await _downloading.delete(imageDownloadInfoId);
  }

  Future _addToCompleted(ImageDownloadInfo imageDownloadInfo) async {
    logger.i(
        "画作id:${imageDownloadInfo.id}的第${imageDownloadInfo.pageCount}张图片下载成功，已添加到完成序列");
    _completed.add(imageDownloadInfo);
  }

  Future _deleteFromCompleted(int imageDownloadInfoId) async {
    _completed.delete(imageDownloadInfoId);
  }

  Future _addToError(ImageDownloadInfo imageDownloadInfo) async {
    logger.e(
        "画作id:${imageDownloadInfo.id}的第${imageDownloadInfo.pageCount}张图片下载失败，已添加到失败序列");
    _error.add(imageDownloadInfo);
  }

  Future _deleteFromError(int imageDownloadInfoId) async {
    _error.delete(imageDownloadInfoId);
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
          if (token!= null) {
        options.headers['authorization'] = token;
      }
      handler.next(options);
    }, onError: (DioError e, handler) async {
      logger.i(e);
      return handler.next(e);
    }));
    return downloadDio;
  }
}
