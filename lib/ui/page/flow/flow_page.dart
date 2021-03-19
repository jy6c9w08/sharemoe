import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sharemoe/ui/page/flow/image_cell.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:sharemoe/controller/flow_controller.dart';

class FlowPage extends StatefulWidget {
  @override
  _FlowPageState createState() => _FlowPageState();
}

class _FlowPageState extends State<FlowPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar:SappBar.home(),
      body: Container(
          color: Colors.white,
          child: GetX<FlowController>(
              init: FlowController(),
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
                                mainAxisSpacing: 7,
                                viewportBuilder:
                                    (int firstIndex, int lastIndex) {
                                  if (lastIndex ==
                                      controller.illustList.value.length - 1&&controller.loadMore) {
                                    controller.loadData();
                                  }
                                }),
                      );
              })),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
