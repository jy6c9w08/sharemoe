// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/data/model/comment.dart';
import 'package:sharemoe/data/repository/comment_repository.dart';

class CommentListController extends GetxController {
  CommentListController({required this.illustId});

  CommentListController.single({
    this.illustId = 0,
  });

  static final UserService userService = getIt<UserService>();
  static final CommentRepository commentRepository = getIt<CommentRepository>();
  final int illustId;

  late List<Comment> commentList = [];
  final memeBoxHeight = Rx<double>(userService.keyBoardHeightFromHive()!);
  final memeMap = Rx<Map>({});
  final isMemeMode = Rx<bool>(false);
  final hintText = Rx<String>(TextZhCommentCell.addCommentHint);

  late ScrollController scrollController;

  late bool loadMoreAble = true;
  late int currentPage = 1;

  // Map memeMap;

  late TextEditingController textEditingController;
  late FocusNode replyFocus;

  void onInit() {
    scrollController = ScrollController()..addListener(_autoLoading);
    getCommentList().then((value) {
      commentList = value;
      update(['commentList']);
    });
    super.onInit();
  }

  addComment(Comment comment) {
    commentList.insert(0, comment);
    update(['commentList']);
  }

  Future<List<Comment>> getCommentList({currentPage = 1}) async {
    return await commentRepository.queryGetComment(
        PicType.illusts, illustId, currentPage, 10);
  }

  _autoLoading() {
    if ((scrollController.position.extentAfter < 500) && loadMoreAble) {
      print("Load Comment");
      loadMoreAble = false;
      currentPage++;
      print('current page is $currentPage');
      getCommentList(currentPage: currentPage).then((value) {
        if (value.isNotEmpty) {
          commentList = commentList + value;
          loadMoreAble = true;
          update(['commentList']);
        }
      });
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
