// Package imports:
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/controller/user/type_controller.dart';
import 'package:sharemoe/controller/user/user_controller.dart';
import 'package:sharemoe/data/model/message.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

class MessageController extends GetxController {
  final Rx<List<Message>> messageList = Rx<List<Message>>([]);
  final String model;
  late ScrollController scrollController;
  late bool loadMoreAble = true;

  DateTime nowTime = DateTime.now();

  MessageController({required this.model});

  Future<List<Message>> getCommentData(DateTime time) async {
    return await getIt<UserRepository>().queryMessageList(
        getIt<UserService>().userInfo()!.id,
        1,
        time.millisecondsSinceEpoch ~/ 1000);
  }

  Future<List<Message>> getThumbData(DateTime time) async {
    Get.find<TypeController>().getTotalUnReade();
    Get.find<UserController>().getUnReadeMessageNumber();
    return await getIt<UserRepository>().queryMessageList(
        getIt<UserService>().userInfo()!.id,
        2,
        time.millisecondsSinceEpoch ~/ 1000);
  }

  @override
  void onInit() {
    scrollController = ScrollController()..addListener(_autoLoading);
    model == 'comment'
        ? getCommentData(nowTime).then((value) => messageList.value = value)
        : getThumbData(nowTime).then((value) => messageList.value = value);
    super.onInit();
  }

  _autoLoading() {
    if ((scrollController.position.extentAfter < 500) && loadMoreAble) {
      print("Load Comment");
      loadMoreAble = false;
      model == 'comment'
          ? getCommentData(DateTime.parse(messageList.value.last.createDate))
              .then((value) {
              if (value.isNotEmpty) {
                messageList.value = value;
                loadMoreAble = true;
              }
            })
          : getThumbData(DateTime.parse(messageList.value.last.createDate))
              .then((value) {
              if (value.isNotEmpty) {
                messageList.value = value;
                loadMoreAble = true;
              }
            });

      // print('current page is $currentPage');
      // getCommentList(currentPage: currentPage).then((value) {
      //   if (value.isNotEmpty) {
      //     commentList.value = commentList.value + value;
      //     loadMoreAble = true;
      //   }
      // });
    }
  }

  @override
  void onClose() {
    Get.find<TypeController>().getTotalUnReade();
    Get.find<UserController>().getUnReadeMessageNumber();
    super.onClose();
  }
}
