// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/ImageUrlLevel.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/basic/util/pic_url_util.dart';
import 'package:sharemoe/controller/collection/collection_controller.dart';
import 'package:sharemoe/data/model/collection.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:sharemoe/ui/widget/state_box.dart';

class CollectionPage extends GetView<CollectionController> {
  final TextZhCommentCell texts = TextZhCommentCell();
  final ScreenUtil screen = ScreenUtil();
  final PicUrlUtil picUrlUtil = getIt<PicUrlUtil>();
  final UserService userService = getIt<UserService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.normal(
        title: '画集',
      ),
      body: controller.obx(
          (state) => ListView.builder(
                itemExtent: screen.setHeight(250),
                controller: controller.scrollController,
                itemBuilder: (context, index) {
                  return collectionCardCell(index);
                },
                itemCount: controller.collectionList.value.length,
              ),
          onEmpty: EmptyBox()),
    );
  }

  Widget collectionCardCell(int index) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.COLLECTION_DETAIL, arguments: index);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screen.setWidth(10)),
        child: Card(
          color: Colors.white70,
          shadowColor: Colors.white70,
          elevation: 15.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          clipBehavior: Clip.antiAlias,
          semanticContainer: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius:
                    BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8))),
                child: Container(
                    width: ScreenUtil().setWidth(292),
                    height: ScreenUtil().setWidth(156),
                    child: GetBuilder<CollectionController>(
                        id: 'collection',
                        builder: (context) {
                          return collectionIllustCoverViewer(
                              controller.collectionList.value[index].cover);
                        })),
              ),
              Container(
                width: ScreenUtil().setWidth(279),
                height: ScreenUtil().setWidth(64),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GetBuilder<CollectionController>(
                        id: 'collection',
                        builder: (_) {
                          return Container(
                            width: 40.w,
                            child: Text(
                              controller.collectionList.value[index].title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: ScreenUtil().setSp(14)),
                            ),
                          );
                        }),
                    GetBuilder<CollectionController>(
                        id: 'collection',
                        builder: (_) {
                          return collectionTagViewer(
                              controller.collectionList.value[index].tagList);
                        }),
                    Container(
                      height: screen.setHeight(30),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: ScreenUtil().setWidth(2),
                              color: Colors.grey.shade300)),
                      child: ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setWidth(500))),
                        child: ExtendedImage.network(
                          userService.userInfo()!.avatar,
                          fit: BoxFit.cover,
                          // height: screen.setHeight(25),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget collectionIllustCoverViewer(List<Cover>? coverList) {
    if (coverList == null) {
      return Lottie.asset('assets/image/empty-status.json',
          repeat: true, height: ScreenUtil().setHeight(100));
    } else if (coverList.length < 3) {
      return ExtendedImage.network(
          getIt<PicUrlUtil>().dealUrl(
              coverList[0]
                  .medium!,
              ImageUrlLevel.large)
           ,
        fit: BoxFit.cover,
        headers: {'Referer': 'https://m.pixivic.com'},
      );
    } else if (coverList.length < 5) {
      return Stack(
        children: [
          Positioned(
              left: 0,
              top: 0,
              width: ScreenUtil().setWidth(146),
              height: ScreenUtil().setWidth(156),
              child: ExtendedImage.network(
                picUrlUtil.dealUrl(coverList[0].medium, ImageUrlLevel.medium),
                fit: BoxFit.cover,
                headers: {'Referer': 'https://m.pixivic.com'},
                height: 100,
                width: 100,
              )),
          Positioned(
              right: 0,
              top: 0,
              width: ScreenUtil().setWidth(146),
              height: ScreenUtil().setWidth(78),
              child: ExtendedImage.network(
                picUrlUtil.dealUrl(coverList[1].medium, ImageUrlLevel.medium),
                fit: BoxFit.cover,
                headers: {'Referer': 'https://m.pixivic.com'},
                height: 100,
                width: 100,
              )),
          Positioned(
              right: 0,
              bottom: 0,
              width: ScreenUtil().setWidth(146),
              height: ScreenUtil().setWidth(78),
              child: ExtendedImage.network(
    getIt<PicUrlUtil>().dealUrl(
        coverList[2]
            .medium!,
    ImageUrlLevel.large)
                ,
                fit: BoxFit.cover,
                headers: {'Referer': 'https://m.pixivic.com'},
                height: 100,
                width: 100,
              )),
        ],
      );
    } else if (coverList.length >= 5) {
      return Stack(
        children: [
          Positioned(
              left: 0,
              top: 0,
              width: ScreenUtil().setWidth(146),
              height: ScreenUtil().setWidth(156),
              child: ExtendedImage.network(
                picUrlUtil.dealUrl(coverList[0].medium, ImageUrlLevel.medium),
                fit: BoxFit.cover,
                headers: {'Referer': 'https://m.pixivic.com'},
              )),
          Positioned(
              right: 0,
              top: 0,
              width: ScreenUtil().setWidth(73),
              height: ScreenUtil().setWidth(78),
              child: ExtendedImage.network(
                picUrlUtil.dealUrl(coverList[1].medium, ImageUrlLevel.medium),
                fit: BoxFit.cover,
                headers: {'Referer': 'https://m.pixivic.com'},
              )),
          Positioned(
              right: 0,
              bottom: 0,
              width: ScreenUtil().setWidth(73),
              height: ScreenUtil().setWidth(78),
              child: ExtendedImage.network(
                picUrlUtil.dealUrl(coverList[2].medium, ImageUrlLevel.medium),
                //PicUrlUtil(url: coverList[2].medium).imageUrl,
                fit: BoxFit.cover,
                headers: {'Referer': 'https://m.pixivic.com'},
              )),
          Positioned(
              right: ScreenUtil().setWidth(73),
              bottom: 0,
              width: ScreenUtil().setWidth(73),
              height: ScreenUtil().setWidth(78),
              child: ExtendedImage.network(
                picUrlUtil.dealUrl(coverList[3].medium, ImageUrlLevel.medium),
                headers: {'Referer': 'https://m.pixivic.com'},
                fit: BoxFit.cover,
              )),
          Positioned(
              right: ScreenUtil().setWidth(73),
              top: 0,
              width: ScreenUtil().setWidth(73),
              height: ScreenUtil().setWidth(78),
              child: ExtendedImage.network(
                picUrlUtil.dealUrl(coverList[4].medium, ImageUrlLevel.medium),
                fit: BoxFit.cover,
                headers: {'Referer': 'https://m.pixivic.com'},
              )),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget collectionTagViewer(List<TagList> tagList) {
    String show = '';
    if (tagList.length <= 3) {
      for (int index = 0; index < tagList.length; index++) {
        show += '#${tagList[index].tagName}';
      }
    } else if (tagList.length > 3) {
      for (int index = 0; index < 3; index++) {
        show += '#${tagList[index].tagName}';
      }
    } else {
      show += ' ';
    }
    return Container(
      width: 180.h,
      child: Text(
        show,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: Colors.orange[300],
            fontWeight: FontWeight.w400,
            fontSize: ScreenUtil().setSp(11)),
      ),
    );
  }
}
