import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:extended_image/extended_image.dart';
import 'package:random_color/random_color.dart';

import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/controller/image_controller.dart';

class ImageCell extends GetView<WaterFlowController> {
  final int imageId;
  final int inex;
  final String model;
  final ScreenUtil screen = ScreenUtil();
  final Color _color = RandomColor().randomColor();

  ImageCell({
    Key key,
    this.imageId,
    this.model,
    this.inex,
  }) : super(key: key);

  Widget dealImageState(ExtendedImageState state) {
    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        return Opacity(
          opacity: 0.3,
          child: Container(
            color: _color,
          ),
        );
      case LoadState.completed:
        return GetBuilder<ImageController>(
            init:
                Get.put<ImageController>(ImageController(), tag: imageId.toString()),
            builder: (_) {
              _ = Get.find<ImageController>(tag: imageId.toString());
              return FadeTransition(
                opacity: _.controller,
                child: ExtendedRawImage(
                  image: state.extendedImageInfo?.image,
                ),
              );
            });

        break;
      case LoadState.failed:
        return Center(child: Text("加载失败"));
        break;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    WaterFlowController waterFlowController =
        Get.find<WaterFlowController>(tag: model);
    return GetX<WaterFlowController>(builder: (_) {
      return ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenUtil().setWidth(15))),
        child: ExtendedImage.network(
          waterFlowController.illustList.value[inex].imageUrls[0].medium
              .replaceAll('https://i.pximg.net', 'https://acgpic.net'),
          cache: true,
          headers: {'Referer': 'https://m.sharemoe.net/'},
          width: screen.screenWidth / 2,
          height: screen.screenWidth /
              2 /
              waterFlowController.illustList.value[inex].width *
              waterFlowController.illustList.value[inex].height,
          loadStateChanged: dealImageState,
        ),
      );
    });
  }
}
