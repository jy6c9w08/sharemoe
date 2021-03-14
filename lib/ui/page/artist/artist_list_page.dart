import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/controller/artist_controller.dart';
import 'package:sharemoe/data/model/artist.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/widget/loading_box.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class ArtistListPage extends GetView<ArtistController> {
  final ScreenUtil screen = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SappBar(title: '我的关注'),
        body: GetX<ArtistController>(
            init: Get.put(ArtistController()),
            builder: (_) {
              return _.artistList.value == null
                  ? LoadingBox()
                  : Container(
                      color: Colors.white,
                      child: ListView.builder(
                          itemCount: _.artistList.value.length,
                          itemBuilder: (BuildContext context, int index) {
                            return artistCell(_.artistList.value[index]);
                          }),
                    );
            }));
  }

  Widget artistCell(Artist cellData) {
    return Container(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
      child: Column(
        children: <Widget>[
          Container(height: screen.setHeight(108), child: picsCell(cellData)),
          Material(
            child: InkWell(
              onTap: () {
                // _routeToArtistPage(cellData);
              },
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              cellData.avatar.replaceAll(
                                  'https://i.pximg.net', 'https://acgpic.net'),
                              headers: {'Referer': 'https://m.sharemoe.net/'}),
                        ),
                      ),
                      Text(cellData.name,
                          style: TextStyle(
                              fontSize: ScreenUtil().setWidth(10),
                              color: Colors.black,
                              decoration: TextDecoration.none)),
                    ],
                  ),
                  // Positioned(
                  //     top: ScreenUtil().setWidth(10),
                  //     right: ScreenUtil().setWidth(15),
                  //     child: picBox.get('auth') != ''
                  //         ? Container(
                  //       alignment: Alignment.centerRight,
                  //       child: _subscribeButton(cellData),
                  //     )
                  //         : Container()),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget picsCell(Artist picData) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: picData.recentlyIllustrations.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
              color: Colors.grey[200],
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.DETAIL,
                      arguments: picData.recentlyIllustrations[index]);
                },
                child: ExtendedImage.network(
                  picData.recentlyIllustrations[index].imageUrls[0].squareMedium
                      .replaceAll('https://i.pximg.net', 'https://acgpic.net'),
                  headers: {'Referer': 'https://m.sharemoe.net/'},
                ),
              ));
        });

    //   Row(
    //   children: allIndex.map((int item) {
    //     return Container(
    //       width: screen.setWidth(108),
    //       height: screen.setWidth(108),
    //       color: Colors.grey[200],
    //       child: picData.recentlyIllustrations[item].sanityLevel <=
    //           prefs.getInt('sanityLevel')
    //           ? GestureDetector(
    //         onTap: () {
    //           _routeToPicDetailPage(picData.recentlyIllustrations[item]);
    //         },
    //         child: Image.network(
    //           picData
    //               .recentlyIllustrations[item].imageUrls[0].squareMedium,
    //           headers: {'Referer': 'https://app-api.pixiv.net'},
    //           width: ScreenUtil().setWidth(108),
    //           height: ScreenUtil().setWidth(108),
    //         ),
    //       )
    //           : Stack(
    //         children: <Widget>[
    //           Image.network(
    //             picData.recentlyIllustrations[item].imageUrls[0]
    //                 .squareMedium,
    //             headers: {'Referer': 'https://app-api.pixiv.net'},
    //             width: ScreenUtil().setWidth(108),
    //             height: ScreenUtil().setWidth(108),
    //           ),
    //           ClipRect(
    //             child: BackdropFilter(
    //               filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
    //               child: Opacity(
    //                   opacity: 0.5, //透明度
    //                   child: Container(
    //                     decoration: BoxDecoration(
    //                         color: Colors.grey.shade200), //盒子装饰器，模糊的颜色
    //                   )),
    //             ),
    //           ),
    //         ],
    //       ),
    //     );
    //   }).toList(),
    // );
  }
}