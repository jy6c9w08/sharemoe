// Dart imports:
import 'dart:convert';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/controller/comment/comment_controller.dart';
import 'package:sharemoe/data/model/comment.dart';
import 'package:sharemoe/data/repository/comment_repository.dart';
import 'package:sharemoe/data/repository/user_repository.dart';
import 'comment_List_controller.dart';

class CommentTextFiledController extends GetxController
    with WidgetsBindingObserver {
  static final CommentRepository commentRepository = getIt<CommentRepository>();
  static final UserService userService = getIt<UserService>();
  final currentKeyboardHeight = Rx<double>(0.0);
  final memeBoxHeight = Rx<double>(userService.keyBoardHeightFromHive()!);
  final memeMap = Rx<Map>({});
  final isMemeMode = Rx<bool>(false);

  // final hintText = Rx<String>(TextZhCommentCell.addCommentHint);

  late TextEditingController textEditingController;
  late FocusNode replyFocus;

  late String hintText = TextZhCommentCell.addCommentHint;
  late String replyToName = '';
  late int replyParentId = 0;
  late int replyToId = 0;
  late bool loadMoreAble = true;
  late int currentPage = 1;
  late int replyToCommentId = 0;
  late bool isReplyAble = true;

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
      if (keyHeight <= 260 && userService.spareKeyboard()) keyHeight = 270;
      memeBoxHeight.value = keyHeight;
      userService.setKeyBoardHeight(keyHeight);
      print('didChangeMetrics memeBoxHeight: $keyHeight');
    } else {
      currentKeyboardHeight.value = 0;
    }

    super.didChangeMetrics();
  }

  replyOther(Comment comment) {
    replyToName = comment.replyFromName;
    replyToId = comment.replyFrom;
    comment.parentId == 0
        ? replyParentId = comment.id
        : replyParentId = comment.parentId;
    if (replyFocus.hasFocus)
      replyFocusListener();
    else
      replyFocus.requestFocus();
    update(['reply']);
  }

  replyFocusListener() {
    if (replyFocus.hasFocus) {
      // currentKeyboardHeight = prefs.getDouble('KeyboardHeight');
      // notifyListeners();
      print('replyFocus on focus');
      if (isMemeMode.value) isMemeMode.value = !isMemeMode.value;
      if (replyToName != '') {
        print('replyFocusListener: replyParentId is $replyParentId');
        hintText = '@$replyToName:';
        update(['reply']);
      }
    } else if (!replyFocus.hasFocus) {
      print('replyFocus released');

      if (!isMemeMode.value) {
        replyToId = 0;
        replyToName = '';
        replyParentId = 0;
        hintText = TextZhCommentCell.addCommentHint;
        update(['reply']);
        // print(textEditingController.text);
      }
    }
  }

  getMeme() {
    rootBundle.loadString('assets/image/meme/meme.json').then((value) {
      memeMap.value = jsonDecode(value);
    });
  }

  //点击全局弹起Meme
  toastMeme() {
    if (isMemeMode.value) isMemeMode.value = !isMemeMode.value;
  }

  reply({String? memeGroup, String? memeName, int? appId}) async {
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
    await commentRepository
        .querySubmitComment(
      PicType.illusts,
      appId ?? int.parse(Get.arguments),
      payload,
    )
        .then((value) async {
      Comment comment;
      print(value);
      if (replyParentId != 0) {
        comment =
            await getIt<UserRepository>().queryGetSingleComment(replyParentId);
        Get.find<CommentController>(tag: comment.id.toString())
            .addSubComment(comment);
      } else {
        if (appId != null)
          return BotToast.showSimpleNotification(
              title: '选择指定回复人', hideCloseButton: true);
        comment = await getIt<UserRepository>().queryGetSingleComment(value);
        Get.find<CommentListController>(tag: Get.arguments).addComment(comment);
      }
    });

    // cancelLoading();

    textEditingController.text = '';
    replyToId = 0;
    replyToCommentId = 0;
    replyParentId = 0;
    replyToName = '';
    hintText = TextZhCommentCell.addCommentHint;
    update(['reply']);
  }

  @override
  void onInit() {
    WidgetsBinding.instance!.addObserver(this);
    textEditingController = TextEditingController();
    replyFocus = FocusNode()..addListener(replyFocusListener);
    getMeme();
    super.onInit();
  }
  @override
  void onClose() {
    textEditingController.dispose();
    replyFocus.removeListener(replyFocusListener);
    replyFocus.dispose();
    super.onClose();
  }
}
