import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:sharemoe/ui/page/center/center_page.dart';
import 'package:sharemoe/ui/page/flow/flow_page.dart';
import 'package:sharemoe/ui/page/new/new_page.dart';
import 'package:sharemoe/ui/page/user/user_page.dart';

class HomePageController extends GetxController {
  FlowPage shareMoePage;
  CenterPage centerPage;
  NewPage newPage;
  UserPage userPage;
  PageController pageController = PageController(initialPage: 0);

  final ScreenUtil screen = ScreenUtil();

  final pageIndex = Rx<int>(0);
  final navIconList = Rx<List<String>>(['', '', '', '']);
  final navBarBottom = Rx<double>(0.0);
  final navBarLeft = Rx<double>(0.0);
  final navBarRight = Rx<double>(0.0);

  @override
  void onInit() {
    shareMoePage = FlowPage();
    centerPage = CenterPage();
    newPage = NewPage();
    userPage = UserPage();
    navBarBottom.value = screen.setHeight(25.0);
    navBarLeft.value = screen.setWidth(54.0);
    navBarRight.value = screen.setWidth(54.0);
    super.onInit();
  }

  Widget getPageByIndex(int index) {
    switch (index) {
      case 0:
        return shareMoePage;
      case 1:
        return centerPage;
      case 2:
        return newPage;
      case 3:
        return userPage;
      default:
        return shareMoePage;
    }
  }
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
