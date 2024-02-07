// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/controller/comment/comment_List_controller.dart';
import 'package:sharemoe/controller/comment/comment_controller.dart';
import 'package:sharemoe/controller/comment/comment_text_filed_controller.dart';
import 'package:sharemoe/data/model/comment.dart';
import 'package:sharemoe/ui/page/comment/comment_base_cell.dart';
import 'package:sharemoe/ui/page/comment/comment_textfile_bar.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class CommentPage extends GetView<CommentListController> {
  final ScreenUtil screen = ScreenUtil();

  @override
  final String tag;

  // final int illustId;

  final bool isReply;

  CommentPage(
    this.tag, {
    // required this.illustId,
    this.isReply = false,
  });

  CommentPage.reply(
    this.tag, {
    // required this.illustId,
    this.isReply = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Get.find<CommentTextFiledController>(
              tag: controller.illustId.toString())
            ..replyFocus.unfocus()
            ..toastMeme();
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: SappBar.normal(
              title: TextZhCommentCell.comment,
            ),
            body: GetBuilder<CommentListController>(
                id: 'commentList',
                tag: controller.illustId.toString(),
                builder: (_) {
                  return Container(
                    child: Stack(
                      children: <Widget>[
                        _.commentList.isNotEmpty
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
                                    itemCount: _.commentList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Get.put(
                                          CommentController(
                                              comment: Rx<Comment>(
                                                  _.commentList[index])),
                                          tag: _.commentList[index].id
                                              .toString());

                                      return CommentCell(
                                        tag: _.commentList[index].id.toString(),
                                        illustId: _.illustId.toString(),
                                      );
                                    }),
                              ))
                            : Container(),
                        CommentTextFileBar(
                            tag: controller.illustId.toString(),
                            isReply: isReply),
                        // AnimatedPositioned(
                        //   duration: Duration(milliseconds: 100),
                        //   bottom: _.isMemeMode.value ||
                        //           _.currentKeyboardHeight.value > 0
                        //       ? 0
                        //       : _.memeBoxHeight.value * -1,
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       CommentTextFileBar(tag: controller.illustId.toString(), isReply: isReply,),
                        //       _.isMemeMode.value
                        //           ? MemeBox(controller.illustId.toString(),
                        //               widgetHeight: _.memeBoxHeight.value)
                        //           : Container(
                        //               color: Colors.pinkAccent,
                        //               height: _.memeBoxHeight.value,
                        //             )
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  );
                })));
  }
}
