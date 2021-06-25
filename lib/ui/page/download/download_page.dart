import 'package:flutter/material.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/basic/config/image_download.dart';
import 'package:sharemoe/data/model/image_download_info.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharemoe/ui/widget/state_box.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class DownloadPage extends StatelessWidget {
  DownloadPage({Key? key}) : super(key: key);
  final ScreenUtil screen = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    print(picBox.get('imageDownload'));
    return Scaffold(
        appBar: SappBar.normal(title: '下载列表'),
        body: imageDownloadList.isEmpty
            ? EmptyBox()
            : ListView.builder(
                itemBuilder: (context, index) {
                  return imageDownloadCell(index);
                },
                itemCount: imageDownloadList.length,
              ));
  }

  Widget imageDownloadCell(int index) {
    ImageDownloadController imageDownloadController =
        Get.find<ImageDownloadController>(
            tag: imageDownloadList[index].toString());
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
              Text(imageDownloadController.imageDownloadInfo.fileName),
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
                      imageDownloadController.imageDownloadInfo.delete();
                      imageDownloadList.removeAt(index);
                      picBox.put('imageDownload', imageDownloadList);
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
          StepProgressIndicator(
              totalSteps: 100,
              currentStep:
                  imageDownloadController.imageDownloadInfo.downloadState ==
                          DownloadState.completed
                      ? 100
                      : imageDownloadController.process.toInt(),
              size: 15,
              padding: 0,
              selectedColor: Color(0xffF2C94C),
              unselectedColor: Colors.white,
              roundedEdges: Radius.circular(4),
              fallbackLength: 50),
        ],
      ),
    );
  }
}
