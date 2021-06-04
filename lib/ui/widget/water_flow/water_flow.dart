import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharemoe/controller/image_controller.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'package:sharemoe/controller/water_flow_controller.dart';

import '../state_box.dart';
import 'image_cell.dart';

class WaterFlow extends GetView<WaterFlowController> {
  @override
  final String tag;
  final Widget? topWidget;
  final ScreenUtil screen = ScreenUtil();

  WaterFlow({
    Key? key,
    required this.tag,
    this.topWidget,
  }) : super(key: key);

  // WaterFlow.home({Key? key, this.tag = 'home', this.topWidget})
  //     : super(key: key);
  //
  // WaterFlow.search({Key? key, this.tag = 'search', this.topWidget})
  //     : super(key: key);
  //
  // WaterFlow.related({Key? key, required this.tag, this.topWidget})
  //     : super(key: key);
  //
  // WaterFlow.bookmark({Key? key, required this.tag, this.topWidget})
  //     : super(key: key);
  //
  // WaterFlow.artist({Key? key, required this.tag, this.topWidget})
  //     : super(key: key);
  //
  // WaterFlow.history({Key? key, this.tag = 'history', this.topWidget})
  //     : super(key: key);
  //
  // WaterFlow.oldHistory({Key? key, this.tag = 'oldHistory', this.topWidget})
  //     : super(key: key);
  //
  // WaterFlow.update({Key? key, required this.tag, this.topWidget})
  //     : super(key: key);
  //
  // WaterFlow.collection({Key? key, this.tag = 'collection', this.topWidget})
  //     : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.white,
        child: GetX<WaterFlowController>(
            autoRemove: false,
            tag: tag,
            builder: (_) {
              return controller.illustList.value.length == 0
                  ? SliverToBoxAdapter(child: LoadingBox())
                  : controller.illustList.value.isEmpty
                      ? SliverToBoxAdapter(
                          child: EmptyBox(),
                        )
                      : SliverWaterfallFlow(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            Get.put<ImageController>(
                                ImageController(
                                    illust: controller.illustList.value[index]),
                                tag: controller.illustList.value[index].id
                                    .toString());
                            return ImageCell(
                              tag: controller.illustList.value[index].id
                                  .toString(),
                            );
                          }, childCount: controller.illustList.value.length),
                          gridDelegate:
                              SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 7,
                                  mainAxisSpacing: 7,
                                  viewportBuilder:
                                      (int firstIndex, int lastIndex) {
                                    if (lastIndex ==
                                            controller.illustList.value.length -
                                                1 &&
                                        controller.loadMore) {
                                      controller.loadData();
                                    }
                                  }),
                        );
            }));
  }
}
