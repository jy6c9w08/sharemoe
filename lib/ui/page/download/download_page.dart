import 'package:flutter/material.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/download_service.dart';
import 'package:sharemoe/controller/image_down/image_download_controller.dart';
import 'package:sharemoe/data/model/image_download_info.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class DownloadPage extends GetView<ImageDownLoadController> {
  DownloadPage({Key? key}) : super(key: key);
  final ScreenUtil screen = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SappBar.normal(title: '下载列表'),
        body: GetX<ImageDownLoadController>(builder: (_) {
          return ListView(
            children: [
              ExpansionTile(
                title: Text('下载中'),
                initiallyExpanded: true,
                children: controller.downloadingList.value
                    .map((ImageDownloadInfo e) => imageDownloadCell(e))
                    .toList(),
              ),
              ExpansionTile(
                title: Text('下载完成'),
                children: controller.completeList.value
                    .map((ImageDownloadInfo e) => imageDownloadCell(e))
                    .toList(),
              ),
              ExpansionTile(
                title: Text('下载失败'),
                children: controller.errorList.value
                    .map((ImageDownloadInfo e) => imageDownloadCell(e))
                    .toList(),
              )
            ],
          );
        }));
  }

  Widget imageDownloadCell(ImageDownloadInfo imageDownloadInfo) {
    return Container(
      padding: EdgeInsets.all(10),
      height: screen.setHeight(67),
      decoration: BoxDecoration(
          color: Color(0xffF2F4F6),
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(15)))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(imageDownloadInfo.fileName),
              Row(
                children: [
                  Icon(
                    Icons.refresh,
                    color: Colors.red,
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      //清空保存
                      getIt<DownloadService>()
                          .deleteFromCompleted(imageDownloadInfo.id);
                    },
                    child: Icon(
                      Icons.cancel,
                      color: Colors.grey,
                    ),
                  ),
                ],
              )
            ],
          ),
          Obx(() {
            return StepProgressIndicator(
                totalSteps: 100,
                currentStep:
                    imageDownloadInfo.downloadPercent.value == 0
                        ? 100
                        : imageDownloadInfo.downloadPercent.value,
                /*   currentStep:
                  imageDownloadController.imageDownloadInfo.downloadState ==
                          DownloadState.completed
                      ? 100
                      : imageDownloadController.process.toInt(),*/
                size: 15,
                padding: 0,
                selectedColor: Color(0xffF2C94C),
                unselectedColor: Colors.white,
                roundedEdges: Radius.circular(4),
                fallbackLength: 50);
          }),
        ],
      ),
    );
  }
}
