// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/controller/comment/comment_text_filed_controller.dart';
import 'meme_box.dart';

// Project imports:

class CommentTextFileBar extends GetView<CommentTextFiledController> {
  CommentTextFileBar(
      {Key? key, required this.tag, required this.isReply, this.appId})
      : super(key: key);
  @override
  final String tag;

  final bool isReply;
  final int? appId;

  @override
  Widget build(BuildContext context) {
    return GetX<CommentTextFiledController>(
        tag: tag,
        builder: (_) {
          return AnimatedPositioned(
            duration: Duration(milliseconds: 100),
            bottom: controller.isMemeMode.value ||
                    controller.hasFocus.value
                ? 0
                : controller.memeBoxHeight * -1,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 5.h, left: 5.w, right: 5.w),
                  width: 324.w,
                  height: 35.h,
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
                            controller.isMemeMode.value = true;
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
                          child: GetBuilder<CommentTextFiledController>(
                              id: 'reply',
                              tag: tag,
                              builder: (_) {
                                return TextField(
                                  focusNode: controller.replyFocus,
                                  controller: controller.textEditingController,
                                  autofocus: isReply ? true : false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: controller.hintText,
                                      hintStyle: TextStyle(fontSize: 14 ),
                                      contentPadding: EdgeInsets.only(
                                          left: 8.w,
                                          bottom: 10.h)
                                  ),
                                );
                              })),
                      Material(
                        color: Colors.white,
                        child: InkWell(
                          child: FaIcon(FontAwesomeIcons.paperPlane),
                          onTap: () {
                            controller.reply(appId: appId);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                GetBuilder<CommentTextFiledController>(
                    tag: tag,
                    id: 'memeBox',
                    builder: (context) {
                  return _.isMemeMode.value
                      ? MemeBox(
                          tag,
                          widgetHeight: _.memeBoxHeight,
                          appId: appId,
                        )
                      : Container(
                          color: Colors.pinkAccent,
                          height: _.memeBoxHeight,
                        );
                })
              ],
            ),
          );
        });
  }
}
