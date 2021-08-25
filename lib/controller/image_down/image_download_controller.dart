// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/download_service.dart';
import 'package:sharemoe/data/model/image_download_info.dart';

class ImageDownLoadController extends GetxController {
  final completeList = Rx<List<ImageDownloadInfo>>([]);
  final errorList = Rx<List<ImageDownloadInfo>>([]);
  final downloadingList = Rx<List<ImageDownloadInfo>>([]);
  static final DownloadService downloadService = getIt<DownloadService>();

  @override
  void onInit() {
    completeList.value = downloadService.queryCompleted().values.toList();
    errorList.value = downloadService.queryError().values.toList();

    downloadService.queryDownloading().values.toList().forEach((imageDownloadInfo) {
      downloadService.deleteFromDownloading(imageDownloadInfo.id);
      downloadService.addToError(imageDownloadInfo);
    });
    super.onInit();
  }
}
