import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:sharemoe/controller/comment_controller.dart';
import 'package:sharemoe/ui/page/comment/comment_base_cell.dart';
import 'package:sharemoe/ui/page/comment/comment_textfile_bar.dart';
import 'package:sharemoe/ui/page/comment/meme_box.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:sharemoe/data/model/comment.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';

class CommentPage extends GetView<CommentController> {
  final TextZhCommentCell texts = TextZhCommentCell();
  final ScreenUtil screen = ScreenUtil();

  @override
  final String tag;

  // final int illustId;
  final int replyToId;
  final String replyToName;
  final int replyParentId;
  final bool isReply;

  CommentPage(
    this.tag, {
    // required this.illustId,
    this.isReply = false,
    this.replyToId = 0,
    this.replyToName = '',
    this.replyParentId = 0,
  });

  CommentPage.reply(
    this.tag, {
    // required this.illustId,
    this.isReply = true,
    required this.replyToId,
    required this.replyToName,
    required this.replyParentId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          //键盘移除焦点
          FocusScope.of(context).requestFocus(FocusNode());
          // memeBox 移除焦点
          if (controller.isMemeMode.value)
            controller.isMemeMode.value = !controller.isMemeMode.value;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: SappBar.normal(
              title: texts.comment,
            ),
            body: GetX<CommentController>(
                tag: controller.illustId.toString(),
                initState: (state) {
                  controller.replyToId = this.replyToId;
                  controller.replyToName = this.replyToName;
                  controller.replyParentId = this.replyParentId;
                  controller.hintText.value = replyToName != ''
                      ? '@$replyToName:'
                      : texts.addCommentHint;
                },
                builder: (_) {
                  return Container(
                    color: Colors.white,
                    child: Stack(
                      children: <Widget>[
                        _.commentList.value.isNotEmpty
                            ? Positioned(
                                // top: screen.setHeight(5),
                                child: Container(
                                width: screen.setWidth(324),
                                height: screen.setHeight(576),
                                margin: EdgeInsets.only(
                                    bottom: screen.setHeight(35)),
                                child: ListView.builder(
                                    controller: _.scrollController,
                                    shrinkWrap: true,
                                    itemCount: _.commentList.value.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return CommentCell(
                                        comment: _.commentList.value[index],
                                        tag: _.illustId.toString(),
                                      );
                                    }),
                              ))
                            : Container(),
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 100),
                          bottom: _.isMemeMode.value ||
                                  _.currentKeyboardHeight.value > 0
                              ? 0
                              : _.memeBoxHeight.value * -1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CommentTextFileBar(tag: controller.illustId.toString(), isReply: isReply,),
                              _.isMemeMode.value
                                  ? MemeBox(controller.illustId.toString(),
                                      widgetHeight: _.memeBoxHeight.value)
                                  : Container(
                                      color: Colors.pinkAccent,
                                      height: _.memeBoxHeight.value,
                                    )
                            ],
                          ),
                        ),
                        //TODO: selector 细化至单个显示组建中，这里改为只有 length 修改后才 build
                      ],
                    ),
                  );
                })));
  }

  Widget bottomCommentBar() {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      padding: EdgeInsets.only(
          bottom: screen.setHeight(5),
          left: screen.setWidth(5),
          right: screen.setWidth(5)),
      width: screen.setWidth(324),
      height: screen.setHeight(35),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Material(
            color: Colors.white,
            child: InkWell(
              child: FaIcon(
                FontAwesomeIcons.smile,
                color: Colors.pink[300],
              ),
              onTap: () {
                if (controller.replyFocus.hasFocus) {
                  controller.replyFocus.unfocus();
                }
                if (controller.currentKeyboardHeight.value != 0)
                  controller.currentKeyboardHeight.value = 0.0;
                controller.isMemeMode.value = !controller.isMemeMode.value;
              },
            ),
          ),
          Container(
              width: ScreenUtil().setWidth(262),
              height: ScreenUtil().setHeight(25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xFFF4F3F3F3),
              ),
              margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(5),
                right: ScreenUtil().setWidth(5),
              ),
              child: TextField(
                focusNode: controller.replyFocus,
                controller: controller.textEditingController,
                autofocus: isReply ? true : false,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: controller.hintText.value,
                    hintStyle: TextStyle(fontSize: 14),
                    contentPadding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(8),
                        bottom: ScreenUtil().setHeight(9))),
              )),
          Material(
            color: Colors.white,
            child: InkWell(
              child: FaIcon(FontAwesomeIcons.paperPlane),
              onTap: () {
                controller.reply();
              },
            ),
          ),
        ],
      ),
    );
  }
}
