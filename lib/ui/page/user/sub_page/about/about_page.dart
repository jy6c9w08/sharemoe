// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/controller/global_controller.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class AboutPage extends StatelessWidget {
  AboutPage({Key? key}) : super(key: key);
  final TextStyle textStyleNormal =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w300);
  final TextStyle textStyleButton =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w900);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.normal(title: '关于我们'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
            child: Image.asset(
              'assets/icon/icon.png',
              width: 130.w,
              height: 130.w,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(7)),
            child: Text(
              TextZhForAboutPage.versionInfo,
              style: textStyleNormal,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(7)),
            child: Text(
              TextZhForAboutPage.updateTitle,
              style: textStyleNormal,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(17)),
            child: Text(
              TextZhForAboutPage.updateInfo,
              style: textStyleNormal,
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(100)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  linkButton(
                    TextZhForAboutPage.checkUpdate,
                  ),
                ],
              )),
        ],
      ).backgroundColor(Colors.white),
    );
  }

  Widget linkButton(String title) {
    return TextButton(
        onPressed: () {
          Get.find<GlobalController>().checkVersion(true);
        },
        child: Text(title).fontSize(20));
  }
}
