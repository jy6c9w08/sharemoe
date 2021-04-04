import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:extended_image/extended_image.dart';
import 'package:random_color/random_color.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/bindings/pic_detail_binding.dart';
import 'package:sharemoe/controller/global_controller.dart';

import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/controller/image_controller.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/page/pic_detail/pic_detail_page.dart';

class ImageCell extends GetView<ImageController> {
  @override
  final String tag;
  final Illust illust;
  final ScreenUtil screen = ScreenUtil();
  final Color _color = RandomColor().randomColor();

  ImageCell({Key key, this.illust, this.tag}) : super(key: key);

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
        controller.controller.forward();
        return FadeTransition(
          opacity: controller.controller,
          child: ExtendedRawImage(
            image: state.extendedImageInfo?.image,
          ),
        );

        break;
      case LoadState.failed:
        return Center(child: Text("加载失败"));
        break;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageController>(
        init: Get.put<ImageController>(ImageController(illustId: illust.id),
            tag: illust.id.toString()),
        initState: (_) {
          controller.isLiked = illust.isLiked;
        },
        builder: (_) {
          return Hero(
            tag: 'imageHero' + illust.imageUrls[0].medium,
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius:
                  BorderRadius.all(Radius.circular(ScreenUtil().setWidth(15))),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(
                          PicDetailPage(
                            illust: illust,
                          ),
                          binding: PicDetailBinding(illustId: illust.id),
                          preventDuplicates: false);
                      // Get.toNamed(
                      //   Routes.DETAIL,
                      //   arguments: illust,
                      //   preventDuplicates: false,
                      // );
                    },
                    child: ExtendedImage.network(
                      illust.imageUrls[0].medium.replaceAll(
                          'https://i.pximg.net', 'https://acgpic.net'),
                      cache: true,
                      headers: {'Referer': 'https://m.sharemoe.net/'},
                      width: screen.screenWidth / 2,
                      height:
                          screen.screenWidth / 2 / illust.width * illust.height,
                      loadStateChanged: dealImageState,
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: GetX<GlobalController>(builder: (_) {
                      return _.isLogin.value
                          ? GetBuilder<ImageController>(
                              tag: illust.id.toString(),
                              id: 'mark',
                              builder: (_) {
                                return IconButton(
                                  iconSize: 30,
                                  color: _.isLiked ? Colors.red : Colors.grey,
                                  icon: Icon(Icons.favorite),
                                  onPressed: () {
                                    _.markIllust();
                                  },
                                );
                              })
                          : Container();
                    }),
                  )
                ],
              ),
            ),
          );
        });
  }
}
