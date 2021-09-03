// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/controller/collection/collection_selector_controller.dart';
import 'package:sharemoe/controller/home_controller.dart';
import 'package:sharemoe/ui/widget/nav_bar.dart';

class HomePage extends GetView<HomePageController> {
  final ScreenUtil screen = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return GetX<HomePageController>(builder: (_) {
      return Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
              physics: ClampingScrollPhysics(),
              controller: controller.pageController,
              itemCount: 5,
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
              bottom: _.pageIndex.value == 0 || _.pageIndex.value == 1
                  ? controller.navBarBottom.value
                  : screen.setHeight(25.0),
              child: NavBar(),
              duration: Duration(milliseconds: 400))
        ],
      );
    });
  }
}
