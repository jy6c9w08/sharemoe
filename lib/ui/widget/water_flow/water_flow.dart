// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

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
  final bool permanent;

  final ScreenUtil screen = ScreenUtil();
  static final UserService userService = getIt<UserService>();

  WaterFlow({
    Key? key,
    required this.tag,
    this.permanent = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller.obx(
        (state) => SliverPadding(
              padding: EdgeInsets.all(screen.setWidth(5)),
              sliver: SliverWaterfallFlow(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  Get.put<ImageController>(
                      ImageController(illust: controller.illustList[index]),
                      tag: controller.illustList[index].id.toString(),
                      permanent: permanent)
                    ..illust = controller.illustList[index];
                  return ImageCell(
                    illust: controller.illustList[index],
                    tag: controller.illustList[index].id.toString(),
                  );
                }, childCount: controller.illustList.length),
                gridDelegate:
                    SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                  crossAxisCount: userService.waterNumber(),
                  crossAxisSpacing: screen.setWidth(10),
                  mainAxisSpacing: screen.setWidth(10),
                  viewportBuilder: (int firstIndex, int lastIndex) {
                    if (lastIndex == controller.illustList.length - 1 &&
                        controller.loadMore &&
                        controller.model != 'recommend' &&
                        controller.model != 'similar') {
                      controller.loadData();
                    }
                  },
                  collectGarbage: (List<int> garbage) {
                    garbage.forEach((index) {
                      final provider = ExtendedNetworkImageProvider(
                        controller.illustList[index].imageUrls[0].medium,
                      );
                      provider.evict();
                    });
                  },
                ),
              ),
            ),
        onLoading: SliverToBoxAdapter(
          child: LoadingBox(),
        ),
        onEmpty: SliverToBoxAdapter(
          child: EmptyBox(),
        ), onError: (error) {
      return SliverToBoxAdapter(child: NeedNetWork(from: tag,));
    });
  }
}
