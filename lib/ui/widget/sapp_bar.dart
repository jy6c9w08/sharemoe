import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:sharemoe/controller/flow_controller.dart';
import 'package:sharemoe/controller/sapp_bar_controller.dart';
import 'package:sharemoe/ui/page/flow/home_bottom_sheet.dart';

class SappBar extends StatelessWidget implements PreferredSizeWidget {
  final ScreenUtil screen = ScreenUtil();
  final String title;
  final String model;
  final DateTime _picFirstDate = DateTime(2008, 1, 1);
  final DateTime _picLastDate = DateTime.now().subtract(Duration(hours: 39));

  SappBar({this.title, this.model = 'default'});

  SappBar.home({this.title, this.model = 'home'}) : super();

  @override
  Size get preferredSize => Size.fromHeight(screen.setHeight(77));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                  blurRadius: 13,
                  offset: Offset(5, 5),
                  color: Color(0x73E5E5E5)),
            ],
          ),
          child: chooseAppBar(),
        ));
  }

  Widget chooseAppBar() {
    switch (model) {
      case 'home':
        return homeAppBar();
      case 'default':
        return defaultAppBar();
      default:
        return homeAppBar();
    }
  }

  Widget homeAppBar() {
    return GetX<SappBarController>(
        init: SappBarController(),
        builder: (_) {
          return Container(
              height: screen.setHeight(35),
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(18),
                  right: ScreenUtil().setWidth(18)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: screen.setHeight(35),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(right: 8), //为点击时的效果而设置，无实际意义
                        child: FaIcon(
                          FontAwesomeIcons.search,
                          color: Color(0xFF515151),
                          size: ScreenUtil().setWidth(15),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        Get.bottomSheet(HomeBottomSheet(),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)));
                      },
                      child: Container(
                        height: screen.setHeight(35),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Text(_.title.value,
                            style: TextStyle(
                                fontSize: 14,
                                // color: Color(0xFF515151),
                                color: Colors.orange[400],
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () async {
                        FlowController flowController =
                            Get.find<FlowController>();
                        DateTime newDate = await showDatePicker(
                          context: Get.context,
                          initialDate: flowController.picDate,
                          firstDate: _picFirstDate,
                          lastDate: _picLastDate,
                          // locale: Locale('zh'),
                        );
                        if (newDate != null &&
                            flowController.picDate != newDate) {
                          flowController.refreshIllustList(picDate: newDate);
                        }
                      },
                      child: Container(
                        height: screen.setHeight(35),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 8),
                        child: FaIcon(
                          FontAwesomeIcons.calendarAlt,
                          color: Color(0xFF515151),
                          size: ScreenUtil().setWidth(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
        });
  }

  Widget defaultAppBar() {
    return Container(
        height: screen.setHeight(35),
        alignment: Alignment.center,
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(18), right: ScreenUtil().setWidth(18)),
        child: Text(title,
            style: TextStyle(
                fontSize: 14,
                color: Color(0xFF515151),
                fontWeight: FontWeight.w700)));
  }
}
