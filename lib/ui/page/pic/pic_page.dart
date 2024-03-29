// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/controller/pic_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/ui/page/search/suggestion_bar.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:sharemoe/ui/widget/water_flow/water_flow.dart';

class PicPage extends StatefulWidget {
  final Widget? topWidget;
  final String model;
  final bool permanent;

  PicPage(
      {Key? key, this.topWidget, required this.model, this.permanent = false})
      : super(key: key);

  PicPage.home(
      {Key? key,
      this.topWidget,
      this.model = PicModel.HOME,
      this.permanent = true})
      : super(key: key);

  PicPage.search(
      {Key? key,
      this.topWidget,
      this.model = PicModel.SEARCH,
      this.permanent = false})
      : super(key: key);

  PicPage.related(
      {Key? key, this.topWidget, required this.model, this.permanent = false})
      : super(key: key);

  PicPage.bookmarkIllust(
      {Key? key, this.topWidget, required this.model, this.permanent = false})
      : super(key: key);

  PicPage.bookmarkMaga(
      {Key? key, this.topWidget, required this.model, this.permanent = false})
      : super(key: key);

  PicPage.artistIllust(
      {Key? key, this.topWidget, required this.model, this.permanent = false})
      : super(key: key);

  PicPage.artistMaga(
      {Key? key, this.topWidget, required this.model, this.permanent = false})
      : super(key: key);

  PicPage.history(
      {Key? key,
      this.topWidget,
      this.model = PicModel.HISTORY,
      this.permanent = false})
      : super(key: key);

  PicPage.oldHistory(
      {Key? key,
      this.topWidget,
      this.model = PicModel.OLD_HISTORY,
      this.permanent = false})
      : super(key: key);

  PicPage.updateIllust(
      {Key? key, this.topWidget, required this.model, this.permanent = true})
      : super(key: key);

  PicPage.updateMaga(
      {Key? key, this.topWidget, required this.model, this.permanent = true})
      : super(key: key);

  PicPage.collection(
      {Key? key,
      this.topWidget,
      this.model = PicModel.COLLECTION,
      this.permanent = false})
      : super(key: key);

  PicPage.recommend(
      {Key? key,
      this.topWidget,
      this.model = PicModel.RECOMMEND,
      this.permanent = true})
      : super(key: key);

  PicPage.similar(
      {Key? key, this.topWidget, required this.model, this.permanent = false})
      : super(key: key);

  @override
  _PicPageState createState() => _PicPageState();
}

class _PicPageState extends State<PicPage> with AutomaticKeepAliveClientMixin {
  final ScreenUtil screen = ScreenUtil();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: widget.model == 'home' ? SappBar.home() : null,
        body: GetBuilder<PicController>(
            tag: widget.model,
            init: PicController(),
            builder: (_) {
              return CustomScrollView(
                physics: ClampingScrollPhysics(),
                controller: widget.model == 'home' ||
                        widget.model == 'recommend' ||
                        widget.model.contains('update') ||
                        widget.model.contains('search')
                    ? _.scrollController
                    : null,
                slivers: [
                  SliverToBoxAdapter(
                    child: widget.topWidget,
                  ),
                  // SliverAppBar()
                  widget.model.contains('search')
                      ? SuggestionBar(
                          widget.model,
                        )
                      : SliverToBoxAdapter(),
                  WaterFlow(
                    tag: widget.model,
                    permanent: widget.permanent,
                  )
                ],
              );
            }),
        floatingActionButton: widget.model == 'recommend'
            ? FloatingActionButton(
                onPressed: () {
                  Get.find<WaterFlowController>(tag: 'recommend')
                      .refreshIllustList();
                },
                child: Icon(Icons.refresh),
                backgroundColor: Colors.orange[400],
              )
            : Container(),
        floatingActionButtonLocation: CustomFloatingActionButtonLocation(
            FloatingActionButtonLocation.endFloat, 0, -60.h));
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
