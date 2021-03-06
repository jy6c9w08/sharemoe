import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/basic/texts.dart';
import 'package:sharemoe/data/model/comment.dart';
import 'package:sharemoe/data/repository/comment_repository.dart';

class CommentController extends GetxController with WidgetsBindingObserver {
  final int illustId;
  final commentList = Rx<List<Comment>>();
  final currentKeyboardHeight = Rx<double>(0.0);
  final memeBoxHeight = Rx<double>(0.0);
  final memeMap = Rx<Map>();
  final isMemeMode = Rx<bool>(false);
  final hintString=Rx<String>('');

  final TextZhCommentCell texts = TextZhCommentCell();

  String replyToName;
  String hintText;
  int replyParentId;
  int replyToId;

  // Map memeMap;

  TextEditingController textEditingController;
  FocusNode replyFocus;

  CommentController({this.illustId});

  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    textEditingController = TextEditingController();
    replyFocus = FocusNode()..addListener(replyFocusListener);
    getCommentList().then((value) => commentList.value = value);
    getMeme();
    super.onInit();
  }

  @override
  void didChangeMetrics() {
    print('CommentListModel run didChangeMetrics');
    final renderObject = Get.context.findRenderObject();
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

  Future<List<Comment>> getCommentList() async {
    return await getIt<CommentRepository>()
        .queryGetComment(AppType.illusts, illustId, 1, 10);
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
      }
    } else if (!replyFocus.hasFocus) {
      print('replyFocus released');

      if (!isMemeMode.value) {
        replyToId = 0;
        replyToName = '';
        replyParentId = 0;
        hintText = texts.addCommentHint;
        // print(textEditingController.text);
      }
    }
  }
}
