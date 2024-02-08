// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sharemoe/controller/theme_controller.dart';

// Project imports:
import 'package:sharemoe/controller/user/type_controller.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class TypePage extends GetView<TypeController> {
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
            typeCell('user_review', '评论回复', 0),
            typeCell('user_thumb', '收到的赞', 1),
            typeCell('user_collect', '收藏', 2),
            typeCell('user_follow', '关注', 3),
          ],
        ),
      ),
    );
  }

  Widget typeCell(String iconName, String text, int index) {
    return InkWell(
      onTap: () {
        if (text == '评论回复')
          Get.toNamed(Routes.USER_MESSAGE, arguments: 'comment');
        else if (text == '收到的赞')
          Get.toNamed(Routes.USER_MESSAGE, arguments: 'thumb');
      },
      child: Container(
        width: 50.w,
        alignment: Alignment.center,
        // color: Colors.red,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SvgPicture.asset('assets/icon/$iconName.svg',
                    // height: 25.h,
                    width: 25.w,
                    colorFilter: ColorFilter.mode(
                        Get.isDarkMode
                            ? Color(0xff1C1B1F).withOpacity(0.4)
                            : Colors.white,
                        Get.isDarkMode
                            ? BlendMode.srcATop
                            : BlendMode.modulate)),
                Text(text)
              ],
            ),
            Positioned(
                top: 1,
                right: 3,
                child: GetBuilder<TypeController>(
                    id: 'TotalUnReade',
                    builder: (_) {
                      return _.unReadNumberList[index] == 0
                          ? SizedBox()
                          : Container(
                              alignment: Alignment.center,
                              height: 16.w,
                              width: 16.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Text(
                                _.unReadNumberList[index].toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                    }))
          ],
        ),
      ),
    );
  }
}
