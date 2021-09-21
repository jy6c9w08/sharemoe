import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/data/model/comment.dart';
import 'package:sharemoe/data/repository/comment_repository.dart';

class CommentController extends GetxController {
  Rx<Comment> comment;

  CommentController({required this.comment});

  addSubComment(Comment comment) {
    this.comment.value = comment;
    // update(['addSunComment']);
  }

  Future postLike() async {
    Map<String, dynamic> body = {
      'commentAppType': PicType.illusts,
      'commentAppId': Get.arguments,
      'commentId': comment.value.id
    };
    await getIt<CommentRepository>().queryLikedComment(body);
    comment.value.isLike = !comment.value.isLike;
    comment.value.likedCount++;
    update(['like']);
  }

  Future cancelLike() async {
    await getIt<CommentRepository>().queryCancelLikedComment(
        PicType.illusts, int.parse(Get.arguments), comment.value.id);
    comment.value.isLike = !comment.value.isLike;
    comment.value.likedCount--;
    update(['like']);
  }
}
