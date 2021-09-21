// Package imports:
import 'package:get/get.dart';
import 'package:sharemoe/controller/comment/comment_List_controller.dart';
import 'package:sharemoe/controller/comment/comment_controller.dart';
import 'package:sharemoe/controller/comment/comment_text_filed_controller.dart';

// Project imports:
import 'package:sharemoe/controller/user/message_controller.dart';

class MessageBinding implements Bindings {
  @override
  void dependencies() {
    switch (Get.arguments) {
      case 'comment':
        Get.lazyPut(() => MessageController(model: 'comment'));
        break;
      case 'thumb':
        Get.lazyPut(() => MessageController(model: 'thumb'));
        break;
    }
  }
}

class SingleCommentBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(CommentController(),tag:Get.arguments);
    Get.put(CommentTextFiledController(),tag: Get.arguments);

    // Get.lazyPut(() => CommentController(comment: Get.arguments),tag: 'singleComment');
    // Get.lazyPut(() => CommentTextFiledController(),tag: 'singleComment');

    // Get.lazyPut(() => CommentListController.single(),tag: 'single');
  }
}
