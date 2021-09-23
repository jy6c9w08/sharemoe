// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/service/upgrade_service.dart';
import 'package:sharemoe/controller/global_controller.dart';
import 'package:sharemoe/data/model/app_info.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class AboutPage extends StatelessWidget {
  AboutPage({Key? key}) : super(key: key);
  final TextStyle textStyleNormal =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w300);
  final TextStyle textStyleButton =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w900);
 static final APPInfo appInfo=getIt<UpgradeService>().appInfo();

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
              'ShareMoe 官方客户端 ${appInfo.version}',
              style: textStyleNormal,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(7)),
            child: Text(
              '${appInfo.version} 更新内容',
              style: textStyleNormal,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 17.h),
            child:
            Html(data: appInfo.updateLog,
              style: {
                "body": Style(
                  fontSize: FontSize(13.sp),
                  fontWeight: FontWeight.w300,
                  width: 200.w,
                ),
              },
              shrinkWrap: true,
            )
            // Text(
            //   TextZhForAboutPage.updateInfo,
            //   style: textStyleNormal,
            // ),
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
