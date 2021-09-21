// Dart imports:
import 'dart:convert';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/data/model/comment.dart';
import 'package:sharemoe/data/repository/comment_repository.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

class CommentListController extends GetxController {
  CommentListController({required this.illustId, this.isSingle = false});

  CommentListController.single({
    this.illustId = 0,
    this.isSingle = true,
  });

  static final UserService userService = getIt<UserService>();
  static final CommentRepository commentRepository = getIt<CommentRepository>();
  final int illustId;

  // final commentList = Rx<List<Comment>>([]);
  late List<Comment> commentList = [];
  final currentKeyboardHeight = Rx<double>(0.0);
  final memeBoxHeight = Rx<double>(userService.keyBoardHeightFromHive()!);
  final memeMap = Rx<Map>({});
  final isMemeMode = Rx<bool>(false);
  final hintText = Rx<String>(TextZhCommentCell.addCommentHint);
  Comment? comment;

  //单挑评论
  final bool isSingle;

  late ScrollController scrollController;

  late String replyToName = '';
  late int replyParentId = 0;
  late int replyToId = 0;
  late bool loadMoreAble = true;
  late int currentPage = 1;
  late int replyToCommentId = 0;
  late bool isReplyAble = true;

  // Map memeMap;

  late TextEditingController textEditingController;
  late FocusNode replyFocus;

  void onInit() {
    // WidgetsBinding.instance!.addObserver(this);
    textEditingController = TextEditingController();

    scrollController = ScrollController()..addListener(_autoLoading);
    replyFocus = FocusNode()..addListener(replyFocusListener);
    isSingle
        ? getSingleComment().then((value) {
            comment = value;
            update(['singleComment']);
          })
        : getCommentList().then((value) {
            commentList = value;
            update(['commentList']);
          });
    getMeme();
    super.onInit();
  }

  // @override
  // void didChangeMetrics() {
  //   print('CommentListModel run didChangeMetrics');
  //   final renderObject = Get.context!.findRenderObject();
  //   final renderBox = renderObject as RenderBox;
  //   final offset = renderBox.localToGlobal(Offset.zero);
  //   final widgetRect = Rect.fromLTWH(
  //     offset.dx,
  //     offset.dy,
  //     renderBox.size.width,
  //     renderBox.size.height,
  //   );
  //   final keyboardTopPixels =
  //       window.physicalSize.height - window.viewInsets.bottom;
  //   final keyboardTopPoints = keyboardTopPixels / window.devicePixelRatio;
  //   double keyHeight = widgetRect.bottom - keyboardTopPoints;
  //   if (keyHeight > 0) {
  //     currentKeyboardHeight.value = keyHeight;
  //     if (keyHeight <= 260 && userService.spareKeyboard()) keyHeight = 270;
  //     memeBoxHeight.value = keyHeight;
  //     userService.setKeyBoardHeight(keyHeight);
  //     print('didChangeMetrics memeBoxHeight: $keyHeight');
  //   } else {
  //     currentKeyboardHeight.value = 0;
  //   }
  //
  //   super.didChangeMetrics();
  // }

  getMeme() {
    rootBundle.loadString('assets/image/meme/meme.json').then((value) {
      memeMap.value = jsonDecode(value);
      // print(memeMap);
    });
  }

  addComment(Comment comment) {
    commentList.insert(0, comment);
    update(['commentList']);
// for(int i=0;i<commentList.value.length;i++){
//     if(commentList.value[i].id==comment.id) {
//       {
//         commentList.value[i] = comment;
//         break;
//       }
//     }
// }
  }

  Future<List<Comment>> getCommentList({currentPage = 1}) async {
    return await commentRepository.queryGetComment(
        PicType.illusts, illustId, currentPage, 10);
  }

  Future<Comment> getSingleComment() async {
    return await getIt<UserRepository>().queryGetSingleComment(Get.arguments);
  }

  replyFocusListener() {
    if (replyFocus.hasFocus) {
      // currentKeyboardHeight = prefs.getDouble('KeyboardHeight');
      // notifyListeners();
      print('replyFocus on focus');
      if (isMemeMode.value) isMemeMode.value = !isMemeMode.value;
      if (replyToName != '') {
        print('replyFocusListener: replyParentId is $replyParentId');
        hintText.value = '@$replyToName:';
      }
    } else if (!replyFocus.hasFocus) {
      print('replyFocus released');

      if (!isMemeMode.value) {
        replyToId = 0;
        replyToName = '';
        replyParentId = 0;
        hintText.value = TextZhCommentCell.addCommentHint;
        // print(textEditingController.text);
      }
    }
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

  reply({String? memeGroup, String? memeName}) async {
    String content = memeGroup == null
        ? textEditingController.text
        : '[${memeGroup}_$memeName]';
    print(UserService.token);
    if (UserService.token == null) {
      BotToast.showSimpleNotification(
          title: TextZhCommentCell.pleaseLogin, hideCloseButton: true);
      return false;
    }

    if (content == '') {
      BotToast.showSimpleNotification(
          title: TextZhCommentCell.commentCannotBeBlank, hideCloseButton: true);
      return false;
    }

    Map<String, dynamic> payload = {
      'content': content,
      'parentId': replyParentId.toString(),
      'replyFromName': userService.userInfo()!.username,
      'replyTo': replyToId.toString(),
      'replyToName': replyToName,
      'replyToCommentId': replyToCommentId,
      'platform': 'Mobile 客户端'
    };

    // onReceiveProgress(int count, int total) {
    //   cancelLoading = BotToast.showLoading();
    // }
    print(commentList);
    await commentRepository.querySubmitComment(
      PicType.illusts,
      isSingle ? comment!.appId : illustId,
      payload,
    );

    // cancelLoading();

    textEditingController.text = '';
    replyToId = 0;
    replyToCommentId = 0;
    replyParentId = 0;
    replyToName = '';
    hintText.value = TextZhCommentCell.addCommentHint;

    isSingle
        ? getSingleComment().then((value) {
            comment = value;
            print(comment!);
            update(['singleComment']);
          })
        : getCommentList().then((value) => commentList = value);
  }

  Future postLike(int commentId) async {
    Map<String, dynamic> body = {
      'commentAppType': PicType.illusts,
      'commentAppId': isSingle ? comment!.appId : illustId,
      'commentId': commentId
    };
    await getIt<CommentRepository>().queryLikedComment(body);
    isSingle
        ? getSingleComment().then((value) {
            comment = value;
            print(comment!);
            update(['singleComment']);
          })
        : getCommentList().then((value) => commentList = value);
  }

  Future cancelLike(int commentId) async {
    await getIt<CommentRepository>().queryCancelLikedComment(
        PicType.illusts, isSingle ? comment!.appId : illustId, commentId);
    isSingle
        ? getSingleComment().then((value) {
            comment = value;
            print(comment!);
            update(['singleComment']);
          })
        : getCommentList().then((value) => commentList = value);
  }

  @override
  void onClose() {
    scrollController.dispose();
    textEditingController.dispose();
    replyFocus.removeListener(replyFocusListener);
    replyFocus.dispose();
    super.onClose();
  }
}
