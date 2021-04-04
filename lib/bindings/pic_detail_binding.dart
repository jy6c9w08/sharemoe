import 'package:get/get.dart';
import 'package:sharemoe/controller/comment_controller.dart';
import 'package:sharemoe/controller/pic_detail_controller.dart';

class PicDetailBinding implements Bindings {
  final int illustId;

  PicDetailBinding({this.illustId});

  @override
  void dependencies() {
    // Get.lazyPut(() => PicDetailController(illustId: illustId));
    Get.put(PicDetailController(illustId: illustId));
    Get.lazyPut(() => CommentController(illustId: illustId),
        tag: illustId.toString());
  }
}
