import 'package:get/get.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/basic/config/image_download.dart';

class DownloadBinding implements Bindings {
  @override
  void dependencies() {
    for (int index = 0; index < imageDownloadList.length; index++) {
      if (!Get.isRegistered<ImageDownloadController>(
          tag: imageDownloadList[index].toString()))
        Get.put<ImageDownloadController>(
            ImageDownloadController(tag: imageDownloadList[index].toString()),
            tag: imageDownloadList[index].toString());
    }
  }
}
