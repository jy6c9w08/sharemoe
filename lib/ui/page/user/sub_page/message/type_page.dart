import 'package:flutter/material.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TypePage extends StatelessWidget {
  const TypePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.normal(
        title: '消息中心',
      ),
      body: Container(
        height: 70.h,
        padding: EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            typeCell('user_review', '评论回复'),
            typeCell('user_thumb', '收到的赞'),
            typeCell('user_collect', '收藏'),
            typeCell('user_follow', '关注'),
          ],
        ),
      ),
    );
  }

  Widget typeCell(String iconName, String text) {
    return InkWell(
      onTap: () {
        if (text == '评论回复')
          Get.toNamed(Routes.USER_MESSAGE, arguments: 'comment');
        else if (text == '收到的赞')
          Get.toNamed(Routes.USER_MESSAGE, arguments: 'thumb');
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
