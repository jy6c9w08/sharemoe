// Package imports:
import 'package:get/get.dart';
import 'package:sharemoe/controller/comment/comment_List_controller.dart';

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
    Get.lazyPut(() => CommentListController.single(),tag: 'single');
  }
}
