import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/controller/sapp_bar_controller.dart';

class HomeBottomSheet extends StatelessWidget {
  final ScreenUtil screen = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screen.setHeight(110),
      width: screen.setWidth(324),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              height: ScreenUtil().setHeight(27),
              width: ScreenUtil().setWidth(324),
              child: TabBar(
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  labelColor: Colors.orange[300],
                  unselectedLabelColor: Colors.blueGrey,
                  tabs: [
                    Tab(
                      child: Text(
                        '综合',
                      ),
                    ),
                    Tab(
                      child: Text(
                        '漫画',
                      ),
                    )
                  ]),
            ),
            Expanded(
              child: TabBarView(children: <Widget>[
                selectorContainer('illust'),
                selectorContainer('manga')
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget selectorContainer(String type) {
    if (type == 'illust') {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                optionButton('日排行', 'day'),
                optionButton('周排行', 'week'),
                optionButton('月排行', 'month'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                optionButton('男性日排行', 'male'),
                optionButton('女性日排行', 'female'),
              ],
            )
          ],
        ),
      );
    } else if (type == 'manga') {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                optionButton('日排行', 'day_manga'),
                optionButton('周排行', 'week_manga'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                optionButton('月排行', 'month_manga'),
                optionButton('新秀周排行', 'week_rookie_manga'),
              ],
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget optionButton(String label, String parameter) {
    return Container(
      padding:
          EdgeInsets.only(left: screen.setWidth(3), right: screen.setWidth(3)),
      child: ButtonTheme(
        height: screen.setHeight(20),
        minWidth: screen.setWidth(2),
        buttonColor: Colors.grey[100],
        splashColor: Colors.grey[100],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
        child: OutlinedButton(
          onPressed: () {
            //更新appbar
            Get.find<SappBarController>().title.value = label;
            //更新illustList
            WaterFlowController flowController = Get.find<WaterFlowController>(tag: 'home');
            if (flowController.rankModel != parameter) {
              flowController.refreshIllustList(rankModel: parameter);
            }
            Get.back();
          },
          child: Text(label),
        ),
      ),
    );
  }
}
