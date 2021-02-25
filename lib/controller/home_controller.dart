import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:sharemoe/ui/page/center/center_page.dart';
import 'package:sharemoe/ui/page/new/new_page.dart';
import 'package:sharemoe/ui/page/sharemoe/sharemoe_page.dart';
import 'package:sharemoe/ui/page/user/user_page.dart';
class PageViewController extends GetxController{
 ShareMoePage shareMoePage;
 CenterPage centerPage;
 NewPage newPage;
 UserPage userPage;
 PageController pageController = PageController(initialPage: 0);


 final pageIndex =Rx<int>();

@override
  void onInit() {
      shareMoePage=ShareMoePage();
      centerPage=CenterPage();
      newPage=NewPage();
      userPage=UserPage();
    super.onInit();
  }


  Widget getPageByIndex(){
    switch (pageIndex.value) {
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

}


