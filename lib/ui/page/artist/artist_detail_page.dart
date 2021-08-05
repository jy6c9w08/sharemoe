// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/ImageUrlLevel.dart';
import 'package:sharemoe/basic/util/pic_url_util.dart';

// Project imports:
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

// final ScrollController scrollController=ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.normal(
        title: controller.artist.name,
      ),
      body: GetBuilder<ArtistDetailController>(
          // init: Get.put(ArtistDetailController(artistId: this.controller.artist.value.id!),tag: controller.artist.value.id.toString()),
          tag: tag,
          builder: (_) {
            return ListView(
              controller: _.scrollController,
              shrinkWrap: true,
              children: <Widget>[
                // 头像、名称、关注按钮
                Container(
                    padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                    // margin: EdgeInsets.all(ScreenUtil().setHeight(20)),
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                      tag: controller.artist.avatar!,
                      child: CircleAvatar(
                          backgroundImage: ExtendedNetworkImageProvider(
                              getIt<PicUrlUtil>().dealUrl(
                                  controller.artist.avatar!,
                                  ImageUrlLevel.original))),
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
                      onLongPress: () {
                        // Clipboard.setData(
                        //     ClipboardData(text: widget.artistId.toString()));
                        // BotToast.showSimpleNotification(
                        //     title: texts.alreadyCopied);
                      },
                    ),
                    // SizedBox(
                    //   height: ScreenUtil().setHeight(25),
                    // ),
                    // loginState ? _subscribeButton() : Container(),
                  ],
                )),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 120.w),
                  child: MaterialButton(
                    minWidth: 20,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r)),
                    color: Colors.blue,
                    onPressed: () {
                      controller.follow();
                    },
                    child: GetBuilder<ArtistDetailController>(
                        tag: tag,
                        id: 'follow',
                        builder: (_) {
                          return Text(
                            controller.artist.isFollowed! ? '已关注' : '未关注',
                            style: TextStyle(color: Colors.white),
                          );
                        }),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                // 个人网站和 Twitter
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () async {
                          // if (await canLaunch(urlWebPage)) {
                          //   await launch(urlWebPage);
                          // } else {
                          //   BotToast.showSimpleNotification(title: '唤起网页失败');
                          //   throw 'Could not launch $urlWebPage';
                          // }
                        },
                        child: FaIcon(
                          FontAwesomeIcons.home,
                          color: Colors.blue,
                        )),
                    SizedBox(
                      width: ScreenUtil().setWidth(8),
                    ),
                    GestureDetector(
                        onTap: () async {
                          // if (await canLaunch(urlTwitter)) {
                          //   await launch(urlTwitter);
                          // } else {
                          //   BotToast.showSimpleNotification(title: '唤起网页失败');
                          //   throw 'Could not launch $urlTwitter';
                          // }
                        },
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
                // 相关图片
                Container(
                  height: ScreenUtil().setHeight(521),
                  width: ScreenUtil().setWidth(324),
                  child: TabView.artist(
                    firstView: "插画",
                    secondView: "漫画",
                    artistId: controller.artist.id,
                  ),
                )
              ],
            );
          }),
    );
  }
}
