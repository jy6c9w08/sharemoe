import 'package:flutter/material.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: SappBar.normal(title: '消息中心',),
      body: Container(
        height: 70.h,
        padding: EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            messageCell('user_review','评论回复'),
            messageCell('user_thumb','收到的赞'),
            messageCell('user_collect','收藏'),
            messageCell('user_follow','关注'),
          ],
        ),
      ),
    );
  }

  Widget messageCell(String iconName,String text){
    return InkWell(
      onTap: () {
        if (iconName == 'msg') {
          Get.toNamed(Routes.USER_MESSAGE);
        } else if (iconName == 'setting') Get.toNamed(Routes.USER_SETTING);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgPicture.asset(
            'icon/$iconName.svg',
            height: 25.h,
          ),
          Text(text)
        ],
      ),
    );
  }

}
