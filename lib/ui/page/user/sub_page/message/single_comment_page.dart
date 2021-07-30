import 'package:flutter/material.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/controller/comment_controller.dart';
import 'package:sharemoe/controller/image_controller.dart';
import 'package:sharemoe/controller/user/message_controller.dart';
import 'package:sharemoe/data/repository/illust_repository.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/page/comment/comment_base_cell.dart';
import 'package:sharemoe/ui/page/comment/comment_textfile_bar.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SingleCommentPage extends GetView<CommentController> {
  SingleCommentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.normal(
        title: '评论',
      ),
      body: GetBuilder<CommentController>(
          id: 'singleComment',
          builder: (_) {
            return GestureDetector(
              onTap: () {
                //键盘移除焦点
                FocusScope.of(context).requestFocus(FocusNode());
                // memeBox 移除焦点
                if (controller.isMemeMode.value)
                  controller.isMemeMode.value = !controller.isMemeMode.value;
              },
              child: Container(
                height: 1.sh,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        getIt<IllustRepository>()
                            .querySearchIllustById(_.comment!.appId)
                            .then((value) {
                          Get.put<ImageController>(
                              ImageController(illust: value),
                              tag: value.id.toString() + 'true');
                          Get.toNamed(Routes.DETAIL,
                              arguments: value.id.toString());
                        });
                      },
                      child: Text('进入详情页'),
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.red),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 14)),
                          side: MaterialStateProperty.all(
                              BorderSide(color: Colors.red, width: 1)),
                          minimumSize:
                              MaterialStateProperty.all(Size(0.7.sw, 20.h)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                    ),
                    _.comment == null
                        ? Center(child: Text('加载中'))
                        : Flexible(
                            child: GetBuilder<CommentController>(builder: (_) {
                              return CommentCell(comment: _.comment!);
                            }),
                          ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: CommentTextFileBar(
                          isReply: false,
                        ))
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget bottomCommentBar() {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 5.h, left: 5.h, right: 5.h),
      width: 324.h,
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
              child: GetX<CommentController>(builder: (_) {
                return TextField(
                  focusNode: controller.replyFocus,
                  controller: controller.textEditingController,
                  autofocus: true,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: controller.hintText.value,
                      hintStyle: TextStyle(fontSize: 14),
                      contentPadding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(8),
                          bottom: ScreenUtil().setHeight(9))),
                );
              })),
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
