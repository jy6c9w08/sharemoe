import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sharemoe/controller/home_controller.dart';

class NeedLoginPage extends StatelessWidget {
  const NeedLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
      color: Colors.white,
      width: 1.sw,
      height: 1.sh,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
              top: 0.1.sh,
              child: Image.asset(
                'image/need_login.gif',
                width: 0.5.sw,
              )),
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
      ),
    ));
  }
}
