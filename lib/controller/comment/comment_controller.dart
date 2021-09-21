// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/data/model/comment.dart';
import 'package:sharemoe/data/repository/comment_repository.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

class CommentController extends GetxController {
  Rx<Comment>? comment;

  CommentController({this.comment});

  addSubComment(Comment comment) {
    this.comment!.value = comment;
  }

  Future postLike({int? appId}) async {
    Map<String, dynamic> body = {
      'commentAppType': PicType.illusts,
      'commentAppId': appId ?? int.parse(Get.arguments),
      'commentId': comment!.value.id
    };
    await getIt<CommentRepository>().queryLikedComment(body);
    comment!.value.isLike = !comment!.value.isLike;
    comment!.value.likedCount++;
    update(['like']);
  }

  Future cancelLike({int? appId}) async {
    await getIt<CommentRepository>().queryCancelLikedComment(
        PicType.illusts, appId ?? int.parse(Get.arguments), comment!.value.id);
    comment!.value.isLike = !comment!.value.isLike;
    comment!.value.likedCount--;
    update(['like']);
  }

  @override
  void onInit() {
    if (comment == null)
      getIt<UserRepository>()
          .queryGetSingleComment(int.parse(Get.arguments))
          .then((value) {
        comment = Rx<Comment>(value);
        update(['finish']);
      });
    super.onInit();
  }
}
