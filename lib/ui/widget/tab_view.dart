// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:sharemoe/ui/page/artist/artist_list_page.dart';
import 'package:sharemoe/ui/page/pic/pic_page.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class TabView extends StatelessWidget {
  final ScreenUtil screen = ScreenUtil();
  final title;
  final String firstView;
  final String secondView;
  final String model;
  final int? artistId;
  final bool showAppbar;
  final String? searchKeywords;
  final int? userId;

  TabView(
      {Key? key,
      required this.firstView,
      required this.secondView,
      this.title = '',
      required this.model,
      required this.artistId,
      required this.showAppbar,
      this.searchKeywords,
      this.userId})
      : super(key: key);

  TabView.artist(
      {Key? key,
      required this.firstView,
      required this.secondView,
      this.title,
      this.model = 'artist',
      required this.artistId,
      this.showAppbar = false,
      this.searchKeywords,
      this.userId})
      : super(key: key);

  TabView.bookmark(
      {Key? key,
      this.firstView = '插画',
      this.secondView = '漫画',
      this.title,
      this.model = 'bookmark',
      this.artistId,
      required this.showAppbar,
      this.searchKeywords,
      required this.userId})
      : super(key: key);

  TabView.search(
      {Key? key,
      this.firstView = '插画',
      this.secondView = '画师',
      this.title = '',
      this.model = 'search',
      this.artistId,
      this.showAppbar = false,
      this.searchKeywords,
      this.userId})
      : super(key: key);

  TabView.history(
      {Key? key,
      this.firstView = '近期',
      this.secondView = '更早',
      this.title = '历史记录',
      this.model = 'history',
      this.artistId,
      this.showAppbar = true,
      this.searchKeywords,
      this.userId})
      : super(key: key);

  TabView.update(
      {Key? key,
      this.firstView = '插画',
      this.secondView = '漫画',
      this.title = '画师更新',
      this.model = 'update',
      this.artistId,
      this.showAppbar = false,
      this.searchKeywords,
      this.userId})
      : super(key: key);

  TabView.guessLike(
      {Key? key,
      this.firstView = '插画',
      this.secondView = '画师',
      this.title = '猜你喜欢',
      this.model = 'guessLike',
      this.artistId,
      this.showAppbar = false,
      this.searchKeywords,
      this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: showAppbar
            ? SappBar.normal(
                title: this.title,
              )
            : null,
        body: Container(
          color: Colors.white,
          alignment: Alignment.topCenter,
          child: _tabViewer(),
        ),
        floatingActionButtonLocation: CustomFloatingActionButtonLocation(
            FloatingActionButtonLocation.endFloat, 0, -60.h));
  }

  Widget _tabViewer() {
    return DefaultTabController(
      length: 2,
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
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
            child: TabBarView(
                physics:
                    model == 'update' ? NeverScrollableScrollPhysics() : null,
                children: chooseView()),
          ),
        ],
      ),
    );
  }

  List<Widget> chooseView() {
    switch (model) {
      case 'bookmark':
        return [
          PicPage.bookmark(
            model: 'bookmark${userId}false',
          ),
          PicPage.bookmark(
            model: 'bookmark${userId}true',
          ),
        ];
      case 'artist':
        return [
          PicPage.artist(model: 'artist${artistId}false'),
          PicPage.artist(
            model: 'artist${artistId}true',
          ),
        ];
      case 'guessLike':
        return [
          PicPage.recommend(),
          ArtistListPage.guessLike(
            title: '',
          ),
        ];
      case 'search':
        return [
          PicPage.search(
            model: searchKeywords!,
          ),
          ArtistListPage.search(
            model: searchKeywords!,
            title: '',
          )
        ];
      case 'history':
        return [
          PicPage.history(),
          PicPage.oldHistory(),
        ];
      case 'update':
        return [
          PicPage.update(
            model: 'update_false',
          ),
          PicPage.update(
            model: 'update_true',
          ),
        ];
      default:
        return [];
    }
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX;
  double offsetY;

  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
