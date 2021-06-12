import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sharemoe/basic/pic_texts.dart';
import 'package:sharemoe/basic/pic_urls.dart';
import 'package:sharemoe/controller/image_controller.dart';

import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/page/comment/comment_cell.dart';
import 'package:sharemoe/ui/page/pic/pic_page.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class PicDetailPage extends GetView<ImageController> {
  @override
  final String tag;
  final ScreenUtil screen = ScreenUtil();

  final TextZhPicDetailPage texts = TextZhPicDetailPage();

  final TextStyle smallTextStyle = TextStyle(
      fontSize: ScreenUtil().setWidth(10),
      color: Colors.black,
      decoration: TextDecoration.none);

  final TextStyle normalTextStyle = TextStyle(
      fontSize: ScreenUtil().setWidth(14),
      color: Colors.black,
      decoration: TextDecoration.none);

  PicDetailPage({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SappBar.normal(title: controller.illust.title),
        body: PicPage.related(
          model: PicModel.RELATED + controller.illust.id.toString(),
          topWidget: picDetailBody(),
        ));
  }

  Widget picDetailBody() {
    return Column(
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
            width: double.infinity,
            height: ScreenUtil().setHeight(25),
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: title()),
        SizedBox(
          height: screen.setHeight(6),
        ),
        Html(
          // padding: EdgeInsets.symmetric(horizontal: 10.0),
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
            padding: EdgeInsets.symmetric(horizontal: 10.0), child: tags()),
        SizedBox(
          height: ScreenUtil().setHeight(6),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: focus(),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(6),
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0), child: author()),
        CommentCell(
          controller.illust.id.toString(),
          illustId: controller.illust.id,
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
      control: controller.illust.pageCount == 1 ? null : SwiperControl(),
      itemCount: controller.illust.pageCount,
      itemBuilder: (context, index) {
        return GestureDetector(
          onLongPress: () {
            longPressPic(controller.illust.imageUrls[0].original);
          },
          child: Hero(
            tag: 'imageHero' + controller.illust.id.toString(),
            child: ExtendedImage.network(
              PicUrl(url: controller.illust.imageUrls[index].medium).imageUrl,
              headers: {'Referer': 'https://m.sharemoe.net/'},
              width: screen.setWidth(200),
              fit: BoxFit.fill,
            ),
          ),
        );
      },
    );
  }

  Widget title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SelectableText(
          controller.illust.title,
          style: normalTextStyle,
        ),
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            addToAlbumButton(),
            Container(
              width: screen.setWidth(5),
            ),
            GetBuilder<ImageController>(
                id: 'mark',
                tag: controller.illust.id.toString(),
                builder: (_) {
                  return IconButton(
                      icon: Icon(Icons.favorite),
                      color: _.illust.isLiked! ? Colors.red : Colors.grey,
                      onPressed: () {
                        _.markIllust();
                      });
                })
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
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) =>
            //         SearchPage(searchKeywordsIn: item['name'])));
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                print(controller.illust.artistPreView.avatar);
                Get.toNamed(Routes.ARTIST_DETAIL,
                    arguments: controller.illust.artistPreView);
              },
              child: Hero(
                tag: controller.illust.artistPreView.avatar,
                child: CircleAvatar(
                  backgroundImage: ExtendedNetworkImageProvider(
                    controller.illust.artistPreView.avatar.replaceAll(
                        'https://i.pximg.net', 'https://o.acgpic.net'),
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
              controller.illust.artistPreView.name,
              style: smallTextStyle,
            ),
          ],
        ),
        subscribeButton(),
      ],
    );
  }

  Widget addToAlbumButton() {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      width: ScreenUtil().setWidth(28),
      height: ScreenUtil().setWidth(28),
      child: Material(
        color: Colors.white,
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

  Widget subscribeButton() {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      color: Colors.blueAccent[200],
      onPressed: () async {},
      child: Text(
        texts.follow,
        style:
            TextStyle(fontSize: ScreenUtil().setWidth(10), color: Colors.white),
      ),
    );
  }

  longPressPic(String url) {
    return Get.bottomSheet(
      Container(
        height: screen.setHeight(250),
        child: Column(
          children: [
            ListTile(
              title: Text(texts.downloadImage),
              leading: Icon(
                Icons.cloud_download,
                color: Colors.orangeAccent,
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text(texts.jumpToPixivDetail),
              leading: Icon(Icons.image, color: Colors.purple),
            ),
            ListTile(
              title: Text(texts.jumpToPixivArtist),
              leading: Icon(
                Icons.people,
                color: Colors.blueAccent,
              ),
            ),
            ListTile(
              title: Text(texts.copyArtistId),
              leading: Icon(
                Icons.confirmation_number,
                color: Colors.red[300],
              ),
            ),
            ListTile(
              title: Text(texts.copyIllustId),
              leading: Icon(
                Icons.confirmation_number,
                color: Colors.green[300],
              ),
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
