// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/download_service.dart';
import 'package:sharemoe/controller/image_down/image_download_controller.dart';
import 'package:sharemoe/data/model/image_download_info.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class DownloadPage extends GetView<ImageDownLoadController> {
  DownloadPage({Key? key}) : super(key: key);
  final ScreenUtil screen = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SappBar.normal(title: '下载列表'),
        body: GetX<ImageDownLoadController>(
            // init: ImageDownLoadController(),
            builder: (_) {
              return ListView(
                children: [
                  ExpansionTile(
                    title: Text('下载中'),
                    initiallyExpanded: true,
                    children: controller.downloadingList.value
                        .map((ImageDownloadInfo e) =>
                            imageDownloadCell(e, 'downloading'))
                        .toList(),
                  ),
                  ExpansionTile(
                    title: Text('下载完成'),
                    children: controller.completeList.value
                        .map((ImageDownloadInfo e) =>
                            imageDownloadCell(e, 'complete'))
                        .toList(),
                  ),
                  ExpansionTile(
                    title: Text('下载失败'),
                    children: controller.errorList.value
                        .map((ImageDownloadInfo e) =>
                            imageDownloadCell(e, 'error'))
                        .toList(),
                  )
                ],
              );
            }));
  }

  Widget imageDownloadCell(ImageDownloadInfo imageDownloadInfo, String model) {
    return ListTile(
      title: Text(imageDownloadInfo.fileName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.refresh,
            color: Colors.red,
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              //清空保存
              if (model == 'error')
                getIt<DownloadService>().deleteFromError(imageDownloadInfo.id);
              else
                getIt<DownloadService>()
                    .deleteFromCompleted(imageDownloadInfo.id);
            },
            child: Icon(
              Icons.cancel,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      subtitle: model == 'complete'
          ? SizedBox()
          : Obx(() {
              return Text(
                  '${(imageDownloadInfo.downloadPercent.value / 100000000).toStringAsFixed(2)}M / ${(imageDownloadInfo.fileTotal.value == null ? '--M' : (imageDownloadInfo.fileTotal.value! / 1000000).toStringAsFixed(2) + 'M')}');
            }),
    );
  }
}
