// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/ImageUrlLevel.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
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
    ArtistListController controller =
        Get.put(ArtistListController(model: this.model), tag: model);
    return Scaffold(
        appBar: model != 'fallow' ? null : SappBar.normal(title: this.title),
        body: controller.obx(
            (state) => GetX<ArtistListController>(
                init: controller,
                builder: (_) {
                  return Container(
                    color: Colors.white,
                    child: ListView.builder(
                        itemCount: controller.artistList.value.length,
                        itemBuilder: (BuildContext context, int index) {
                          Get.lazyPut(
                              () => ArtistDetailController(
                                  artist: controller.artistList.value[index]),
                              tag: "fromList"+controller.artistList.value[index].id!
                                  .toString());
                          return ArtistDisplay(
                              tag: "fromList" +
                                  controller.artistList.value[index].id!
                                      .toString());
                        }),
                  );
                }),
            onEmpty: EmptyBox(),
            onLoading: LoadingBox()));
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
              leading: Hero(
                tag:  controller.artist.avatar!,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      getIt<PicUrlUtil>().dealUrl(
                          controller.artist.avatar!, ImageUrlLevel.original),
                      headers: {'Referer': 'https://m.sharemoe.net/'}),
                ),
              ),
              title: Text(controller.artist.name!),
              onTap: () => Get.toNamed(Routes.ARTIST_DETAIL, arguments: tag),
              trailing: MaterialButton(
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
                        controller.artist.isFollowed!
                            ? TextZhPicDetailPage.followed
                            : TextZhPicDetailPage.follow,
                        style: TextStyle(color: Colors.white),
                      );
                    }),
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
