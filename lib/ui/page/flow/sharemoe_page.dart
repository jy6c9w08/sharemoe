import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sharemoe/ui/widget/image_cell.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'package:sharemoe/controller/sharemoe_controller.dart';

class ShareMoePage extends StatefulWidget {
  @override
  _ShareMoePageState createState() => _ShareMoePageState();
}

class _ShareMoePageState extends State<ShareMoePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: GetX<ShareMoeController>(
              init: ShareMoeController(),
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

  @override
  bool get wantKeepAlive => true;
}
