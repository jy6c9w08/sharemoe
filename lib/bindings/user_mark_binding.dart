// Package imports:
import 'package:get/get.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';

// Project imports:
import 'package:sharemoe/controller/water_flow_controller.dart';

class UserMarkBinding implements Bindings {
  @override
  void dependencies() {

    Get.lazyPut(
            () => WaterFlowController(
            model: PicModel.BOOKMARK_ILLUST,
            isManga: false,
            userId: Get.arguments.toString()),
        tag: PicModel.BOOKMARK_ILLUST+Get.arguments.toString());
    Get.lazyPut(
            () => WaterFlowController(
            model: PicModel.BOOKMARK_MAGA,
            isManga: true,
            userId:  Get.arguments.toString()),
        tag:  PicModel.BOOKMARK_MAGA+Get.arguments.toString());

    }
  }

