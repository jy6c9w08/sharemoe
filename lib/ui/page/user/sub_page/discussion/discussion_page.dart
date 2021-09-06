import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/controller/discussion_controller.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class DiscussionPage extends GetView<DiscussionController> {
  const DiscussionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SappBar.normal(title: '反馈中心'),
        body: GetX<DiscussionController>(
            init: DiscussionController(),
            builder: (_) {
              return Stack(
                children: [
                  InAppWebView(
                      initialUrlRequest: URLRequest(
                          url: Uri.parse(PicExternalLinkLink.DISCUSS),
                          headers: {"Authorization": UserService.token!}),
                      onLoadStop:
                          (InAppWebViewController webController, value) {
                        controller.finish.value = true;
                      }),
                  controller.finish.value
                      ? SizedBox()
                      : Center(
                          child: CircularProgressIndicator(),
                        )
                ],
              );
            }));
  }
}
