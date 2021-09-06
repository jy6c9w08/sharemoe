import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/controller/discussion_controller.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
                  WebView(
                    initialUrl: PicExternalLinkLink.DISCUSS,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (webController) {
                      controller.webViewController = webController;
                      // Map<String, String> headers = {"authorization": UserService.token!};
                      // webController.loadUrl(PicExternalLinkLink.DISCUSS, headers: headers);
                    },
                    onPageStarted: (value) {
                      print(value);
                    },
                    onPageFinished: (value) {
                      controller.finish.value = true;
                      String authorization =
                          "authorization = ${UserService.token}";
                      controller.webViewController.evaluateJavascript(authorization);

                    },
                  ),
                  controller.finish.value
                      ? SizedBox()
                      : Center(
                          child: CircularProgressIndicator(),
                        )
                ],
              );
            })

        // Builder(
        //   builder: (BuildContext context) {
        //     return
        //   },
        // ),
        );
  }
}
