// Package imports:
import 'package:get/get.dart';
import 'package:sharemoe/controller/comment/comment_text_filed_controller.dart';

class CommentBinding implements Bindings {
  @override
  void dependencies() {
   // Get.lazyPut(() => CommentTextFiledController(),tag: Get.arguments);
  }
}