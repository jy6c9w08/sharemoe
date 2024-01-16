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
import 'package:sharemoe/ui/page/pic/pic_page.dart';
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

  ArtistListPage.guessLike({
    this.model = 'guessLike',
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    ArtistListController controller = Get.put(
        ArtistListController(model: this.model),
        tag: model + (Get.arguments ?? '').toString());
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: model != 'fallow' ? null : SappBar.normal(title: this.title),
        body: controller.obx(
            (state) => GetX<ArtistListController>(
                init: controller,
                builder: (_) {
                  return Container(
                    color: Colors.white,
                    child: ListView.builder(
                        controller: controller.scrollController,
                        itemCount: controller.artistList.value.length,
                        itemBuilder: (BuildContext context, int index) {
                          Get.lazyPut(
                              () => ArtistDetailController(
                                  artist: controller.artistList.value[index]),
                              tag: controller.artistList.value[index].id!
                                  .toString());
                          return ArtistDisplay(
                              tag: controller.artistList.value[index].id!
                                  .toString());
                        }),
                  );
                }),
            onEmpty: EmptyBox(),
            onLoading: LoadingBox()),
        floatingActionButton: model == 'guessLike'
            ? FloatingActionButton(
                onPressed: () {
                  controller.refreshArtistList();
                },
                child: Icon(Icons.refresh),
                backgroundColor: Colors.orange[400],
              )
            : Container(),
        floatingActionButtonLocation: CustomFloatingActionButtonLocation(
            FloatingActionButtonLocation.endFloat, 0, -60.h));
  }
}

class ArtistDisplay extends GetView<ArtistDetailController> {
  ArtistDisplay({Key? key, required this.tag}) : super(key: key);
  @override
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        controller.artist.recentlyIllustrations!.isEmpty
            ? Container()
            : Container(height: 108.h, child: picsCell(controller.artist)),
        Material(
          child: ListTile(
            contentPadding: EdgeInsets.all(7.w),
            leading: Hero(
                tag: controller.artist.avatar!,
                child: ExtendedImage.network(
                  getIt<PicUrlUtil>().dealUrl(
                      controller.artist.avatar!, ImageUrlLevel.original),
                  shape: BoxShape.circle,
                  height: 33.w,
                  width: 33.w,
                  headers: {
                    'Referer': 'https://m.pixivic.com',
                  },
                  loadStateChanged: (ExtendedImageState state) {
                    switch (state.extendedImageLoadState) {
                      case LoadState.loading:
                        return null;

                      case LoadState.completed:
                        return null;

                      case LoadState.failed:
                        return Container(
                          child: Image.asset('assets/image/no_avatar.png'),
                          height: 33.w,
                          width: 33.w,
                        );
                    }
                  },
                )),
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
    );
  }

  Widget picsCell(Artist picData) {
    return ListView.builder(
        // shrinkWrap: true,
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
                        headers: {'Referer': 'https://m.pixivic.com'},
                        width: 1.sw / 3,
                        loadStateChanged: (ExtendedImageState state) {
                          switch (state.extendedImageLoadState) {
                            case LoadState.loading:
                              return null;

                            case LoadState.completed:
                              return null;

                            case LoadState.failed:
                              return Container(
                                child: Image.asset('assets/image/filed.png'),
                                height: 10,
                                width: 10,
                              );
                          }
                        },
                      );
                    }),
              ));
        });
  }
}
