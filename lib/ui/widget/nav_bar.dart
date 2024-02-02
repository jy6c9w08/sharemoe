// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/controller/global_controller.dart';
import 'package:sharemoe/controller/home_controller.dart';

class NavBar extends GetView<HomePageController> {
  final ScreenUtil screen = ScreenUtil();
  static final UserService userService = getIt<UserService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screen.setWidth(250),
      height: screen.setWidth(50),
      // 以宽度为参考以保证不同尺寸下大小相同,38/42
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screen.setWidth(25)),
        boxShadow: [
          BoxShadow(
              blurRadius: 13, offset: Offset(5, 5), color: Color(0x73D1D9E6)),
          BoxShadow(
              blurRadius: 18, offset: Offset(-5, -5), color: Color(0x73E0E0E0)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          navItem('pic', 0),
          navItem('recommend', 1),
          navItem('center', 2),
          navItem('new', 3),
          navItem('user', 4),
        ],
      ),
    );
  }

  Widget navItem(String src, int seq) {
    double width;
    return GetX<HomePageController>(builder: (_) {
      if (_.pageIndex.value == seq) {
        width = screen.setWidth(27);
        _.navIconList.value[seq] = 'assets/icon/' + src + '_active.svg';
      } else {
        width = screen.setWidth(24);
        _.navIconList.value[seq] = 'assets/icon/' + src + '.svg';
      }
      return AnimatedContainer(
          alignment: Alignment.center,
          width: width,
          height: width,
          duration: Duration(milliseconds: 400),
          child: GestureDetector(onTap: () {
            _.pageController.animateToPage(seq,
                duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          }, child: GetX<GlobalController>(builder: (controller) {
            return controller.isLogin.value && seq == 4
                ? ShaderMask(
                    shaderCallback: _.pageIndex.value == seq
                        ? (bounds) =>
                            LinearGradient(colors: [Colors.white, Colors.white])
                                .createShader(bounds)
                        : (bounds) => LinearGradient(colors: [
                              Colors.grey.shade500,
                              Colors.grey.shade500
                            ]).createShader(bounds),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: screen.setHeight(25),
                      backgroundImage: ExtendedNetworkImageProvider(
                          userService.userInfo()!.avatar +
                              '?t=${Get.find<GlobalController>().time}',
                          cache: false),
                    ),
                  )
                : SvgPicture.asset(_.navIconList.value[seq],
                    height: width, width: width);
          })));
    });
  }
}
