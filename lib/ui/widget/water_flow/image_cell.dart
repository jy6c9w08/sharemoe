import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:extended_image/extended_image.dart';
import 'package:random_color/random_color.dart';

import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/controller/image_controller.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/page/pic_detail/pic_detail_page.dart';

class ImageCell extends GetView<WaterFlowController> {
  final int imageId;
  final int index;
  final String model;
  final relatedId;
  final ScreenUtil screen = ScreenUtil();
  final Color _color = RandomColor().randomColor();

  ImageCell({
    Key key,
    this.imageId,
    this.model,
    this.index,
    this.relatedId,
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
            init: Get.put<ImageController>(ImageController(),
                tag: imageId.toString()),
            tag: imageId.toString(),
            builder: (_) {
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
    return GetX<WaterFlowController>(
        tag: model == 'related' ? model + relatedId.toString() : model,
        builder: (_) {
          return Hero(
            tag: 'imageHero' + _.illustList.value[index].imageUrls[0].medium,
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius:
                  BorderRadius.all(Radius.circular(ScreenUtil().setWidth(15))),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(
                    Routes.DETAIL,
                    arguments: _.illustList.value[index],
                    preventDuplicates: false,
                  );
                },
                child: ExtendedImage.network(
                  _.illustList.value[index].imageUrls[0].medium
                      .replaceAll('https://i.pximg.net', 'https://acgpic.net'),
                  cache: true,
                  headers: {'Referer': 'https://m.sharemoe.net/'},
                  width: screen.screenWidth / 2,
                  height: screen.screenWidth /
                      2 /
                      _.illustList.value[index].width *
                      _.illustList.value[index].height,
                  loadStateChanged: dealImageState,
                ),
              ),
            ),
          );
        });
  }
}