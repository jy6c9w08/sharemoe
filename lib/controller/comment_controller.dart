import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:bot_toast/bot_toast.dart';

import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/data/model/comment.dart';
import 'package:sharemoe/data/repository/comment_repository.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

class CommentController extends GetxController with WidgetsBindingObserver {
  CommentController({required this.illustId, this.isSingle = false});

  CommentController.single({
    this.illustId = 0,
    this.isSingle = true,
  });

  static final UserService userService = getIt<UserService>();
  static final CommentRepository commentRepository = getIt<CommentRepository>();
  final int illustId;
  final commentList = Rx<List<Comment>>([]);
  final currentKeyboardHeight = Rx<double>(0.0);
  final memeBoxHeight = Rx<double>(0);
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
    WidgetsBinding.instance!.addObserver(this);
    textEditingController = TextEditingController();

    scrollController = ScrollController()..addListener(_autoLoading);
    replyFocus = FocusNode()..addListener(replyFocusListener);
    isSingle
        ? getSingleComment().then((value) {
            comment = value;
            print(comment!);
            update(['singleComment']);
          })
        : getCommentList().then((value) => commentList.value = value);
    getMeme();
    super.onInit();
  }

  @override
  void didChangeMetrics() {
    print('CommentListModel run didChangeMetrics');
    final renderObject = Get.context!.findRenderObject();
    final renderBox = renderObject as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final widgetRect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      renderBox.size.width,
      renderBox.size.height,
    );
    final keyboardTopPixels =
        window.physicalSize.height - window.viewInsets.bottom;
    final keyboardTopPoints = keyboardTopPixels / window.devicePixelRatio;
    double keyHeight = widgetRect.bottom - keyboardTopPoints;
    if (keyHeight > 0) {
      currentKeyboardHeight.value = keyHeight;
      memeBoxHeight.value = keyHeight;
      picBox.put('keyboardHeight', memeBoxHeight.value);
      print('didChangeMetrics memeBoxHeight: $keyHeight');
    } else {
      currentKeyboardHeight.value = 0;
    }

    super.didChangeMetrics();
  }

  getMeme() {
    rootBundle.loadString('image/meme/meme.json').then((value) {
      memeMap.value = jsonDecode(value);
      // print(memeMap);
    });
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
          commentList.value = commentList.value + value;
          loadMoreAble = true;
        }
      });
    }
  }

  reply({String? memeGroup, String? memeName}) async {
    String content = memeGroup == null
        ? textEditingController.text
        : '[${memeGroup}_$memeName]';
    if (UserService.queryToken() == '') {
      BotToast.showSimpleNotification(title: TextZhCommentCell.pleaseLogin);
      return false;
    }

    if (content == '') {
      BotToast.showSimpleNotification(
          title: TextZhCommentCell.commentCannotBeBlank);
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

    await commentRepository.querySubmitComment(
      PicType.illusts,
      isSingle ? comment!.appId : commentList.value[0].appId,
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
        : getCommentList().then((value) => commentList.value = value);
  }

  Future postLike(int commentId) async {
    Map<String, dynamic> body = {
      'commentAppType': PicType.illusts,
      'commentAppId': isSingle ? comment!.appId : commentList.value[0].appId,
      'commentId': commentId
    };
    await getIt<CommentRepository>().queryLikedComment(body);
    isSingle
        ? getSingleComment().then((value) {
            comment = value;
            print(comment!);
            update(['singleComment']);
          })
        : getCommentList().then((value) => commentList.value = value);
  }

  Future cancelLike(int commentId) async {
    await getIt<CommentRepository>().queryCancelLikedComment(PicType.illusts,
        isSingle ? comment!.appId : commentList.value[0].appId, commentId);
    isSingle
        ? getSingleComment().then((value) {
            comment = value;
            print(comment!);
            update(['singleComment']);
          })
        : getCommentList().then((value) => commentList.value = value);
  }
}

class SingleCommentController extends GetxController {}
