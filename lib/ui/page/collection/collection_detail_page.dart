// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/controller/collection/collection_detail_controller.dart';
import 'package:sharemoe/controller/collection/collection_selector_controller.dart';
import 'package:sharemoe/ui/page/pic/pic_page.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class CollectionDetailPage extends GetView<CollectionDetailController> {
  // final int collectionId;
  // final Collection collection;
  final screen = ScreenUtil();
  final UserService userService = getIt<UserService>();

  // CollectionDetailPage({Key key, this.collectionId, this.collection})
  //     : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.collection(
        title: controller.collection.title,
      ),
      body: PicPage.collection(
        topWidget: collectionDetailBody(),
      ),
    );
  }

  Widget collectionDetailBody() {
    return GetBuilder<CollectionSelectorCollector>(
        id: 'title',
        builder: (_) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: screen.setWidth(18),
                    top: screen.setHeight(18),
                    bottom: screen.setHeight(12)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: screen.setWidth(25),
                      width: screen.setWidth(25),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: screen.setWidth(1),
                            color: Colors.grey.shade100),
                      ),
                      margin: EdgeInsets.only(
                        right: screen.setWidth(18),
                      ),
                      child: Container(
                        height: screen.setHeight(30),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: ScreenUtil().setWidth(2),
                                color: Colors.grey.shade300)),
                        child: ClipRRect(
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setWidth(500))),
                          child: ExtendedImage.network(
                            userService.userInfo()!.avatar,
                            fit: BoxFit.cover,
                            // height: screen.setHeight(25),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      constraints:
                          BoxConstraints(maxWidth: screen.setWidth(231)),
                      child: GetBuilder<CollectionDetailController>(
                          // id: 'detailBody',
                          builder: (_) {
                        return Text(
                          _.collection.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: screen.setSp(14)),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                    left: screen.setWidth(18),
                    right: screen.setWidth(18),
                    bottom: screen.setHeight(12)),
                child: Text(
                  controller.collection.caption,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w400, fontSize: screen.setSp(12)),
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(
                      left: screen.setWidth(18),
                      right: screen.setWidth(18),
                      bottom: screen.setHeight(12)
                  ),
                  child: Wrap(
                    children: List.generate(
                        controller.collection.tagList.length,
                        (index) => tagLink(
                            controller.collection.tagList[index].tagName)),
                  )),
            ],
          );
        });
  }

  Widget tagLink(String tag) {
    return Container(
        padding: EdgeInsets.only(right: 2.h),
        child: Text(
          '#$tag',
          style: TextStyle(
              color: Colors.orange[300],
              fontWeight: FontWeight.w400,
              fontSize: ScreenUtil().setSp(12)),
        ));
  }
}
