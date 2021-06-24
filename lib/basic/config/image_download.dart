import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/basic/config/http_client_config.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageDownloadController extends GetxController {
  final String url;
  late int process;

  ImageDownloadController({required this.url});

  @override
  void onInit() {
    _checkPermission().then((value) {
      if (value) {
        downloadPath().then((value) {
          requestDownload();
        });
      } else
        print(value);
    });

    super.onInit();
  }

  void requestDownload() async {
    final req = await dioPixivic.get(
      url,
      onReceiveProgress: showDownloadProgress,
      options: Options(headers: {
        'authorization': PicBox().auth,
        'Referer': 'https://m.sharemoe.net/'
      }, responseType: ResponseType.bytes),
    );
    File file = File(await downloadPath());
    file.writeAsBytesSync(Uint8List.fromList(req.data), mode: FileMode.append);
    await PhotoManager.editor.saveImageWithPath(file.path);
    print("结束");
  }

  Future<String> downloadPath() async {
    final name = DateTime.now().microsecondsSinceEpoch ~/
        Duration.microsecondsPerMillisecond;

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

    return "$dir/$name.jpg";
  }

  Future<bool> _checkPermission() async {
    if (GetPlatform.isIOS) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      process = received / total * 100;
      print((received / total * 100).toStringAsFixed(0) + '%');
      print(received / total * 100);
    }
  }
}
