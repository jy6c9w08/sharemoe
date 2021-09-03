// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/controller/other_user/other_user_follow_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/data/model/bookmarked_user.dart';

class UserMarkBinding implements Bindings {
  UserMarkBinding();
  UserMarkBinding.other({ this.isOther=true});
  late bool isOther=false;
  @override
  void dependencies() {

    if(!isOther) {
      Get.lazyPut(
          () => WaterFlowController(
              model: 'bookmark',
              isManga: false,
              userId: Get.arguments.toString()),
          tag: 'bookmark${Get.arguments.toString()}false');
      Get.lazyPut(
          () => WaterFlowController(
              model: 'bookmark',
              isManga: true,
              userId: Get.arguments.toString()),
          tag: 'bookmark${Get.arguments.toString()}true');
    }else{
      Get.lazyPut(() => OtherUserFollowController(),tag: (Get.arguments as BookmarkedUser).userId.toString());
      Get.lazyPut(
              () => WaterFlowController(
              model: 'bookmark',
              isManga: false,
              userId: (Get.arguments as BookmarkedUser).userId.toString()),
          tag: 'bookmark${(Get.arguments as BookmarkedUser).userId.toString()}false');
      Get.lazyPut(
              () => WaterFlowController(
              model: 'bookmark',
              isManga: true,
              userId: (Get.arguments as BookmarkedUser).userId.toString()),
          tag: 'bookmark${(Get.arguments as BookmarkedUser).userId.toString()}true');

    }
  }
}
