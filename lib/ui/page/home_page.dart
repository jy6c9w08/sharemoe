import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharemoe/controller/home_controller.dart';

class HomePage extends GetView<HomePageController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(builder: (controller) {
      return Stack(
        children: [
          PageView.builder(
              // controller: _.pageController,
              itemCount: 4,
              // onPageChanged: (index) => _.pageIndex.value = index,
              itemBuilder: (context, index) {
                return GetX<HomePageController>(
                  builder: (_) {
                    return _.getPageByIndex(index);
                  },
                );
              }),
        ],
      );
    });
  }
}
