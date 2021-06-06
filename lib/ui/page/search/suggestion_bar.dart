import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharemoe/controller/sapp_bar_controller.dart';

import 'package:sharemoe/controller/search_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';

class SuggestionBar extends GetView<SearchController> {
  final ScreenUtil screen = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return GetX<SearchController>(initState: (state) {
      Get.find<SearchController>().getSuggestionList();
    }, builder: (_) {
      return _.suggestions.value.length!=0
          ? AnimatedContainer(
              duration: Duration(milliseconds: 250),
              curve: Curves.easeInOutExpo,
              height: ScreenUtil().setHeight(36),
              width: ScreenUtil().setWidth(324),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _.suggestions.value.length,
                  itemBuilder: (context, index) {
                    Widget keywordsColumn;
                    if (_.suggestions.value[index].keywordTranslated != '') {
                      keywordsColumn = Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
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
                        Get.find<WaterFlowController>(tag: 'search')
                            .refreshIllustList(
                                searchKeyword:
                                    _.suggestions.value[index].keyword);
                        Get.find<SappBarController>().searchTextEditingController.text =
                            _.suggestions.value[index].keyword;
                      },
                      child: Container(
                        margin: EdgeInsets.all(ScreenUtil().setWidth(2)),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(3)),
                          color: Color(0xFFB9EEE5),
                        ),
                        // width: ScreenUtil().setWidth(80),
                        padding: EdgeInsets.all(ScreenUtil().setWidth(2)),
                        child: Center(
                          child: keywordsColumn,
                        ),
                      ),
                    );
                  }),
            )
          : Container();
    });
  }

  Widget suggestionsKeywordsText(String suggestions) {
    return Text(
      suggestions,
      strutStyle: StrutStyle(
        fontSize: 10,
      ),
      style: TextStyle(color: Colors.white, fontSize: 10),
    );
  }
}
