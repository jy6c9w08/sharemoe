// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

// Project imports:
import 'package:sharemoe/controller/sapp_bar_controller.dart';
import 'package:sharemoe/controller/search_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/ui/widget/state_box.dart';

class EveryoneSearch extends GetView<SearchController> {
  final ScreenUtil screen = ScreenUtil();

  // final SearchController searchController=Get.find<SearchController>();
  @override
  Widget build(BuildContext context) {
    return GetX<SearchController>(builder: (_) {
      return controller.hotSearchList.value .length==0
          ? LoadingBox()
          : Container(
              height: double.infinity,
              child: WaterfallFlow.builder(
                controller: ScrollController(),
                physics: ClampingScrollPhysics(),
                gridDelegate:
                    SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: controller.hotSearchList.value.length,
                padding: EdgeInsets.only(
                    left: screen.setWidth(1), right: screen.setWidth(1)),
                itemBuilder: (BuildContext context, int index) => _currentCell(
                    controller.hotSearchList.value[index].name,
                    controller.hotSearchList.value[index].translatedName,
                    controller.hotSearchList.value[index].illustration
                        .imageUrls[0].medium,
                    controller
                        .hotSearchList.value[index].illustration.sanityLevel),
                // staggeredTileBuilder: (index) =>
                //     StaggeredTile.fit(1),
                // mainAxisSpacing: 4.0,
                // crossAxisSpacing: 4.0,
              ),
            );
    });
  }

  _currentCell(String jpTitle, String transTitle, String url, int sanityLevel) {
    return Material(
      child: InkWell(
          onTap: () {
            SearchController searchController = Get.find<SearchController>();
            searchController.searchKeywords = jpTitle;
            Get.put(WaterFlowController(model: 'search',searchKeyword: jpTitle),tag: 'search');
            searchController.currentOnLoading.value = false;
            Get.find<SappBarController>().searchTextEditingController.text=jpTitle;
          },
          child: Container(
            alignment: Alignment.topCenter,
            width: ScreenUtil().setWidth(104),
            height: ScreenUtil().setWidth(104),
            padding: EdgeInsets.only(top: ScreenUtil().setWidth(60)),
            margin: EdgeInsets.all(ScreenUtil().setWidth(1)),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter:
                        ColorFilter.mode(Colors.black26, BlendMode.darken),
                    image: ExtendedNetworkImageProvider(
                      url.replaceAll(
                          'https://i.pximg.net', 'https://acgpic.net'),
                      headers: {'Referer': 'https://m.sharemoe.net/'},
                      cache: true,
                      // cacheRule: CacheRule(
                      //     maxAge: Duration(days: prefs.getInt('previewRule'))),
                    ))),
            child: Column(
              children: <Widget>[
                Text(
                  '#$jpTitle',
                  textAlign: TextAlign.center,
                  strutStyle: StrutStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
                Text(
                  transTitle,
                  textAlign: TextAlign.center,
                  strutStyle: StrutStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                )
              ],
            ),
          )),
    );
  }
}
