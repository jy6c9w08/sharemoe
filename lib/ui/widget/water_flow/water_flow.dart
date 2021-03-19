import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'package:sharemoe/ui/widget/water_flow/image_cell.dart';
import 'package:sharemoe/ui/widget/loading_box.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';

class WaterFlow extends StatelessWidget {
  final String model;
  final String searchWords;
  final num relatedId;
  final Widget topWidget;
  final String userId;
  final isManga;

  WaterFlow(
      {Key key,
      this.model,
      this.searchWords,
      this.relatedId,
      this.topWidget,
      this.userId,
      this.isManga})
      : super(key: key);

  WaterFlow.home(
      {Key key,
      this.model = 'home',
      this.searchWords,
      this.relatedId,
      this.topWidget,
      this.userId,
      this.isManga})
      : super(key: key);

  WaterFlow.search(
      {Key key,
      this.model = 'search',
      this.searchWords,
      this.relatedId,
      this.topWidget,
      this.userId,
      this.isManga})
      : super(key: key);

  WaterFlow.related(
      {Key key,
      this.model = 'related',
      this.searchWords,
      this.relatedId,
      this.topWidget,
      this.userId,
      this.isManga})
      : super(key: key);

  WaterFlow.bookmark(
      {Key key,
      this.model = 'bookmark',
      this.searchWords,
      this.relatedId,
      this.topWidget,
      this.userId,
      this.isManga})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: GetX<WaterFlowController>(
            init: Get.put<WaterFlowController>(
                WaterFlowController(
                    model: this.model,
                    searchKeyword: searchWords,
                    relatedId: relatedId,
                    userId: this.userId,
                    isManga: this.isManga),
                tag: model == 'related'
                    ? model + relatedId.toString()
                    : isManga == null
                        ? model
                        : model + isManga.toString(),
                permanent: model == 'related' ? true : false),
            tag: model == 'related'
                ? model + relatedId.toString()
                : isManga == null
                    ? model
                    : model + isManga.toString(),
            builder: (_) {
              return CustomScrollView(
                controller: _.scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: topWidget,
                  ),
                  _.illustList.value == null
                      ? SliverToBoxAdapter(child: LoadingBox())
                      : SliverWaterfallFlow(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return ImageCell(
                              illust: _.illustList.value[index],
                            );
                          }, childCount: _.illustList.value.length),
                          gridDelegate:
                              SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 7,
                                  mainAxisSpacing: 7,
                                  viewportBuilder:
                                      (int firstIndex, int lastIndex) {
                                    if (lastIndex ==
                                            _.illustList.value.length - 1 &&
                                        _.loadMore) {
                                      _.loadData();
                                    }
                                  }),
                        )
                ],
              );
            }));
  }
}
