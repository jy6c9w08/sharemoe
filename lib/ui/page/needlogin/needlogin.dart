// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/controller/home_controller.dart';
import 'package:sharemoe/controller/theme_controller.dart';

class NeedLoginPage extends StatelessWidget {
  const NeedLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
    top: 0.1.sh,
    child: GetBuilder<ThemeController>(builder: (_) {
      return ColorFiltered(
        colorFilter: ColorFilter.mode(
          _.isDark
              ? Color.fromARGB(
                  Color(0xff1C1B1F).alpha,
                  255 - Color(0xff1C1B1F).red,
                  255 - Color(0xff1C1B1F).green,
                  255 - Color(0xff1C1B1F).blue,
                )
              : Colors.white,
          // Color(0xff1C1B1F).withOpacity(0.4),
          _.isDark ? BlendMode.difference : BlendMode.modulate,
        ),
        child: Image.asset(
          'assets/image/need_login.gif',
          width: 0.5.sw,
        ),
      );
    })),
          Positioned(
    top: 0.65.sw,
    child: Text(
      "登陆,打开新世界的大门",
      style: TextStyle(color: Colors.grey),
    )),
          Positioned(
            top: 0.8.sw,
            child: MaterialButton(
    color: Colors.blue,
    textColor: Colors.white,
    onPressed: () {
      Get.find<HomePageController>().pageController.animateToPage(4,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut);
    },
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.r))),
    child: Text('前往登陆'),
            ),
          )
        ],
    );
  }
}
