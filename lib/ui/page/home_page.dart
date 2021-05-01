import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharemoe/controller/collection/collection_selector_controller.dart';
import 'package:sharemoe/controller/global_controller.dart';

import 'package:sharemoe/controller/home_controller.dart';
import 'package:sharemoe/ui/widget/nav_bar.dart';

class HomePage extends GetView<HomePageController> {
  final ScreenUtil screen = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return GetX<HomePageController>(builder: (_) {
      return Stack(
        children: [
          PageView.builder(
              physics: ClampingScrollPhysics(),
              controller: controller.pageController,
              itemCount: 4,
              onPageChanged: (index) {
                controller.pageIndex.value = index;
                if (Get.find<CollectionSelectorCollector>().selectList.length !=
                    0)
                  Get.find<CollectionSelectorCollector>().clearSelectList();
              },
              itemBuilder: (context, index) {
                return controller.getPageByIndex(index);
              }),
          AnimatedPositioned(
              bottom: _.pageIndex.value == 0
                  ? controller.navBarBottom.value
                  : screen.setHeight(25.0),
              left: controller.navBarLeft.value,
              right: controller.navBarRight.value,
              child: NavBar(),
              duration: Duration(milliseconds: 400))
        ],
      );
    });
  }
}
