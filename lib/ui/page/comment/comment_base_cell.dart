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
import 'package:sharemoe/controller/other_user/other_user_follow_controller.dart';
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
            width: 324.w,
            padding: EdgeInsets.only(left: 7.h, right: 7.h, top: 10.h),
            alignment: Alignment.center,
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
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
                                  comment: Rx<Comment>(controller
                                      .comment!.value.subCommentList![index])),
                              tag: controller
                                  .comment!.value.subCommentList![index].id
                                  .toString());
                          return commentSubCell(
                              controller.comment!.value.subCommentList![index]);
                        })
                    : Container(),
                SizedBox(
                    height: 5,
                    width: ScreenUtil().screenWidth,
                    child: Divider())
              ],
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
        ('https://s.edcms.pw/avatar/299x299/${comment.replyFrom}.jpg');

    return Container(
        padding: EdgeInsets.only(top: 5.w, left: 5.w),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  right: 8.w,
                ),
                child: GestureDetector(
                  child: CircleAvatar(
                      radius: 14.h,
                      backgroundImage: NetworkImage(avaterUrl,
                          headers: {'referer': 'https://pixivic.com'})),
                  onTap: () {
                    BookmarkedUser user = BookmarkedUser(
                        username: comment.replyFromName,
                        userId: comment.replyFrom,
                        createDate: comment.createDate);
                    Get.put(OtherUserFollowController(bookmarkedUser: user),
                        tag: user.userId.toString());
                    Get.toNamed(Routes.OTHER_USER_FOLLOW,
                        arguments: user.userId.toString());
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    comment.replyFromName,
                    style: TextStyle(fontSize: 12),
                  ),
                  Container(
                    width: comment.parentId == 0 ? 235.w : 210.w,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: commentContentDisplay(comment),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                        width: 5.w,
                      ),
                      commentPlatform(comment.platform),
                      commentLikeButton(comment),
                      GestureDetector(
                        child: Text(
                          TextZhCommentCell.reply,
                          strutStyle: StrutStyle(
                            fontSize: 12,
                            height: ScreenUtil().setWidth(1.3),
                          ),
                          style:
                              TextStyle(color: Colors.blue[600], fontSize: 12),
                        ),
                        onTap: () {
                          Get.find<CommentTextFiledController>(
                                  tag: illustId ??
                                      controller.comment!.value.id.toString())
                              .replyOther(comment);
                        },
                      )
                    ],
                  )
                ],
              )
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
        style: TextStyle(fontSize: 13),
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
