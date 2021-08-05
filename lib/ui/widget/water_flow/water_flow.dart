// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:extended_image/extended_image.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/controller/image_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';
import '../state_box.dart';
import 'image_cell.dart';

class WaterFlow extends GetView<WaterFlowController> {
  @override
  final String tag;
  final ScreenUtil screen = ScreenUtil();
  static final UserService userService = getIt<UserService>();

  WaterFlow({
    Key? key,
    required this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller.obx(
        (state) => GetX<WaterFlowController>(
            tag: tag,
            autoRemove: false,
            builder: (_) {
              return SliverPadding(
                padding: EdgeInsets.all(screen.setWidth(10)),
                sliver: SliverWaterfallFlow(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    Get.put<ImageController>(
                        ImageController(
                            illust: controller.illustList.value[index]),
                        tag: controller.illustList.value[index].id.toString() +
                            userService
                                .isLogin() /*Get.find<GlobalController>().isLogin.value*/
                                .toString());
                    return ImageCell(
                      tag: controller.illustList.value[index].id.toString() +
                          userService.isLogin().toString(),
                    );
                  }, childCount: controller.illustList.value.length),
                  gridDelegate:
                      SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: screen.setWidth(8),
                    mainAxisSpacing: screen.setWidth(8),
                    viewportBuilder: (int firstIndex, int lastIndex) {
                      if (lastIndex == controller.illustList.value.length - 1 &&
                          controller.loadMore &&
                          controller.model != 'recommend') {
                        controller.loadData();
                      }
                    },
                    collectGarbage: (List<int> garbage) {
                      garbage.forEach((index) {
                        final provider = ExtendedNetworkImageProvider(
                          controller
                              .illustList.value[index].imageUrls[0].medium,
                        );
                        provider.evict();
                      });
                    },
                  ),
                ),
              );
            }),
        onLoading: SliverToBoxAdapter(
          child: LoadingBox(),
        ),
        onEmpty: SliverToBoxAdapter(
          child: EmptyBox(),
        ));
  }
}
