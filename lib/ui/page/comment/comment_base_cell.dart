// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/controller/comment/comment_controller.dart';
import 'package:sharemoe/controller/comment/comment_text_filed_controller.dart';
import 'package:sharemoe/data/model/bookmarked_user.dart';
import 'package:sharemoe/data/model/comment.dart';
import 'package:sharemoe/routes/app_pages.dart';

class CommentCell extends GetView<CommentController> {
  CommentCell({Key? key, required this.tag, this.illustId, this.appId})
      : super(key: key);
  @override
  final String tag;
  final String? illustId;
  final int? appId;

  @override
  Widget build(BuildContext context) {
    return GetX<CommentController>(
        tag: tag,
        builder: (_) {
          bool hasSub =
              controller.comment!.value.subCommentList == null ? false : true;
          return Container(
            color: Colors.white,
            width: 324.w,
            padding: EdgeInsets.only(left: 7.h, right: 7.h, top: 10.h),
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  commentBaseCell(controller.comment!.value),
                  hasSub
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              controller.comment!.value.subCommentList!.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            Get.put(
                                CommentController(
                                    comment: Rx<Comment>(controller.comment!
                                        .value.subCommentList![index])),
                                tag: controller
                                    .comment!.value.subCommentList![index].id
                                    .toString());
                            return commentSubCell(controller
                                .comment!.value.subCommentList![index]);
                          })
                      : Container(),
                  SizedBox(width: 300.h, child: Divider())
                ],
              ),
            ),
          );
        });
  }

  Widget commentSubCell(Comment commentEachSubData) {
    return Container(
      padding: EdgeInsets.only(left: 25.w, top: 7.h),
      child: commentBaseCell(commentEachSubData),
    );
  }

  Widget commentBaseCell(Comment comment, {int? subIndex}) {
    String avaterUrl =
        ('https://static.sharemoe.net/avatar/299x299/${comment.replyFrom}.jpg');

    return Container(
        child: Column(children: <Widget>[
      Material(
          color: Colors.white,
          child: InkWell(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    right: ScreenUtil().setWidth(8),
                  ),
                  child: GestureDetector(
                    child: CircleAvatar(
                        // backgroundColor: Colors.white,
                        radius: ScreenUtil().setHeight(14),
                        backgroundImage: NetworkImage(
                            avaterUrl,
                            headers: {'referer': 'https://pixivic.com'})),
                    onTap: () {
                      Get.toNamed(Routes.OTHER_USER_FOLLOW,
                          arguments: BookmarkedUser(
                              username: comment.replyFromName,
                              userId: comment.replyFrom,
                              createDate: comment.createDate));
                    },
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setHeight(5)),
                    Text(
                      comment.replyFromName,
                      style: TextStyle(fontSize: 12),
                    ),
                    Container(
                      width: 235.h,
                      alignment: Alignment.centerLeft,
                      child: commentContentDisplay(comment),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(4),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            DateFormat("yyyy-MM-dd")
                                .format(DateTime.parse(comment.createDate)),
                            strutStyle: StrutStyle(
                              fontSize: ScreenUtil().setSp(11),
                              height: ScreenUtil().setWidth(1.3),
                            ),
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: ScreenUtil().setSp(9)),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(5),
                          ),
                          commentPlatform(comment.platform),
                          commentLikeButton(comment),
                          // commentLikeButton(context, parentIndex, commentListModel,
                          //     subIndex: subIndex),
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
                              Get.find<CommentTextFiledController>(
                                      tag: illustId ??
                                          controller.comment!.value.id
                                              .toString())
                                  .replyOther(comment);
                              // controller.comment.replyToName = data.replyFromName;
                              // controller.comment.replyToId = data.replyFrom;
                              // data.parentId == 0
                              //     ? controller.comment.replyParentId = data.id
                              //     : controller.comment.replyParentId = data.parentId;
                              // if (controller.comment.replyFocus.hasFocus)
                              //   controller.comment.replyFocusListener();
                              // else
                              //   controller.replyFocus.requestFocus();
                            },
                          )
                        ],
                      ),
                    )
                  ],
                )
              ])))
    ]));
  }

  Widget commentContentDisplay(Comment data) {
    String content = data.content;

    if (content[0] == '[' &&
        content[content.length - 1] == ']' &&
        content.contains('_:')) {
      String memeStr = content.substring(1, content.length - 1).split('_')[1];
      String memeId = memeStr.substring(1, memeStr.length - 1);
      String memeHead = memeId.split('-')[0];
      // print(memeHead);
      // print(memeId);
      Widget image = Container(
        width: ScreenUtil().setWidth(50),
        height: ScreenUtil().setWidth(50),
        child: Image(
            image: AssetImage('assets/image/meme/$memeHead/$memeId.webp')),
      );
      return data.replyToName == ''
          ? image
          : Row(
              children: [
                Text(
                  '@${data.replyToName}',
                  softWrap: true,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(8),
                ),
                image
              ],
            );
    } else {
      return Text(
        data.replyToName == ''
            ? data.content
            : '@${data.replyToName}: ${data.content}',
        softWrap: true,
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      );
    }
  }

  Widget commentLikeButton(Comment comment) {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(
        right: ScreenUtil().setWidth(7),
      ),
      child: GetBuilder<CommentController>(
          id: 'like',
          tag: comment.id.toString(),
          builder: (_) {
            return GestureDetector(
                onTap: () async {
                  _.comment!.value.isLike
                      ? _.cancelLike(appId: appId)
                      : _.postLike(appId: appId);
                },
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Icon(
                        Icons.thumb_up_alt_outlined,
                        color: _.comment!.value.isLike
                            ? Color(0xffFFC0CB)
                            : Colors.grey,
                        size: ScreenUtil().setWidth(13),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(3)),
                      child: Text(_.comment!.value.likedCount.toString(),
                          strutStyle: StrutStyle(
                            fontSize: ScreenUtil().setSp(11),
                            height: ScreenUtil().setWidth(1.3),
                          ),
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: ScreenUtil().setSp(10))),
                    )
                  ],
                ));
          }),
    );
  }

  Widget commentPlatform(String? platform) {
    return platform == null
        ? Container()
        : Container(
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(5)),
            child: Text(
              platform,
              strutStyle: StrutStyle(
                fontSize: ScreenUtil().setSp(11),
                height: ScreenUtil().setWidth(1.3),
              ),
              style: TextStyle(
                  color: Colors.grey, fontSize: ScreenUtil().setSp(9)),
            ));
  }
}
