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
  final int artistId;
  final bool showAppbar;

  TabView(
      {Key key,
      this.firstView,
      this.secondView,
      this.title = '',
      this.model,
      this.artistId,
      this.showAppbar})
      : super(key: key);

  TabView.artist(
      {Key key,
      this.firstView,
      this.secondView,
      this.title,
      this.model = 'artist',
      this.artistId,
      this.showAppbar = false})
      : super(key: key);

  TabView.bookmark(
      {Key key,
      this.firstView = '插画',
      this.secondView = '漫画',
      this.title = '我的收藏',
      this.model = 'bookmark',
      this.artistId,
      this.showAppbar = true})
      : super(key: key);

  TabView.search(
      {Key key,
      this.firstView,
      this.secondView,
      this.title = '',
      this.model = 'search',
      this.artistId,
      this.showAppbar = false})
      : super(key: key);

  TabView.history(
      {Key key,
      this.firstView = '近期',
      this.secondView = '更早',
      this.title = '历史记录',
      this.model = 'history',
      this.artistId,
      this.showAppbar = true})
      : super(key: key);

  TabView.update(
      {Key key,
      this.firstView = '插画',
      this.secondView = '漫画',
      this.title = '画师更新',
      this.model = 'update',
      this.artistId,
      this.showAppbar = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppbar
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
      child: Column(
        // physics: NeverScrollableScrollPhysics(),
        // shrinkWrap: true,
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
      case 'artist':
        return [
          WaterFlow.artist(
            artistId: artistId,
            isManga: false,
          ),
          WaterFlow.artist(
            artistId: artistId,
            isManga: true,
          ),
        ];
      case 'search':
        return [
          WaterFlow.search(
              searchWords: Get.find<SearchController>().searchKeywords),
          ArtistListPage.search()
        ];
      case 'history':
        return [
          WaterFlow.history(userId: picBox.get('id').toString()),
          WaterFlow.oldHistory(userId: picBox.get('id').toString()),
        ];
      case 'update':
        return [
          WaterFlow.update(
            userId: picBox.get('id').toString(),
            isManga: false,
          ),
          WaterFlow.update(
            userId: picBox.get('id').toString(),
            isManga: true,
          ),
        ];
      default:
        return [];
    }
  }
}
