// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/download_state.dart';
import 'package:sharemoe/basic/service/download_service.dart';
import 'package:sharemoe/data/model/image_download_info.dart';
import 'package:sharemoe/data/repository/illust_repository.dart';
import 'package:sharemoe/routes/app_pages.dart';
import '../image_controller.dart';

class ImageDownLoadController extends GetxController {
  final completeList = Rx<List<ImageDownloadInfo>>([]);
  final errorList = Rx<List<ImageDownloadInfo>>([]);
  final downloadingList = Rx<List<ImageDownloadInfo>>([]);
  static final DownloadService downloadService = getIt<DownloadService>();

  jumpToDetail(int illustId) {
    getIt<IllustRepository>().querySearchIllustById(illustId).then((value) {
      Get.put<ImageController>(ImageController(illust: value),
          tag: value.id.toString());
      Get.toNamed(Routes.DETAIL, arguments: value.id.toString());
    });
  }

  clearCompleteList() {
    downloadService.clearDownloadList(DownloadState.Completed);
  }

  @override
  void onInit() {
    downloadService
        .queryDownloading()
        .values
        .toList()
        .forEach((imageDownloadInfo) {
      downloadService.deleteFromDownloading(imageDownloadInfo.id);
      downloadService.addToError(imageDownloadInfo);
    });
    completeList.value = downloadService.queryCompleted().values.toList();
    errorList.value = downloadService.queryError().values.toList();

    super.onInit();
  }
}
