import 'package:flutter/material.dart';
import 'package:sharemoe/controller/collection/collection_selector_controller.dart';
import 'package:sharemoe/controller/pic_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharemoe/ui/page/collection/collection_selector_bar.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:get/get.dart';

import '../../widget/water_flow/water_flow.dart';

class PicPage extends StatefulWidget {
  final Widget? topWidget;
  final String tag;

  PicPage({Key? key, this.topWidget, required this.tag}) : super(key: key);

  PicPage.home({Key? key, this.topWidget, this.tag = 'home'}) : super(key: key);

  PicPage.search({Key? key, this.topWidget, this.tag = 'search'})
      : super(key: key);

  PicPage.related({Key? key, this.topWidget, required this.tag})
      : super(key: key);

  PicPage.bookmark({Key? key, this.topWidget, required this.tag})
      : super(key: key);

  PicPage.artist({Key? key, this.topWidget, required this.tag})
      : super(key: key);

  PicPage.history({Key? key, this.topWidget, this.tag = 'history'})
      : super(key: key);

  PicPage.oldHistory({Key? key, this.topWidget, this.tag = 'oldHistory'})
      : super(key: key);

  PicPage.update({Key? key, this.topWidget, required this.tag})
      : super(key: key);

  PicPage.collection({Key? key, this.topWidget, this.tag = 'collection'})
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
      appBar: widget.tag == 'home' ? SappBar.home() : null,
      body: GetBuilder<PicController>(
        tag: widget.tag,
        init: Get.put(PicController(model: widget.tag),tag: widget.tag),
        builder: (_) {
          return CustomScrollView(
            controller: _.scrollController,
            slivers: [
              GetBuilder<CollectionSelectorCollector>(builder: (_) {
                return CollectionSelectionBar();
              }),
              SliverToBoxAdapter(
                child: widget.topWidget,
              ),
              WaterFlow(tag: widget.tag)
            ],
          );
        }
      ),
    );
  }
}
