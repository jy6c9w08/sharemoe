// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

// Project imports:
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/controller/comment/comment_List_controller.dart';
import 'package:sharemoe/controller/comment/comment_text_filed_controller.dart';
import 'package:sharemoe/routes/app_pages.dart';

class CommentCell extends GetView<CommentListController> {
  @override
  final String tag;

  final ScreenUtil screen = ScreenUtil();

  CommentCell(this.tag);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: screen.setWidth(324),
      height: screen.setHeight(150),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
                left: ScreenUtil().setHeight(7),
                top: ScreenUtil().setHeight(6),
                bottom: ScreenUtil().setHeight(6)),
            child: Text(
              TextZhCommentCell.comment,
              style: TextStyle(
                fontSize: ScreenUtil().setWidth(14),
              ),
            ),
          ),
          GetBuilder<CommentListController>(
              // init: Get.put(CommentController(illustId: illustId),
              //     tag: illustId.toString()),
              id: 'commentList',
              tag: controller.illustId.toString(),
              builder: (_) {
                if (_.commentList.isEmpty) {
                  return showNoComment();
                } else {
                  return _.commentList.length == 0
                      ? showNoComment()
                      : showFirstComment();
                }
              })
          // commentJsonData == null ? showNoComment() : showFirstComment()
        ],
      ),
    );
  }

  Widget showNoComment() {
    return Column(
      children: <Widget>[
        Lottie.asset('assets/image/comment.json',
            repeat: false, height: ScreenUtil().setHeight(45)),
        SizedBox(
          height: screen.setHeight(12),
        ),
        SizedBox(
          width: screen.setWidth(200),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            color: Colors.blueGrey[200],
            child: Text(
              TextZhCommentCell.addComment,
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Get.toNamed(Routes.COMMENT,
                  arguments: controller.illustId.toString());
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //       builder: (context) => CommentListPage(
              //         comments: null,
              //         illustId: widget.id,
              //         isReply: true,
              //       )),
              // );
            },
          ),
        )
      ],
    );
  }

  Widget showFirstComment() {
    String avaterUrl =
        'https://static.sharemoe.net/avatar/299x299/${controller.commentList[0].replyFrom}.jpg';
    // print(avaterUrl);

    return Container(
      padding: EdgeInsets.only(
          left: ScreenUtil().setHeight(7),
          top: ScreenUtil().setHeight(5),
          right: ScreenUtil().setHeight(7)),
      alignment: Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          Material(
            color: Colors.white,
            child: InkWell(
              // 跳转总回复
              onTap: () {
                Get.toNamed(Routes.COMMENT,
                    arguments: controller.illustId.toString());
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //       builder: (context) => CommentListPage(
                //         comments: commentJsonData,
                //         illustId: widget.id,
                //       )),
                // );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      right: ScreenUtil().setWidth(8),
                    ),
                    child: CircleAvatar(
                        // backgroundColor: Colors.white,
                        radius: ScreenUtil().setHeight(14),
                        backgroundImage: NetworkImage(avaterUrl,
                            headers: {'referer': 'https://pixivic.com'})),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: ScreenUtil().setHeight(5)),
                      Text(
                        controller.commentList[0].replyFromName,
                        style: TextStyle(fontSize: 12),
                      ),
                      Container(
                          width: ScreenUtil().setWidth(235),
                          alignment: Alignment.centerLeft,
                          child: commentContentDisplay(
                            controller.commentList[0].content,
                          )),
                      Container(
                        padding: EdgeInsets.only(
                          top: ScreenUtil().setHeight(4),
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              DateFormat("yyyy-MM-dd").format(DateTime.parse(
                                  controller.commentList[0].createDate)),
                              strutStyle: StrutStyle(
                                fontSize: 12,
                                height: ScreenUtil().setWidth(1.3),
                              ),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(5),
                            ),
                            // 回复
                            GestureDetector(
                              child: Text(
                                TextZhCommentCell.reply,
                                strutStyle: StrutStyle(
                                  fontSize: 12,
                                  height: ScreenUtil().setWidth(1.3),
                                ),
                                style: TextStyle(
                                    color: Colors.blue[600], fontSize: 12),
                              ),
                              onTap: () {
                                Get.toNamed(Routes.COMMENT_REPLY,
                                    arguments: controller.illustId.toString());
                                Get.find<CommentTextFiledController>(
                                        tag: controller.illustId.toString())
                                    .replyOther(controller.commentList[0]);
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(5),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(200),
            height: ScreenUtil().setHeight(30),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              color: Colors.blueGrey[200],
              child: Text(
                TextZhCommentCell.addComment,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Get.toNamed(Routes.COMMENT,
                    arguments: controller.illustId.toString());
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //       builder: (context) => CommentListPage(
                //         comments: commentJsonData,
                //         illustId: widget.id,
                //         isReply: true,
                //       )),
                // );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget commentContentDisplay(String content) {
    if (content[0] == '[' &&
        content[content.length - 1] == ']' &&
        content.contains('_:')) {
      String memeStr = content.substring(1, content.length - 1).split('_')[1];
      String memeId = memeStr.substring(1, memeStr.length - 1);
      String memeHead = memeId.split('-')[0];
      print(memeHead);
      print(memeId);
      return Container(
        width: ScreenUtil().setWidth(30),
        height: ScreenUtil().setWidth(30),
        child: Image(
            image: AssetImage('assets/image/meme/$memeHead/$memeId.webp')),
      );
    } else {
      return Text(
        content,
        softWrap: true,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      );
    }
  }
}
