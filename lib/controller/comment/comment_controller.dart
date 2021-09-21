import 'package:get/get.dart';
import 'package:sharemoe/data/model/comment.dart';

class CommentController extends GetxController {
  Rx<Comment>  comment;

  CommentController({required this.comment});

  addSubComment(Comment comment) {
    this.comment.value = comment;
    update(['addSunComment']);
  }
}
