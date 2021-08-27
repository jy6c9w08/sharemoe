// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/ImageUrlLevel.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/basic/util/pic_url_util.dart';
import 'package:sharemoe/controller/collection/collection_selector_controller.dart';
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

  Widget? dealImageState(ExtendedImageState state) {
    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        if (!controller.imageLoadAnimationController.isCompleted)
          controller.imageLoadAnimationController.reset();
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
        if (controller.isAlready) return null;
        controller.isAlready = true;
        if (!controller.imageLoadAnimationController.isCompleted)
          controller.imageLoadAnimationController.forward();
        return FadeTransition(
          opacity: controller.imageLoadAnimationController,
          child: ExtendedRawImage(
            fit: BoxFit.fitHeight,
            image: state.extendedImageInfo?.image,
          ),
        );
      //TODO 剔除无法显示的图片
      case LoadState.failed:
        return Center(child: Text("加载失败，图片已被删除"));
    }
  }

  Widget numberViewer(int numberOfPic) {
    return (numberOfPic != 1)
        ? Container(
            padding: EdgeInsets.all(ScreenUtil().setWidth(2)),
            decoration: BoxDecoration(
                color: Colors.black38, borderRadius: BorderRadius.circular(3)),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.content_copy,
                  color: Colors.white,
                  size: ScreenUtil().setWidth(10),
                ),
                Text(
                  '$numberOfPic',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setHeight(10),
                      decoration: TextDecoration.none),
                ),
              ],
            ),
          )
        : Container();
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
              duration: Duration(milliseconds: 350),
              decoration: BoxDecoration(
                  border: controller.isSelector.value
                      ? Border.all(
                          width: ScreenUtil().setWidth(3),
                          color: Colors.black38)
                      : Border.all(width: 0.0, color: Colors.white),
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(15)))),
              child: Hero(
                tag: controller.illust.imageUrls[0].medium,
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
                          getIt<PicUrlUtil>().dealUrl(
                              controller.illust.imageUrls[0].medium,
                              ImageUrlLevel.medium),
                          cache: true,
                          height: controller.illust.height *
                              ((0.5.sw - 9.w) / controller.illust.width),
                          width: 0.5.sw - 9.w,
                          headers: {'Referer': 'https://m.sharemoe.net/'},
                          loadStateChanged: dealImageState,
                          fit: BoxFit.fitHeight,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        )),
                    Positioned(
                      child: numberViewer(controller.illust.pageCount),
                      right: ScreenUtil().setWidth(10),
                      top: ScreenUtil().setHeight(5),
                    ),
                    Positioned(
                      bottom: ScreenUtil().setWidth(8),
                      right: ScreenUtil().setWidth(8),
                      child: getIt<UserService>().isLogin()
                          ? GetBuilder<ImageController>(
                              tag: tag,
                              id: 'mark',
                              builder: (_) {
                                return LikeButton(
                                  likeBuilder: (bool isLiked) {
                                    return Icon(
                                      Icons.favorite,
                                      color: isLiked ? Colors.red : Colors.grey,
                                      size: ScreenUtil().setWidth(32),
                                    );
                                  },
                                  isLiked: controller.illust.isLiked,
                                  onTap: controller.markIllust,
                                  size: ScreenUtil().setWidth(32),
                                );
                              })
                          : Container(),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
