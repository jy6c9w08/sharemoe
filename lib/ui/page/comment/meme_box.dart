// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

// Project imports:
import 'package:sharemoe/controller/comment/comment_text_filed_controller.dart';
import 'package:sharemoe/ui/widget/state_box.dart';

class MemeBox extends GetView<CommentTextFiledController> {
  final double widgetHeight;
  @override
  final String tag;
  final int? appId;

  MemeBox(this.tag, {required this.widgetHeight, this.appId});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: ScreenUtil().setWidth(324),
        // height: widgetHeight,
        child: GetX<CommentTextFiledController>(
            tag: tag,
            builder: (_) {
              if (_.memeMap.value.isEmpty)
                return LoadingBox();
              else {
                List memeGroupKeys = _.memeMap.value.keys.toList();
                return DefaultTabController(
                    length: 3,
                    child: Column(children: [
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: ScreenUtil().setWidth(324),
                        height: ScreenUtil().setHeight(30),
                        child: TabBar(
                          labelColor: Colors.orange[400],
                          tabs: List.generate(memeGroupKeys.length,
                              (index) => Tab(text: memeGroupKeys[index])),
                        ),
                      ),
                      Container(
                        color:Theme.of(context).scaffoldBackgroundColor,
                        width: ScreenUtil().setWidth(324),
                        height: widgetHeight - ScreenUtil().setHeight(30),
                        alignment: Alignment.center,
                        child: TabBarView(
                            children: List.generate(memeGroupKeys.length,
                                (index) => memePanel(memeGroupKeys[index]))),
                      )
                    ]));
              }
            }));
  }

  Widget memePanel(String memeGroup) {
    if (controller.memeMap.value.isEmpty)
      return LoadingBox();
    else {
      List memeKeys = controller.memeMap.value[memeGroup].keys.toList();
      List memePath = controller.memeMap.value[memeGroup].values.toList();
      return WaterfallFlow.builder(
          itemCount: memeKeys.length,
          itemBuilder: (BuildContext context, int index) {
            return memeCell(memePath[index], memeKeys[index], memeGroup);
          },
          gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            viewportBuilder: (int firstIndex, int lastIndex) {
              print("memebox viewport : [$firstIndex,$lastIndex]");
            },
          ));
    }
  }

  Widget memeCell(String path, String memeName, String memeGroup) {
    return GestureDetector(
      onTap: () {
        controller.reply(
            memeGroup: memeGroup, memeName: memeName, appId: appId);
        controller.isMemeMode.value = false;
      },
      child: Container(
        margin: EdgeInsets.all(ScreenUtil().setWidth(4)),
        width: ScreenUtil().setWidth(55),
        height: ScreenUtil().setWidth(55),
        child: Image(
          isAntiAlias: true,
          image: (AssetImage(path)),
        ),
      ),
    );
  }
}
