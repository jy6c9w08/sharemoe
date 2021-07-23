import 'package:flutter/material.dart';
import 'package:sharemoe/controller/global_controller.dart';
import 'package:sharemoe/controller/home_controller.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:sharemoe/ui/widget/tab_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.normal(
        title: '画师更新',
      ),
      body: GetX<GlobalController>(
        builder: (_) {
          return _.isLogin.value ? TabView.update() : needLogin();
        },
      ),
    );
  }

  Widget needLogin() {
    return Container(
      color: Colors.white,
      width: 1.sw,
      height: 1.sh,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(top:0.1.sh,child: Image.asset('image/need_login.gif',width: 0.5.sw,)),
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
                Get.find<HomePageController>().pageController.animateToPage(3,
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
    );
  }
}
