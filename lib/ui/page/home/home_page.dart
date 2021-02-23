import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sharemoe/ui/widget/image_cell.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'package:sharemoe/controller/home_controller.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: GetX<HomeController>(
              init: HomeController(),
              builder: (controller) {
                return controller.illustList.value == null
                    ? Text('loading')
                    : WaterfallFlow.builder(
                        controller: controller.scrollController,
                        itemCount: controller.illustList.value.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ImageCell(
                            imageId: index,
                          );
                        },
                        gridDelegate:
                            SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 7,
                                mainAxisSpacing: 7),
                      );
              })),
    );
  }
}
