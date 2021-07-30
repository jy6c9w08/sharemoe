import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharemoe/controller/comment_controller.dart';
import 'package:sharemoe/data/model/comment.dart';
import 'package:intl/intl.dart';

class CommentCell extends GetView<CommentController> {
  CommentCell({
    Key? key,
    required this.comment,
    this.tag,
  }) : super(key: key);
  final Comment comment;
  @override
  final String? tag;

  @override
  Widget build(BuildContext context) {
    bool hasSub = comment.subCommentList == null ? false : true;
    return Container(
      width: 324.w,
      padding: EdgeInsets.only(left: 7.h, right: 7.h, top: 10.h),
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            commentBaseCell(comment),
            hasSub
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: comment.subCommentList!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return commentSubCell(comment.subCommentList![index]);
                    })
                : Container(),
            SizedBox(width: 300.h, child: Divider())
          ],
        ),
      ),
    );
  }

  Widget commentSubCell(Comment commentEachSubData) {
    return Container(
      padding: EdgeInsets.only(left: 25.w, top: 7.h),
      child: commentBaseCell(commentEachSubData),
    );
  }

  Widget commentBaseCell(Comment data, {int? subIndex}) {
    String avaterUrl =
        'https://static.pixivic.net/avatar/299x299/${data.replyFrom}.jpg';

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
                            avaterUrl.replaceAll(
                                'https://i.pximg.net', 'https://acgpic.net'),
                            headers: {'referer': 'https://pixivic.com'})),
                    onTap: () {
                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(builder: (context) {
                      //   return UserDetailPage(data.replyFrom, data.replyFromName);
                      // }));
                    },
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setHeight(5)),
                    Text(
                      data.replyFromName,
                      style: TextStyle(fontSize: 12),
                    ),
                    Container(
                      width: 235.h,
                      alignment: Alignment.centerLeft,
                      child: commentContentDisplay(data),
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
                                .format(DateTime.parse(data.createDate)),
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
                          commentPlatform(data.platform),
                          commentLikeButton(data),
                          // commentLikeButton(context, parentIndex, commentListModel,
                          //     subIndex: subIndex),
                          GestureDetector(
                            child: Text(
                              controller.texts.reply,
                              strutStyle: StrutStyle(
                                fontSize: 12,
                                height: ScreenUtil().setWidth(1.3),
                              ),
                              style: TextStyle(
                                  color: Colors.blue[600], fontSize: 12),
                            ),
                            onTap: () {
                              controller.replyToName = data.replyFromName;
                              controller.replyToId = data.replyFrom;
                              data.parentId == 0
                                  ? controller.replyParentId = data.id
                                  : controller.replyParentId = data.parentId;
                              if (controller.replyFocus.hasFocus)
                                controller.replyFocusListener();
                              else
                                controller.replyFocus.requestFocus();
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
        child: Image(image: AssetImage('image/meme/$memeHead/$memeId.webp')),
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
      // width: ScreenUtil().setWidth(30),
      alignment: Alignment.bottomCenter,
      // height: ScreenUtil().setHeight(8),
      margin: EdgeInsets.only(
        right: ScreenUtil().setWidth(7),
      ),
      child: GestureDetector(
          onTap: () async {
            comment.isLike
                ? controller.cancelLike(comment.id)
                : controller.postLike(comment.id);
            // if (lock) return false;
            // if (!tuple2.item1) {
            //   lock = true;
            //   await commentListModel.likeComment(parentIndex,
            //       subIndex: subIndex);
            //   lock = false;
            // } else {
            //   lock = true;
            //   await commentListModel.unlikeComment(parentIndex,
            //       subIndex: subIndex);
            //   lock = false;
            // }
          },
          child: Row(
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                // color: Colors.red,
                child: Icon(
                  Icons.thumb_up_alt_outlined,
                  color: Colors.grey,
                  size: ScreenUtil().setWidth(13),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(3)),
                child: Text(comment.likedCount.toString(),
                    strutStyle: StrutStyle(
                      fontSize: ScreenUtil().setSp(11),
                      height: ScreenUtil().setWidth(1.3),
                    ),
                    style: TextStyle(
                        color: Colors.grey, fontSize: ScreenUtil().setSp(10))),
              )
            ],
          )),
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
