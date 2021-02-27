import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'package:sharemoe/ui/widget/water_flow/image_cell.dart';
import 'package:sharemoe/ui/widget/loading_box.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';

class WaterFlow extends StatelessWidget {
  final String model;
  final String searchWords;

  WaterFlow({Key key, this.model, this.searchWords}) : super(key: key);

  WaterFlow.home({Key key, this.model = 'home', this.searchWords})
      : super(key: key);

  WaterFlow.search({Key key, this.model = 'search', this.searchWords})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: GetX<WaterFlowController>(
            init: Get.put<WaterFlowController>(
                WaterFlowController(
                    model: this.model, searchKeyword: searchWords),
                tag: model),
            builder: (_) {
              _ = Get.find<WaterFlowController>(tag: model);
              return _.illustList.value == null
                  ? LoadingBox()
                  : WaterfallFlow.builder(
                      controller: _.scrollController,
                      itemCount: _.illustList.value.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ImageCell(
                          inex: index,
                          imageId: _.illustList.value[index].id,
                          model: model,
                        );
                      },
                      gridDelegate:
                          SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 7,
                              mainAxisSpacing: 7,
                              viewportBuilder: (int firstIndex, int lastIndex) {
                                if (lastIndex ==
                                        _.illustList.value.length - 1 &&
                                    _.loadMore) {
                                  _.loadData();
                                }
                              }),
                    );
            }));
  }
}
