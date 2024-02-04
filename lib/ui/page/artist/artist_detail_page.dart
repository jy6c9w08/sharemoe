// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/ImageUrlLevel.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/util/pic_url_util.dart';
import 'package:sharemoe/controller/artist/artist_detail_controller.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:sharemoe/ui/widget/tab_view.dart';

class ArtistDetailPage extends GetView<ArtistDetailController> {
  final ScreenUtil screen = ScreenUtil();
  @override
  final String tag;

  // final ArtistPreView artistPreView = Get.arguments as ArtistPreView;

  // final Artist artist;
  // final ArtistPreView artist;

  ArtistDetailPage({Key? key, required this.tag}) : super(key: key);

  final TextStyle smallTextStyle = TextStyle(
      fontSize: ScreenUtil().setWidth(10),
      color: Colors.black,
      decoration: TextDecoration.none);
  final TextStyle normalTextStyle = TextStyle(
      fontSize: ScreenUtil().setWidth(14),
      color: Colors.black,
      decoration: TextDecoration.none);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SappBar.normal(
        title: controller.artist.name,
      ),
      body: GetBuilder<ArtistDetailController>(
          // init: Get.put(ArtistDetailController(artistId: this.controller.artist.value.id!),tag: controller.artist.value.id.toString()),
          tag: tag,
          builder: (_) {
            return Container(
              height: ScreenUtil().setHeight(521),
              width: ScreenUtil().setWidth(324),
              child: TabView.artist(
                showAppbar: true,
                firstView: "插画",
                secondView: "漫画",
                artistId: controller.artist.id,
                topWidget: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ExtendedImage.network(
                              getIt<PicUrlUtil>().dealUrl(
                                  controller.artist.avatar!,
                                  ImageUrlLevel.original),
                              headers: {
                                'Referer': 'https://m.pixivic.com',
                              },
                              shape: BoxShape.circle,
                              height: 65.h,
                              width: 65.h,
                              loadStateChanged: (ExtendedImageState state) {
                                switch (state.extendedImageLoadState) {
                                  case LoadState.loading:
                                    return null;

                                  case LoadState.completed:
                                    return null;

                                  case LoadState.failed:
                                    return Container(
                                      child: Image.asset(
                                          'assets/image/no_avatar.png'),
                                      height: 10,
                                      width: 10,
                                    );
                                }
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            Text(
                              controller.artist.name!,
                              style: normalTextStyle,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            GestureDetector(
                              child: Text('ID:${controller.artist.id}',
                                  style: smallTextStyle),
                              onLongPress: () => controller.copyId(),
                            ),
                          ],
                        )),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 120.w),
                      child: GetBuilder<ArtistDetailController>(
                          id: 'follow',
                          tag: tag,
                          builder: (_) {
                            return _.artist.isFollowed == null
                                ? Container()
                                : MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0)),
                                color: Colors.blueAccent[200],
                                onPressed: () async {
                                  _.follow();
                                },
                                child: Text(
                                  _.artist.isFollowed!
                                      ? TextZhPicDetailPage.followed
                                      : TextZhPicDetailPage.follow,
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setWidth(10),
                                      color: Colors.white),
                                ));
                          }),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    // 个人网站和 Twitter
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if(controller.artist.webPage!="")
                        GestureDetector(
                            onTap: () => controller.openWeb(),
                            child: FaIcon(
                              FontAwesomeIcons.home,
                              color: Colors.blue,
                            )),
                        SizedBox(
                          width: ScreenUtil().setWidth(8),
                        ),
                        if(controller.artist.twitterUrl!="")
                        GestureDetector(
                            onTap: () => controller.openTwitter(),
                            child: FaIcon(
                              FontAwesomeIcons.twitterSquare,
                              color: Colors.blue,
                            ))
                      ],
                    ),
                    // 关注人数
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
                      child: (Text(
                        '${controller.artist.totalFollowUsers} 关注',
                        style: smallTextStyle,
                      )),
                    ),
                    // 简介
                    Container(
                      margin: EdgeInsets.all(ScreenUtil().setHeight(20)),
                      child: Wrap(
                        children: <Widget>[
                          Text(
                            '${controller.artist.comment}',
                            style: smallTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
