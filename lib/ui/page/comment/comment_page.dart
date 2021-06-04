import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:sharemoe/controller/comment_controller.dart';
import 'package:sharemoe/ui/page/comment/meme_box.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:sharemoe/data/model/comment.dart';
import 'package:sharemoe/basic/pic_texts.dart';

class CommentPage extends GetView<CommentController> {
  final TextZhCommentCell texts = TextZhCommentCell();
  final ScreenUtil screen = ScreenUtil();

  @override
  final String tag;
  final int illustId;
  final int replyToId;
  final String replyToName;
  final int replyParentId;
  final bool isReply;

  CommentPage(
    this.tag, {
    required this.illustId,
    required this.isReply,
    this.replyToId = 0,
    this.replyToName = '',
    this.replyParentId = 0,
  });

  CommentPage.reply(
    this.tag, {
    required this.illustId,
    required this.isReply,
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
            // resizeToAvoidBottomPadding: false,
            appBar: SappBar(
              title: texts.comment,
            ),
            body: GetX<CommentController>(
                tag: illustId.toString(),
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
                        _.commentList.value != null
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
                                      return commentParentCell(
                                        _.commentList.value[index],
                                        index,
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
                              bottomCommentBar(),
                              _.isMemeMode.value
                                  ? MemeBox(illustId.toString(),
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

  // 单条回复
  Widget commentParentCell(
    Comment commentAllData,
    int parentIndex,
  ) {
    bool hasSub = commentAllData.subCommentList == null ? false : true;

    return Container(
        width: screen.setWidth(324),
        child: Container(
          padding: EdgeInsets.only(
              left: screen.setHeight(7),
              right: screen.setHeight(7),
              top: screen.setHeight(10)),
          alignment: Alignment.topLeft,
          child: Column(
            children: <Widget>[
              commentBaseCell(commentAllData, parentIndex),
              hasSub
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: commentAllData.subCommentList!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return commentSubCell(
                            commentAllData.subCommentList![index],
                            parentIndex,
                            index);
                      })
                  : Container(),
              SizedBox(width: screen.setWidth(300), child: Divider())
            ],
          ),
        ));
  }

  // 楼中楼
  Widget commentSubCell(
      Comment commentEachSubData, int parentIndex, int subIndex) {
    return Container(
      padding:
          EdgeInsets.only(left: screen.setWidth(15), top: screen.setHeight(7)),
      child:
          commentBaseCell(commentEachSubData, parentIndex, subIndex: subIndex),
    );
  }

  // 基础的展示条
  Widget commentBaseCell(Comment data, int parentIndex, {int? subIndex}) {
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
                      width: screen.setWidth(235),
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
                          // commentLikeButton(context, parentIndex, commentListModel,
                          //     subIndex: subIndex),
                          GestureDetector(
                            child: Text(
                              texts.reply,
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

  Widget commentLikeButton(BuildContext context, int parentIndex,
      {required int subIndex}) {
    return Container(
      // width: ScreenUtil().setWidth(30),
      alignment: Alignment.bottomCenter,
      // height: ScreenUtil().setHeight(8),
      margin: EdgeInsets.only(
        right: ScreenUtil().setWidth(7),
      ),
      child: GestureDetector(
          onTap: () async {
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
              // tuple2.item2 == 0
              //     ? Container()
              //     : Container(
              //   padding:
              //   EdgeInsets.only(left: ScreenUtil().setWidth(3)),
              //   child: Text('123',
              //       strutStyle: StrutStyle(
              //         fontSize: ScreenUtil().setSp(11),
              //         height: ScreenUtil().setWidth(1.3),
              //       ),
              //       style: TextStyle(
              //           color: Colors.grey,
              //           fontSize: ScreenUtil().setSp(10))),
              // )
            ],
          )),
    );
  }

  Widget commentPlatform(String platform) {
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
