// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/controller/comment/comment_controller.dart';
import 'package:sharemoe/controller/comment/comment_text_filed_controller.dart';
import 'package:sharemoe/controller/image_controller.dart';
import 'package:sharemoe/data/repository/illust_repository.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/page/comment/comment_base_cell.dart';
import 'package:sharemoe/ui/page/comment/comment_textfile_bar.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:sharemoe/ui/widget/state_box.dart';

class SingleCommentPage extends GetView<CommentController> {
  SingleCommentPage(this.tag, {Key? key}) : super(key: key);
  @override
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: SappBar.normal(
        title: '评论',
      ),
      body: GetBuilder<CommentController>(
          tag: tag,
          id: 'finish',
          builder: (_) {
            return GestureDetector(
              onTap: () {
                Get.find<CommentTextFiledController>(tag: tag)
                  ..replyFocus.unfocus()
                  ..toastMeme();
              },
              child: _.comment == null
                  ? LoadingBox()
                  : Stack(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                getIt<IllustRepository>()
                                    .querySearchIllustById(
                                        _.comment!.value.appId)
                                    .then((value) {
                                  Get.put<ImageController>(
                                      ImageController(illust: value),
                                      tag: value.id.toString() + 'true'
                                     );
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
                                  minimumSize: MaterialStateProperty.all(
                                      Size(0.7.sw, 20.h)),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white)),
                            ),
                            Flexible(
                              child: GetBuilder<CommentController>(
                                  tag: tag,
                                  builder: (_) {
                                    // Get.find<CommentController>(tag: tag).appId=_.comment!.value.appId;
                                    // Get.put(CommentController(comment:Rx<Comment>( _.comment!.value), singleComment: true),tag:_.comment!.value.id.toString() );
                                    return CommentCell(
                                      tag: _.comment!.value.id.toString(),
                                      appId: _.comment!.value.appId,
                                    );
                                  }),
                            ),
                            SizedBox(height: 35.h)
                          ],
                        ),
                        CommentTextFileBar(
                          tag: tag,
                          isReply: false,
                          appId: _.comment!.value.appId,
                        )
                      ],
                    ),
            );
          }),
    );
  }
}
