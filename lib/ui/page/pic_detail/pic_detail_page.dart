import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/basic/texts.dart';
import 'package:sharemoe/controller/pic_detail_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';

import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/page/comment/comment_cell.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:sharemoe/ui/widget/water_flow/water_flow.dart';

class PicDetailPage extends GetView<PicDetailController> {
  final Illust illust;
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

  PicDetailPage({Key key, this.illust}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SappBar(title: illust.title),
        body: WaterFlow.related(
          topWidget: picDetailBody(),
          relatedId: illust.id,
        ));
  }

  Widget picDetailBody() {
    return Column(
      children: [
        Container(
            height: screen.setWidth(324) / illust.width * illust.height,
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
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          data: illust.caption,
          linkStyle: smallTextStyle,
          defaultTextStyle: smallTextStyle,
          onLinkTap: (url) async {
            // if (await canLaunch(url)) {
            //   await launch(url);
            // } else {
            //   throw 'Could not launch $url';
            // }
          },
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
          illust.id.toString(),
          illustId: illust.id,
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
      loop: illust.pageCount == 1 ? false : true,
      pagination: illust.pageCount == 1 ? null : SwiperPagination(),
      control: illust.pageCount == 1 ? null : SwiperControl(),
      itemCount: illust.pageCount,
      itemBuilder: (context, index) {
        return GestureDetector(
          onLongPress: () {},
          child: Hero(
            tag: 'imageHero' + illust.imageUrls[index].medium,
            child: ExtendedImage.network(
              illust.imageUrls[index].medium
                  .replaceAll('https://i.pximg.net', 'https://acgpic.net'),
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
          illust.title,
          style: normalTextStyle,
        ),
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            addToAlbumButton(),
            Container(
              width: screen.setWidth(5),
            ),
            Icon(Icons.favorite)
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
    List tags = illust.tags;
    List<Widget> tagsRow = [];

    for (Tags item in tags) {
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
          illust.totalView.toString(),
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
          illust.totalBookmarks.toString(),
          style: smallTextStyle,
        ),
        SizedBox(
          width: ScreenUtil().setWidth(12),
        ),
        Text(
          DateFormat('yyyy-MM-dd').format(illust.createDate).toString(),
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
                print(illust.artistPreView.avatar);
                print(picBox.get('auth')[0]);
                Get.toNamed(Routes.ARTIST_DETAIL,
                    arguments: illust.artistPreView);
              },
              child: Hero(
                tag: illust.artistPreView.avatar,
                child: CircleAvatar(
                  backgroundImage: ExtendedNetworkImageProvider(
                    illust.artistPreView.avatar.replaceAll(
                        'https://i.pximg.net', 'https://acgpic.net'),
                    headers: {
                      'Referer': 'https://m.sharemoe.net/',
                      'authorization': picBox.get('auth')[0]
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              width: screen.setWidth(10),
            ),
            Text(
              illust.artistPreView.name,
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
    // bool currentFollowedState = widget._picData['artistPreView']['isFollowed'];
    // String buttonText = currentFollowedState ? texts.followed : texts.follow;

    return FlatButton(
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
}
