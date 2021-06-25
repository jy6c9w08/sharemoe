import 'dart:math';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:extended_image/extended_image.dart';
import 'package:sharemoe/basic/util/pic_url_util.dart';
import 'package:sharemoe/controller/collection/collection_selector_controller.dart';
import 'package:sharemoe/controller/global_controller.dart';

import 'package:sharemoe/controller/image_controller.dart';
import 'package:sharemoe/routes/app_pages.dart';

class ImageCell extends GetView<ImageController> {
  @override
  final String tag;
  final ScreenUtil screen = ScreenUtil();
  final Color _color = Color.fromARGB(
    255,
    Random.secure().nextInt(200),
    Random.secure().nextInt(200),
    Random.secure().nextInt(200),
  );

  ImageCell({Key? key, required this.tag}) : super(key: key);

  Widget dealImageState(ExtendedImageState state) {
    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        return Opacity(
          opacity: 0.3,
          child: Container(
            height: screen.screenWidth /
                2 /
                controller.illust.width.toDouble() *
                controller.illust.height.toDouble(),
            width: screen.screenWidth / 2,
            color: _color,
          ),
        );
      case LoadState.completed:
        controller.imageLoadAnimationController.forward();
        return FadeTransition(
          opacity: controller.imageLoadAnimationController,
          child: ExtendedRawImage(
            image: state.extendedImageInfo?.image,
          ),
        );
      case LoadState.failed:
        return Center(child: Text("加载失败"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX<ImageController>(
        tag: tag,
        builder: (_) {
          return ShaderMask(
            shaderCallback: (controller.isSelector.value)
                // 长按进入选择模式时，为选中的画作设置遮罩
                ? (bounds) => LinearGradient(
                        colors: [Colors.grey.shade600, Colors.grey.shade600])
                    .createShader(bounds)
                : (bounds) =>
                    LinearGradient(colors: [Colors.white, Colors.white])
                        .createShader(bounds),
            child: AnimatedContainer(
              alignment: Alignment.center,
              width: screen.screenWidth / 2,
              height: (screen.screenWidth / 2 - screen.setHeight(14)) /
                  controller.illust.width *
                  controller.illust.height,
              padding: controller.isSelector.value
                  ? EdgeInsets.all(screen.setWidth(2))
                  : EdgeInsets.all(0),
              duration: Duration(milliseconds: 350),
              decoration: BoxDecoration(
                  color: controller.isSelector.value
                      ? Colors.black26
                      : Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(15)))),
              child: Hero(
                tag: 'imageHero' + controller.illust.id.toString(),
                child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(12))),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onLongPress: () {
                          controller.isSelector.value =
                              !controller.isSelector.value;
                          controller.isSelector.value
                              ? Get.find<CollectionSelectorCollector>()
                                  .addIllustToCollectList(controller.illust)
                              : Get.find<CollectionSelectorCollector>()
                                  .removeIllustToSelectList(controller.illust);
                        },
                        onTap: () {
                          if (controller.isSelector.value) {
                            controller.isSelector.value =
                                !controller.isSelector.value;
                            Get.find<CollectionSelectorCollector>()
                                .removeIllustToSelectList(controller.illust);
                          } else if (Get.find<CollectionSelectorCollector>()
                                  .selectList
                                  .length !=
                              0) {
                            controller.isSelector.value =
                                !controller.isSelector.value;

                            Get.find<CollectionSelectorCollector>()
                                .addIllustToCollectList(controller.illust);
                          } else {
                            Get.toNamed(Routes.DETAIL,
                                arguments: controller.illust.id.toString(),
                                preventDuplicates: false);
                          }
                        },
                        child: ExtendedImage.network(
                          PicUrlUtil(url: controller.illust.imageUrls[0].medium)
                              .imageUrl,
                          cache: true,
                          headers: {'Referer': 'https://m.sharemoe.net/'},
                          loadStateChanged: dealImageState,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: ScreenUtil().setWidth(8),
                        right: ScreenUtil().setWidth(8),
                        child: GetX<GlobalController>(builder: (_) {
                          return _.isLogin.value
                              ? GetBuilder<ImageController>(
                                  tag: tag,
                                  id: 'mark',
                                  builder: (_) {
                                    return AnimatedBuilder(
                                      animation: controller.colorAnimation,
                                      builder: (context, child) =>
                                          GestureDetector(
                                        child: Icon(
                                          Icons.favorite,
                                          color: controller.colorAnimation.value,
                                          size: ScreenUtil().setWidth(32),
                                        ),
                                        onTap: () {
                                          controller.markIllust();
                                        },
                                      ),
                                    );
                                  })
                              : Container();
                        }),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
