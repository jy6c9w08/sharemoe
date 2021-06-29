import 'package:get/get.dart';
import 'package:sharemoe/controller/image_down/image_download_controller.dart';

class DownloadBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ImageDownLoadController());
  }
}
