import 'package:flutter/material.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class DownloadPage extends StatelessWidget {
  DownloadPage({Key? key}) : super(key: key);
  final ScreenUtil screen = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.normal(title: '下载列表'),
      body: ListView(
        padding: EdgeInsets.all(screen.setHeight(5)),
        children: [
          Text("下载中"),
          SizedBox(
            height: 20,
          ),
          imageDownload(),
          imageDownload(),
          imageDownload()
        ],
      ),
    );
  }

  Widget imageDownload() {
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
              Text("文件名"),
              Row(
                children: [
                  Icon(
                    Icons.pause_circle_filled,
                    color: Colors.red,
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.cancel,
                    color: Colors.grey,
                  ),
                ],
              )
            ],
          ),
          StepProgressIndicator(
            totalSteps: 100,
            currentStep: 60,
            size: 15,
            padding: 0,
            selectedColor: Color(0xffF2C94C),
            unselectedColor: Colors.white,
            roundedEdges: Radius.circular(10),
          ),
        ],
      ),
    );
  }
}
