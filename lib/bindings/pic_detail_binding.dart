import 'package:get/get.dart';
import 'package:sharemoe/controller/comment_controller.dart';
import 'package:sharemoe/controller/pic_detail_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/data/model/illust.dart';

class PicDetailBinding implements Bindings {
  PicDetailBinding();

  @override
  void dependencies() {
    Get.lazyPut(() => PicDetailController(illustId: (Get.arguments as Illust).id));
    Get.lazyPut(
        () => WaterFlowController(
            model: 'related', relatedId: (Get.arguments as Illust).id),
        tag: 'related'+(Get.arguments as Illust).id.toString());
    Get.lazyPut(() => CommentController(illustId: (Get.arguments as Illust).id),
        tag: (Get.arguments as Illust).id.toString());
  }
}
