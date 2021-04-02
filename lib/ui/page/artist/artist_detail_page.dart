import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:extended_image/extended_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:sharemoe/controller/artist/artist_detail_controller.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:sharemoe/ui/widget/tab_view.dart';

class ArtistDetailPage extends StatelessWidget {
  final ScreenUtil screen = ScreenUtil();

  // final Artist artist;
  final ArtistPreView artist;


  ArtistDetailPage({Key key, this.artist}) : super(key: key);

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
      appBar: SappBar(title: artist.name,),
      body: GetX<ArtistDetailController>(
          init: Get.put(ArtistDetailController(artistId: this.artist.id),tag: artist.id.toString()),
          tag: artist.id.toString(),
          builder: (_) {
        return ListView(
          controller: _.scrollController,
          shrinkWrap: true,
          children: <Widget>[
            // 头像、名称、关注按钮
            Container(
                padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
                margin: EdgeInsets.all(ScreenUtil().setHeight(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                      tag: artist.avatar,
                      child: CircleAvatar(
                          backgroundImage: ExtendedNetworkImageProvider(
                            artist.avatar,
                      )

                          // AdvancedNetworkImage(
                          //   imageUrl(widget.artistAvatar, 'avater'),
                          //   header: imageHeader('avater'),
                          //   useDiskCache: true,
                          //   cacheRule: CacheRule(
                          //       maxAge: Duration(
                          //           days: prefs.getInt('previewRule'))),
                          // ),
                          ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    Text(
                      artist.name,
                      style: normalTextStyle,
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    GestureDetector(
                      child: Text('ID:${artist.id}', style: smallTextStyle),
                      onLongPress: () {
                        // Clipboard.setData(
                        //     ClipboardData(text: widget.artistId.toString()));
                        // BotToast.showSimpleNotification(
                        //     title: texts.alreadyCopied);
                      },
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(25),
                    ),
                    // loginState ? _subscribeButton() : Container(),
                  ],
                )),
            // 个人网站和 Twitter
            Container(
              padding: EdgeInsets.all(ScreenUtil().setHeight(0)),
              child: Row(
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
            ),
            // 关注人数
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
              child: (Text(
                '${_.artist.value.totalFollowUsers} 关注',
                style: smallTextStyle,
              )),
            ),
            // 简介
            Container(
              margin: EdgeInsets.all(ScreenUtil().setHeight(20)),
              child: Wrap(
                children: <Widget>[
                  Text(
                    '${_.artist.value.comment}',
                    style: smallTextStyle,
                  ),
                ],
              ),
            ),
            // 相关图片
            Container(
              height: ScreenUtil().setHeight(521),
              width: ScreenUtil().setWidth(324),
              child: TabView.artist(firstView: "插画",secondView: "漫画",artistId: artist.id,),
            )
          ],
        );
      }),
    );
  }
}
