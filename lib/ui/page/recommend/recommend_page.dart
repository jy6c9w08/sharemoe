import 'package:flutter/material.dart';
import 'package:sharemoe/controller/global_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/ui/page/needlogin/needlogin.dart';
import 'package:sharemoe/ui/page/pic/pic_page.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RecommendPage extends StatelessWidget {
  const RecommendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SappBar.normal(title: '猜你喜欢'),
        body: GetX<GlobalController>(builder: (_) {
          return _.isLogin.value ? PicPage.recommend() : NeedLoginPage();
        }),
        floatingActionButton: GetX<GlobalController>(builder: (_) {
          return _.isLogin.value
              ? FloatingActionButton(
                  onPressed: () {
                    Get.find<WaterFlowController>(tag: 'recommend')
                        .refreshIllustList();
                  },
                  child: Icon(Icons.refresh),
                  backgroundColor: Colors.orange[400],
                )
              : Container();
        }),
        floatingActionButtonLocation: CustomFloatingActionButtonLocation(
            FloatingActionButtonLocation.endFloat, 0, -60.h));
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX;
  double offsetY;

  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
