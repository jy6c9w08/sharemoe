// Flutter imports:
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:extended_sliver/extended_sliver.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';

// Project imports:
import 'package:sharemoe/ui/page/artist/artist_list_page.dart';
import 'package:sharemoe/ui/page/pic/pic_page.dart';

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
  final Widget? topWidget;

  TabView(
      {Key? key,
      required this.firstView,
      required this.secondView,
      this.title = '',
      required this.model,
      required this.artistId,
      required this.showAppbar,
      this.searchKeywords,
      this.userId,
      this.topWidget})
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
      this.userId,
      this.topWidget})
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
      required this.userId,
      this.topWidget})
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
      this.userId,
      this.topWidget})
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
      this.userId,
      this.topWidget})
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
      this.userId,
      this.topWidget})
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
      this.userId,
      this.topWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.topCenter,
      child: _tabViewer(),
    );
  }

  Widget _tabViewer() {
    return DefaultTabController(
      length: 2,
      child: ExtendedNestedScrollView(
        onlyOneScrollInBody: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            if (showAppbar)
              ExtendedSliverAppbar(
                toolbarHeight: 0,
                statusbarHeight: 0,
                leading: SizedBox(),
                background: topWidget,
              ),
            SliverPersistentHeader(
              pinned: true,
              delegate: StickyTabBarDelegate(
                child: TabBar(
                  labelColor: Colors.blueAccent[200],
                  tabs: <Widget>[
                    Tab(text: firstView),
                    Tab(text: secondView),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
            physics: model == 'update' || model == 'guessLike'
                ? NeverScrollableScrollPhysics()
                : null,
            children: chooseView()),
      ),
    );
  }

  List<Widget> chooseView() {
    switch (model) {
      case 'bookmark':
        return [
          PicPage.bookmarkIllust(
              model: PicModel.BOOKMARK_ILLUST + userId.toString()),
          PicPage.bookmarkMaga(
              model: PicModel.BOOKMARK_MAGA + userId.toString()),
        ];
      case 'artist':
        return [
          PicPage.artistIllust(
              model: PicModel.ARTIST_ILLUST + artistId.toString()),
          PicPage.artistMaga(model: PicModel.ARTIST_MAGA + artistId.toString()),
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
          PicPage.updateIllust(
            model: PicModel.UPDATE_ILLUST,
          ),
          PicPage.updateMaga(
            model: PicModel.UPDATE_MAGA,
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

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;

  StickyTabBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: this.child,
    );
  }

  @override
  double get maxExtent => this.child.preferredSize.height;

  @override
  double get minExtent => this.child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
