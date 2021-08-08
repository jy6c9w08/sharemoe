// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/ImageUrlLevel.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/service/download_service.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/basic/util/pic_url_util.dart';
import 'package:sharemoe/controller/artist/artist_detail_controller.dart';
import 'package:sharemoe/controller/image_controller.dart';
import 'package:sharemoe/controller/pic_detail_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/model/image_download_info.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/page/comment/comment_cell.dart';
import 'package:sharemoe/ui/page/pic/pic_page.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class PicDetailPage extends GetView<ImageController> {
  @override
  final String tag;
  final ScreenUtil screen = ScreenUtil();

  final TextStyle smallTextStyle = TextStyle(
      fontSize: ScreenUtil().setSp(10),
      color: Colors.black,
      decoration: TextDecoration.none);

  final TextStyle normalTextStyle = TextStyle(
      fontSize: ScreenUtil().setSp(14),
      color: Colors.black,
      decoration: TextDecoration.none);
  final StrutStyle titleStructStyle =
      StrutStyle(height: 1.01, fontSize: ScreenUtil().setSp(14));

  PicDetailPage({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: SappBar.normal(title: controller.illust.title),
        body: PicPage.related(
          model: PicModel.RELATED + controller.illust.id.toString(),
          topWidget: picDetailBody(),
        ));
  }

  Widget picDetailBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: screen.setWidth(324) /
                controller.illust.width *
                controller.illust.height,
            child: picBanner()),
        SizedBox(
          height: screen.setHeight(6),
        ),
        Container(
            // color: Colors.blue,
            width: double.infinity,
            height: ScreenUtil().setHeight(24),
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: title()),
        SizedBox(
          height: screen.setHeight(6),
        ),
        Html(
          // padding: EdgeInsets.symmetric(horizontal: 8.0),
          data: controller.illust.caption,
          // linkStyle: smallTextStyle,
          // defaultTextStyle: smallTextStyle,
          // onLinkTap: (url) async {
          //   // if (await canLaunch(url)) {
          //   //   await launch(url);
          //   // } else {
          //   //   throw 'Could not launch $url';
          //   // }
          // },
        ),
        SizedBox(
          height: ScreenUtil().setHeight(6),
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0), child: tags()),
        SizedBox(
          height: ScreenUtil().setHeight(6),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: focus(),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(6),
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0), child: author()),
        CommentCell(
          controller.illust.id.toString(),
        ),
        Container(
          padding: EdgeInsets.all(ScreenUtil().setHeight(7)),
          color: Colors.white,
          width: screen.setWidth(324),
          alignment: Alignment.centerLeft,
          child: Text(
            '相关作品',
            style: normalTextStyle,
          ),
        ),
      ],
    );
  }

  Widget picBanner() {
    return Swiper(
      loop: controller.illust.pageCount == 1 ? false : true,
      pagination: controller.illust.pageCount == 1 ? null : SwiperPagination(),
      // control: controller.illust.pageCount == 1 ? null : SwiperControl(),
      itemCount: controller.illust.pageCount,
      itemBuilder: (context, index) {
        return GestureDetector(
          onLongPress: () {
            longPressPic(controller.illust.imageUrls[index].original);
          },
          child: Hero(
            tag: 'imageHero' + controller.illust.id.toString(),
            child: ExtendedImage.network(
                getIt<PicUrlUtil>().dealUrl(
                    controller.illust.imageUrls[index].medium,
                    ImageUrlLevel.medium),
                headers: {'Referer': 'https://m.sharemoe.net/'},
                height: screen.screenWidth /
                    controller.illust.width.toDouble() *
                    controller.illust.height.toDouble(),
                width: screen.screenWidth,
                fit: BoxFit.fitHeight,
                gaplessPlayback: true),
          ),
        );
      },
    );
  }

  Widget title() {
    // TODO: 标题显示不全
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SelectableText(
          controller.illust.title,
          // textAlign: TextAlign.center,
          style: normalTextStyle,
          // strutStyle: titleStructStyle,
        ),
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            addToAlbumButton(),
            Container(
              width: screen.setWidth(5),
            ),
            getIt<UserService>().isLogin()
                ? GetBuilder<ImageController>(
                    tag: tag,
                    id: 'mark',
                    builder: (_) {
                      return LikeButton(
                        size: screen.setWidth(28),
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            Icons.favorite,
                            color: isLiked ? Colors.red : Colors.grey,
                            size: screen.setWidth(28),
                          );
                        },
                        isLiked: controller.illust.isLiked,
                        onTap: controller.markIllust,
                      );
                    })
                : Container()
            /*   GetX<GlobalController>(builder: (_) {
              return _.isLogin.value
                  ? GetBuilder<ImageController>(
                      tag: tag,
                      id: 'mark',
                      builder: (_) {
                        return LikeButton(
                          size: screen.setWidth(28),
                          likeBuilder: (bool isLiked) {
                            return Icon(
                              Icons.favorite,
                              color: isLiked ? Colors.red : Colors.grey,
                              size: screen.setWidth(28),
                            );
                          },
                          isLiked: controller.illust.isLiked,
                          onTap: controller.markIllust,
                        );
                      })
                  : Container();
            })*/
            ,
          ],
        )
      ],
    );
  }

  Widget tags() {
    TextStyle translateTextStyle = TextStyle(
        fontSize: ScreenUtil().setWidth(8),
        color: Colors.black,
        decoration: TextDecoration.none);
    TextStyle tagTextStyle = TextStyle(
        fontSize: ScreenUtil().setWidth(8),
        color: Colors.blue[300],
        decoration: TextDecoration.none);
    StrutStyle strutStyle = StrutStyle(
      fontSize: ScreenUtil().setWidth(8),
      height: ScreenUtil().setWidth(1.3),
    );
    List<Tags>? tags = controller.illust.tags;
    List<Widget> tagsRow = [];

    for (Tags item in tags!) {
      tagsRow.add(GestureDetector(
          onTap: () {
            Get.put(
                WaterFlowController(model: 'search', searchKeyword: item.name),
                tag: item.name);
            // Get.find<SappBarController>().searchTextEditingController.text=item.name;
            Get.toNamed(
              Routes.SEARCH_TAG,
              arguments: item.name,
            );
          },
          child: Text(
            '#${item.name}',
            style: tagTextStyle,
            strutStyle: strutStyle,
          )));
      tagsRow.add(SizedBox(
        width: ScreenUtil().setWidth(4),
      ));
      if (item.translatedName != '') {
        tagsRow.add(Text(
          item.translatedName,
          style: translateTextStyle,
          strutStyle: strutStyle,
        ));
        tagsRow.add(SizedBox(
          width: ScreenUtil().setWidth(4),
        ));
      }
    }

    return Wrap(
      children: tagsRow,
    );
  }

  Widget focus() {
    return Row(
      children: <Widget>[
        Icon(
          Icons.remove_red_eye,
          size: ScreenUtil().setWidth(10),
        ),
        SizedBox(
          width: ScreenUtil().setWidth(3),
        ),
        Text(
          controller.illust.totalView.toString(),
          style: smallTextStyle,
        ),
        SizedBox(
          width: ScreenUtil().setWidth(8),
        ),
        Icon(
          Icons.bookmark,
          size: ScreenUtil().setWidth(10),
        ),
        SizedBox(
          width: ScreenUtil().setWidth(3),
        ),
        Text(
          controller.illust.totalBookmarks.toString(),
          style: smallTextStyle,
        ),
        SizedBox(
          width: ScreenUtil().setWidth(12),
        ),
        Text(
          DateFormat('yyyy-MM-dd')
              .format(controller.illust.createDate!)
              .toString(),
          style: smallTextStyle,
        ),
      ],
    );
  }

  Widget author() {
    return GetBuilder<PicDetailController>(
        id: 'updateArtist',
        // tag: tag,
        builder: (_) {
          return !_.isReady
              ? Container()
              : GetBuilder<ArtistDetailController>(
                  tag: controller.illust.artistId.toString(),
                  builder: (_) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                Get.toNamed(Routes.ARTIST_DETAIL,
                                    arguments: controller
                                        .illust.artistPreView.id!
                                        .toString());
                              },
                              child: Hero(
                                tag: controller.illust.artistPreView.avatar,
                                child: CircleAvatar(
                                  backgroundImage: ExtendedNetworkImageProvider(
                                    controller.illust.artistPreView.avatar
                                        .replaceAll('https://i.pximg.net',
                                            'https://o.acgpic.net'),
                                    headers: {
                                      'Referer': 'https://m.sharemoe.net/',
                                      // 'authorization': picBox.get('auth')
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screen.setWidth(10),
                            ),
                            Text(
                              _.artist.name!,
                              style: smallTextStyle,
                            ),
                          ],
                        ),
                        GetBuilder<ArtistDetailController>(
                          id: 'follow',
                            tag: controller.illust.artistId.toString(),
                            builder: (_) {
                              return  _.artist.isFollowed==null?Container():MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0)),
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
                      ],
                    );
                  });
        });
  }

  Widget addToAlbumButton() {
    return Container(
      alignment: Alignment.center,
      width: ScreenUtil().setWidth(28),
      height: ScreenUtil().setWidth(28),
      child: Material(
        child: InkWell(
          child: FaIcon(
            FontAwesomeIcons.folderPlus,
            color: Colors.blueGrey,
          ),
          onTap: () {
            // showAddToCollection(context, [widget._picData['id']],
            //     multiSelect: false);
          },
        ),
      ),
    );
  }

  longPressPic(String url) {
    return Get.bottomSheet(
      Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(TextZhPicDetailPage.downloadImage),
              leading: Icon(
                Icons.cloud_download,
                color: Colors.orangeAccent,
              ),
              onTap: () async {
                print(controller.illust.imageUrls[0].original);
                getIt<DownloadService>().download(ImageDownloadInfo(
                    //fileName: controller.illust.id.toString(),
                    illustId: controller.illust.id,
                    pageCount: 0, //TODO ,
                    imageUrl: controller.illust.imageUrls[0].original));
                Get.back();
              },
            ),
            ListTile(
              title: Text(TextZhPicDetailPage.jumpToPixivDetail),
              leading: Icon(Icons.image, color: Colors.purple),
              onTap: ()=>controller.openIllustDetail(),
            ),
            ListTile(
              title: Text(TextZhPicDetailPage.jumpToPixivArtist),
              leading: Icon(
                Icons.people,
                color: Colors.blueAccent,
              ),
              onTap: ()=>controller.openArtistDetail(),
            ),
            ListTile(
              title: Text(TextZhPicDetailPage.copyArtistId),
              leading: Icon(
                Icons.confirmation_number,
                color: Colors.red[300],
              ),
              onTap:()=>controller.copyArtistId(),
            ),
            ListTile(
              title: Text(TextZhPicDetailPage.copyIllustId),
              leading: Icon(
                Icons.confirmation_number,
                color: Colors.green[300],
              ),
              onTap: ()=>controller.copyIllustId(),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
    );
  }
}
