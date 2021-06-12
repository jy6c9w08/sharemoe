import 'package:get/get.dart';
import 'package:sharemoe/controller/comment_controller.dart';
import 'package:sharemoe/controller/pic_detail_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';

class PicDetailBinding implements Bindings {
  PicDetailBinding();

  @override
  void dependencies() {
    Get.lazyPut(() => PicDetailController(illustId: int.parse(Get.arguments)));
    Get.lazyPut(
        () => WaterFlowController(
            model: 'related', relatedId: int.parse(Get.arguments)),
        tag: 'related' + Get.arguments);
    Get.lazyPut(() => CommentController(illustId: int.parse(Get.arguments)),
        tag: Get.arguments);
  }
}
