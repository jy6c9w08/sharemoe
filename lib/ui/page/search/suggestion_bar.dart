// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/controller/sapp_bar_controller.dart';
import 'package:sharemoe/controller/search_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';

class SuggestionBar extends GetView<SearchController> {
  @override
  final String tag;
  final ScreenUtil screen = ScreenUtil();

  SuggestionBar(this.tag);

  @override
  Widget build(BuildContext context) {
    return GetX<SearchController>(
        tag: tag,
        initState: (state) {
          Get.find<SearchController>(tag: tag).getSuggestionList();
        },
        builder: (_) {
          return SliverAppBar(
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            floating: true,
            // expandedHeight: 0,
            toolbarHeight: _.suggestions.value.length != 0
                ? ScreenUtil().setHeight(43)
                : 0,
            title: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              curve: Curves.easeInOutExpo,
              height: ScreenUtil().setHeight(43),
              width: ScreenUtil().setWidth(324),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _.suggestions.value.length,
                  itemBuilder: (context, index) {
                    Widget keywordsColumn;
                    if (_.suggestions.value[index].keywordTranslated != '') {
                      keywordsColumn = Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            suggestionsKeywordsText(
                                _.suggestions.value[index].keyword),
                            suggestionsKeywordsText(
                                _.suggestions.value[index].keywordTranslated),
                          ]);
                    } else {
                      keywordsColumn = suggestionsKeywordsText(
                          _.suggestions.value[index].keyword);
                    }

                    return GestureDetector(
                      onTap: () {
                        Get.find<WaterFlowController>(tag: tag)
                            .refreshIllustList(
                                searchKeyword:
                                    _.suggestions.value[index].keyword,
                                tag: tag);
                        Get.find<SappBarController>(tag: tag)
                            .searchTextEditingController
                            .text = _.suggestions.value[index].keyword;
                      },
                      child: Container(
                        margin: EdgeInsets.all(ScreenUtil().setWidth(2)),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(3)),
                          color: Color(0xFFB9EEE5),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Center(
                          child: keywordsColumn,
                        ),
                      ),
                    );
                  }),
            ),
          );
        });
  }

  Widget suggestionsKeywordsText(String suggestions) {
    return Text(
      suggestions,
      strutStyle: StrutStyle(
        fontSize: 10.sp,
      ),
      style: TextStyle(color: Colors.white, fontSize: 13.sp),
    );
  }
}
