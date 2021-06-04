import 'package:flutter/material.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/basic/pic_texts.dart';
import 'package:sharemoe/controller/collection/collection_controller.dart';
import 'package:sharemoe/data/model/collection.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/widget/state_box.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:get/get.dart';
import 'package:extended_image/extended_image.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CollectionPage extends GetView<CollectionController> {
  final TextZhCommentCell texts = TextZhCommentCell();
  final ScreenUtil screen = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.normal(
        title: '画集',
      ),
      body: GetX<CollectionController>(
        builder: (_) {
          return controller.collectionList.value.isEmpty
              ? LoadingBox()
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return collectionCardCell(index);
                  },
                  itemCount: controller.collectionList.value.length,
                );
        },
      ),
    );
  }

  Widget collectionCardCell(int index) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.COLLECTION_DETAIL, arguments: index);
      },
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Card(
            color: Colors.white70,
            shadowColor: Colors.white70,
            elevation: 15.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            clipBehavior: Clip.antiAlias,
            semanticContainer: false,
            child: Container(
                width: screen.setWidth(292),
                height: screen.setWidth(220),
                child: Column(
                  children: [
                    ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setWidth(8))),
                      child: Container(
                          width: ScreenUtil().setWidth(292),
                          height: ScreenUtil().setWidth(156),
                          child: collectionIllustCoverViewer(
                              controller.collectionList.value[index].cover)),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(279),
                      height: ScreenUtil().setWidth(64),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GetBuilder<CollectionController>(
                              id: 'collectionTitle',
                              builder: (_) {
                                return Text(
                                  controller.collectionList.value[index].title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: ScreenUtil().setSp(14)),
                                );
                              }),
                          GetBuilder<CollectionController>(
                              id: 'collectionTitle',
                              builder: (_) {
                                return collectionTagViewer(controller
                                    .collectionList.value[index].tagList);
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
                                picBox.get('avatarLink'),
                                fit: BoxFit.cover,
                                // height: screen.setHeight(25),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          )),
    );
  }

  Widget collectionIllustCoverViewer(List<Cover>? coverList) {
    if (coverList == null) {
      return Lottie.asset('image/empty-status.json',
          repeat: true, height: ScreenUtil().setHeight(100));
    } else if (coverList.length < 3) {
      return ExtendedImage.network(
        coverList[0]
            .medium
            .replaceAll('https://i.pximg.net', 'https://acgpic.net'),
        fit: BoxFit.cover,
        headers: {'Referer': 'https://m.sharemoe.net/'},
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
                coverList[0]
                    .medium
                    .replaceAll('https://i.pximg.net', 'https://acgpic.net'),
                fit: BoxFit.cover,
                headers: {'Referer': 'https://m.sharemoe.net/'},
                height: 100,
                width: 100,
              )),
          Positioned(
              right: 0,
              top: 0,
              width: ScreenUtil().setWidth(146),
              height: ScreenUtil().setWidth(78),
              child: ExtendedImage.network(
                coverList[1]
                    .medium
                    .replaceAll('https://i.pximg.net', 'https://acgpic.net'),
                fit: BoxFit.cover,
                headers: {'Referer': 'https://m.sharemoe.net/'},
                height: 100,
                width: 100,
              )),
          Positioned(
              right: 0,
              bottom: 0,
              width: ScreenUtil().setWidth(146),
              height: ScreenUtil().setWidth(78),
              child: ExtendedImage.network(
                coverList[2]
                    .medium
                    .replaceAll('https://i.pximg.net', 'https://acgpic.net'),
                fit: BoxFit.cover,
                headers: {'Referer': 'https://m.sharemoe.net/'},
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
                coverList[0]
                    .medium
                    .replaceAll('https://i.pximg.net', 'https://acgpic.net'),
                fit: BoxFit.cover,
                headers: {'Referer': 'https://m.sharemoe.net/'},
              )),
          Positioned(
              right: 0,
              top: 0,
              width: ScreenUtil().setWidth(73),
              height: ScreenUtil().setWidth(78),
              child: ExtendedImage.network(
                coverList[1]
                    .medium
                    .replaceAll('https://i.pximg.net', 'https://acgpic.net'),
                fit: BoxFit.cover,
                headers: {'Referer': 'https://m.sharemoe.net/'},
              )),
          Positioned(
              right: 0,
              bottom: 0,
              width: ScreenUtil().setWidth(73),
              height: ScreenUtil().setWidth(78),
              child: ExtendedImage.network(
                coverList[2]
                    .medium
                    .replaceAll('https://i.pximg.net', 'https://acgpic.net'),
                fit: BoxFit.cover,
                headers: {'Referer': 'https://m.sharemoe.net/'},
              )),
          Positioned(
              right: ScreenUtil().setWidth(73),
              bottom: 0,
              width: ScreenUtil().setWidth(73),
              height: ScreenUtil().setWidth(78),
              child: ExtendedImage.network(
                coverList[3]
                    .medium
                    .replaceAll('https://i.pximg.net', 'https://acgpic.net'),
                headers: {'Referer': 'https://m.sharemoe.net/'},
                fit: BoxFit.cover,
              )),
          Positioned(
              right: ScreenUtil().setWidth(73),
              top: 0,
              width: ScreenUtil().setWidth(73),
              height: ScreenUtil().setWidth(78),
              child: ExtendedImage.network(
                coverList[4]
                    .medium
                    .replaceAll('https://i.pximg.net', 'https://acgpic.net'),
                fit: BoxFit.cover,
                headers: {'Referer': 'https://m.sharemoe.net/'},
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
    return Text(
      show,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: Colors.orange[300],
          fontWeight: FontWeight.w400,
          fontSize: ScreenUtil().setSp(11)),
    );
  }
}
