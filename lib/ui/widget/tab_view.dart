import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/controller/search_controller.dart';
import 'package:sharemoe/ui/page/artist/artist_list_page.dart';
import 'package:sharemoe/ui/page/pic/pic_page.dart';
import 'package:get/get.dart';

import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:sharemoe/ui/widget/water_flow/water_flow.dart';

class TabView extends StatelessWidget {
  final ScreenUtil screen = ScreenUtil();
  final title;
  final String firstView;
  final String secondView;
  final String model;

  TabView(
      {Key key, this.firstView, this.secondView, this.title = '', this.model})
      : super(key: key);

  TabView.bookmark(
      {Key key,
      this.firstView,
      this.secondView,
      this.title = '我的收藏',
      this.model = 'bookmark'})
      : super(key: key);

  TabView.search(
      {Key key,
      this.firstView,
      this.secondView,
      this.title = '',
      this.model = 'search'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: model == 'bookmark'
          ? SappBar(
              title: this.title,
            )
          : null,
      body: Container(
        color: Colors.white,
        alignment: Alignment.topCenter,
        child: _tabViewer(),
      ),
    );
  }

  Widget _tabViewer() {
    return DefaultTabController(
      length: 2,
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Material(
              child: Container(
                  height: ScreenUtil().setHeight(30),
                  width: ScreenUtil().setWidth(324),
                  child: TabBar(
                    labelColor: Colors.blueAccent[200],
                    tabs: [
                      Tab(
                        text: firstView,
                      ),
                      Tab(
                        text: secondView,
                      )
                    ],
                  ))),
          Container(
            height: ScreenUtil().setHeight(491),
            width: ScreenUtil().setWidth(324),
            child: TabBarView(children: chooseView()),
          ),
        ],
      ),
    );
  }

  List<Widget> chooseView() {
    switch (model) {
      case 'bookmark':
        return [
          WaterFlow.bookmark(
            userId: picBox.get('id').toString(),
            isManga: false,
          ),
          WaterFlow.bookmark(
            userId: picBox.get('id').toString(),
            isManga: true,
          ),
        ];
      case 'search':
        return [
          WaterFlow.search(
              searchWords: Get.find<SearchController>().searchKeywords),
          ArtistListPage.search()
        ];
      default:
        return [];
    }
  }
}
