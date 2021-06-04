import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharemoe/basic/pic_texts.dart';
import 'package:sharemoe/controller/global_controller.dart';

import 'package:sharemoe/ui/page/center/center_page.dart';
import 'package:sharemoe/ui/page/login/login_page.dart';
import 'package:sharemoe/ui/page/new/new_page.dart';
import 'package:sharemoe/ui/page/pic/pic_page.dart';
import 'package:sharemoe/ui/page/user/user_page.dart';

class HomePageController extends GetxController {
  late PicPage picPage;
  late CenterPage centerPage;
  late NewPage newPage;
  late UserPage userPage;
  late LoginPage loginPage;
  PageController pageController = PageController(initialPage: 0);

  final ScreenUtil screen = ScreenUtil();

  final pageIndex = Rx<int>(0);
  final navIconList = Rx<List<String>>(['', '', '', '']);
  final navBarBottom = Rx<double>(0.0);
  final navBarLeft = Rx<double>(0.0);
  final navBarRight = Rx<double>(0.0);

  @override
  void onInit() {
    picPage = PicPage(model:PicModel.HOME);
    centerPage = CenterPage();
    newPage = NewPage();
    userPage = UserPage();
    loginPage = LoginPage();
    navBarBottom.value = screen.setHeight(25.0);
    navBarLeft.value = screen.setWidth(54.0);
    navBarRight.value = screen.setWidth(54.0);
    super.onInit();
  }

  Widget getPageByIndex(int index) {
    switch (index) {
      case 0:
        return picPage;
      case 1:
        return centerPage;
      case 2:
        return GetX<GlobalController>(
          builder: (_) {
            return _.isLogin.value ? newPage : loginPage;
          },
        );
      case 3:
        return GetX<GlobalController>(
          builder: (_) {
            return _.isLogin.value ? userPage : loginPage;
          },
        );
      default:
        return picPage;
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
