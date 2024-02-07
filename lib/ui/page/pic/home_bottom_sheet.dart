// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/controller/sapp_bar_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';

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
                  // labelColor: Colors.orange[300],
                  // unselectedLabelColor: Colors.blueGrey,
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
      child: OutlinedButton(
        onPressed: () {
          //更新appbar
          Get.find<SappBarController>(tag:PicModel.HOME).title.value = label;
          //更新illustList
          WaterFlowController flowController = Get.find<WaterFlowController>(tag: 'home');
          if (flowController.rankModel != parameter) {
            flowController.refreshIllustList(rankModel: parameter);
          }
          Get.back();
        },
        style: ButtonStyle(
          // foregroundColor: MaterialStateProperty.all(Colors.red),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.r))),
        ),
        child: Text(label,style: Theme.of(Get.context!).textTheme.labelLarge),
      ),
    );
  }
}
