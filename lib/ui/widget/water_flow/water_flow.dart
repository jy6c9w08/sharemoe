import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/controller/collection/collection_selector_controller.dart';
import 'package:sharemoe/ui/page/collection/collection_selector_bar.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:sharemoe/ui/widget/water_flow/image_cell.dart';
import 'package:sharemoe/ui/widget/loading_box.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';

class WaterFlow extends StatelessWidget {
  final String model;
  final String searchWords;
  final num relatedId;
  final Widget topWidget;
  final String userId;
  final bool isManga;
  final int artistId;
  final int collectionId;
  final ScreenUtil screen = ScreenUtil();

  WaterFlow(
      {Key key,
      this.model,
      this.searchWords,
      this.relatedId,
      this.topWidget,
      this.userId,
      this.isManga,
      this.artistId,
      this.collectionId})
      : super(key: key);

  WaterFlow.home(
      {Key key,
      this.model = 'home',
      this.searchWords,
      this.relatedId,
      this.topWidget,
      this.userId,
      this.isManga,
      this.artistId,
      this.collectionId})
      : super(key: key);

  WaterFlow.search(
      {Key key,
      this.model = 'search',
      this.searchWords,
      this.relatedId,
      this.topWidget,
      this.userId,
      this.isManga,
      this.artistId,
      this.collectionId})
      : super(key: key);

  WaterFlow.related(
      {Key key,
      this.model = 'related',
      this.searchWords,
      this.relatedId,
      this.topWidget,
      this.userId,
      this.isManga,
      this.artistId,
      this.collectionId})
      : super(key: key);

  WaterFlow.bookmark(
      {Key key,
      this.model = 'bookmark',
      this.searchWords,
      this.relatedId,
      this.topWidget,
      this.userId,
      this.isManga,
      this.artistId,
      this.collectionId})
      : super(key: key);

  WaterFlow.artist(
      {Key key,
      this.model = 'artist',
      this.searchWords,
      this.relatedId,
      this.topWidget,
      this.userId,
      this.isManga,
      this.artistId,
      this.collectionId})
      : super(key: key);

  WaterFlow.history(
      {Key key,
      this.model = 'history',
      this.searchWords,
      this.relatedId,
      this.topWidget,
      this.userId,
      this.isManga,
      this.artistId,
      this.collectionId})
      : super(key: key);

  WaterFlow.oldHistory(
      {Key key,
      this.model = 'oldHistory',
      this.searchWords,
      this.relatedId,
      this.topWidget,
      this.userId,
      this.isManga,
      this.artistId,
      this.collectionId})
      : super(key: key);

  WaterFlow.update(
      {Key key,
      this.model = 'update',
      this.searchWords,
      this.relatedId,
      this.topWidget,
      this.userId,
      this.isManga,
      this.artistId,
      this.collectionId})
      : super(key: key);

  WaterFlow.collection(
      {Key key,
      this.model = 'collection',
      this.searchWords,
      this.relatedId,
      this.topWidget,
      this.userId,
      this.isManga,
      this.artistId,
      this.collectionId})
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
                    isManga: this.isManga,
                    artistId: this.artistId,
                    collectionId: this.collectionId),
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
                  GetBuilder<CollectionSelectorCollector>(
                      builder: (controller) {
                    return CollectionSelectionBar();
                  }),
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
                              tag: _.illustList.value[index].id.toString(),
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
