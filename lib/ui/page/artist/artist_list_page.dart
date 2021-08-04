// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/ImageUrlLevel.dart';
import 'package:sharemoe/basic/util/pic_url_util.dart';
import 'package:sharemoe/controller/artist/artist_detail_controller.dart';
import 'package:sharemoe/controller/artist/artist_list_controller.dart';
import 'package:sharemoe/controller/image_controller.dart';
import 'package:sharemoe/data/model/artist.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:sharemoe/ui/widget/state_box.dart';

class ArtistListPage extends GetView<ArtistListController> {
  final ScreenUtil screen = ScreenUtil();
  final String model;
  final String title;

  ArtistListPage({required this.model, this.title = '我的关注'});

  ArtistListPage.search({
    required this.model,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: model == 'search' ? null : SappBar.normal(title: this.title),
        body: GetX<ArtistListController>(
            init: Get.put(ArtistListController(model: this.model), tag: model),
            builder: (_) {
              return _.artistList.value.isEmpty
                  ? LoadingBox()
                  : Container(
                      color: Colors.white,
                      child: ListView.builder(
                          itemCount: _.artistList.value.length,
                          itemBuilder: (BuildContext context, int index) {
                            Get.put(
                                ArtistDetailController(
                                    artist: _.artistList.value[index]),
                                tag: _.artistList.value[index].id!.toString());
                            return ArtistDisplay(
                                tag: _.artistList.value[index].id!.toString());
                          }),
                    );
            }));
  }

  Widget artistCell(Artist cellData) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(height: screen.setHeight(108), child: picsCell(cellData)),
          Material(
            child: ListTile(
              contentPadding: EdgeInsets.all(8),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    getIt<PicUrlUtil>()
                        .dealUrl(cellData.avatar!, ImageUrlLevel.original),
                    headers: {'Referer': 'https://m.sharemoe.net/'}),
              ),
              title: Text(cellData.name!),
              onTap: () {
                Get.toNamed(Routes.ARTIST_DETAIL,
                    arguments: ArtistPreView(
                        avatar: cellData.avatar!,
                        name: cellData.name!,
                        id: cellData.id!,
                        account: cellData.account!,
                        isFollowed: cellData.isFollowed!));
              },
              trailing: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r)),
                color: Colors.blue,
                onPressed: () {
                  cellData.isFollowed = !cellData.isFollowed!;
                },
                child: Text(
                  cellData.isFollowed! ? '已关注' : '未关注',
                  style: TextStyle(color: Colors.white),
                ),
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
        itemCount: picData.recentlyIllustrations!.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          Get.put(
              ImageController(illust: picData.recentlyIllustrations![index]),
              tag: picData.recentlyIllustrations![index].id.toString());
          return Container(
              color: Colors.grey[200],
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.DETAIL,
                      arguments:
                          picData.recentlyIllustrations![index].id.toString());
                },
                child: GetBuilder<ImageController>(
                    tag: picData.recentlyIllustrations![index].id.toString(),
                    builder: (_) {
                      return ExtendedImage.network(
                        getIt<PicUrlUtil>().dealUrl(
                            picData.recentlyIllustrations![index].imageUrls[0]
                                .squareMedium,
                            ImageUrlLevel.medium),
                        headers: {'Referer': 'https://m.sharemoe.net/'},
                      );
                    }),
              ));
        });
  }
}

class ArtistDisplay extends GetView<ArtistDetailController> {
  ArtistDisplay({Key? key, required this.tag}) : super(key: key);
  @override
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(height: 108.h, child: picsCell(controller.artist)),
          Material(
            child: ListTile(
              contentPadding: EdgeInsets.all(8),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    getIt<PicUrlUtil>().dealUrl(
                        controller.artist.avatar!, ImageUrlLevel.original),
                    headers: {'Referer': 'https://m.sharemoe.net/'}),
              ),
              title: Text(controller.artist.name!),
              onTap: () {
                Get.toNamed(Routes.ARTIST_DETAIL, arguments: tag);
              },
              trailing: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r)),
                color: Colors.blue,
                onPressed: () {
                  controller.artist.isFollowed = !controller.artist.isFollowed!;
                },
                child: Text(
                  controller.artist.isFollowed! ? '已关注' : '未关注',
                  style: TextStyle(color: Colors.white),
                ),
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
        itemCount: picData.recentlyIllustrations!.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          Get.put(
              ImageController(illust: picData.recentlyIllustrations![index]),
              tag:
                  picData.recentlyIllustrations![index].id.toString() + 'true');
          return Container(
              color: Colors.grey[200],
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.DETAIL,
                      arguments:
                          picData.recentlyIllustrations![index].id.toString());
                },
                child: GetBuilder<ImageController>(
                    tag: picData.recentlyIllustrations![index].id.toString() +
                        'true',
                    builder: (_) {
                      return ExtendedImage.network(
                        getIt<PicUrlUtil>().dealUrl(
                            picData.recentlyIllustrations![index].imageUrls[0]
                                .squareMedium,
                            ImageUrlLevel.medium),
                        headers: {'Referer': 'https://m.sharemoe.net/'},
                      );
                    }),
              ));
        });
  }
}
