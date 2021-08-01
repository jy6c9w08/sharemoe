// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

// Project imports:
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/controller/collection/collection_controller.dart';
import 'package:sharemoe/controller/collection/collection_selector_controller.dart';

class CollectionSelectionBar extends GetView<CollectionSelectorCollector> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leadingWidth: 0,
      backgroundColor: Colors.white,
      floating: true,
      pinned: true,
      actions: [action()],
      title: title(),
      toolbarHeight: controller.animation.value,
    );
  }

  Widget title() {
    return Row(
      children: [
        FaIcon(
          FontAwesomeIcons.times,
          color: Colors.orange,
          size: ScreenUtil().setWidth(14),
        ),
        SizedBox(
          width: ScreenUtil().setWidth(10),
        ),
        Text(
          controller.selectList.length.toString(),
          style: TextStyle(fontSize: 16, color: Colors.orange),
        )
      ],
    );
  }

  Widget action() {
    return PopupMenuButton(
      onSelected: (value) {
        switch (value) {
          case 'exit':
            controller.clearSelectList();
            break;
          case 'addToCollection':
            showAddToCollection();
            break;
          case 'removeFromCollection':
            controller.removeFromCollection();
            break;
          case 'setCover':
            controller.setCollectionCover();
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return popupMenu();
      },
      child: Icon(
        Icons.more_vert,
        color: Colors.orange,
        size: ScreenUtil().setWidth(23),
      ),
    );
  }

  showAddToCollection() {
    final screen = ScreenUtil();
    return Get.dialog(GetX<CollectionController>(
      init: CollectionController(),
      builder: (_) {
        return _.collectionList.value.isEmpty
            ? AlertDialog(
                content: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Lottie.asset('image/empty-box.json',
                        repeat: false, height: ScreenUtil().setHeight(80)),
                    Container(
                      // width: screen.setWidth(300),
                      padding: EdgeInsets.only(top: screen.setHeight(8)),
                      child: Text(TextZhPicDetailPage.addFirstCollection),
                    ),
                    Container(
                      width: screen.setWidth(100),
                      padding: EdgeInsets.only(top: screen.setHeight(8)),
                      child: TextButton(
                        child: Icon(Icons.add),
                        onPressed: () {
                          // Navigator.of(context).pop();
                          controller.showCollectionInfoEditDialog();
                        },
                      ),
                    )
                  ],
                ),
              )
            : AlertDialog(
                scrollable: true,
                content: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.only(bottom: screen.setHeight(5)),
                          alignment: Alignment.center,
                          child: Text(
                            TextZhPicDetailPage.addToCollection,
                            style: TextStyle(color: Colors.orangeAccent),
                          )),
                      Container(
                        height: 400,
                        // height: screen.setHeight(tuple2.item1.length <= 7
                        //     ? screen.setHeight(50) * tuple2.item1.length
                        //     : screen.setHeight(50) * 7),
                        width: screen.setWidth(250),
                        child: ListView.builder(
                            itemCount: _.collectionList.value.length,
                            itemBuilder: (context, int index) {
                              return Container(
                                child: ListTile(
                                  title:
                                      Text(_.collectionList.value[index].title),
                                  subtitle: Text(
                                      _.collectionList.value[index].caption),
                                  onTap: () {
                                    controller.addIllustToCollection(
                                        _.collectionList.value[index].id);
                                  },
                                ),
                              );
                            }),
                      ),
                      Container(
                          width: screen.setWidth(100),
                          padding: EdgeInsets.only(top: screen.setHeight(8)),
                          child: TextButton(
                              child: Icon(Icons.add),
                              onPressed: () {
                                // Navigator.of(context).pop();
                                controller.showCollectionInfoEditDialog();
                              })),
                    ]),
              );
      },
    ));
  }

  List<PopupMenuEntry> popupMenu() {
    // print('selectMode: $selectMode');
    if (controller.selectMode)
      return <PopupMenuItem>[
        PopupMenuItem(
          child: popupCell('添加至画集', FontAwesomeIcons.solidBookmark),
          value: 'addToCollection',
        ),
        PopupMenuItem(
          child: popupCell('退出多选', FontAwesomeIcons.doorOpen),
          value: 'exit',
        ),
      ];
    else if (!controller.selectMode)
      return <PopupMenuItem>[
        PopupMenuItem(
          child: popupCell('移除图片', FontAwesomeIcons.solidTrashAlt),
          value: 'removeFromCollection',
        ),
        PopupMenuItem(
          child: popupCell('设为封面', FontAwesomeIcons.book),
          value: 'setCover',
        ),
        PopupMenuItem(
          child: popupCell('退出多选', FontAwesomeIcons.doorOpen),
          value: 'exit',
        ),
      ];
    else
      return [];
  }

  Widget popupCell(String text, IconData fontAwesomeIcons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FaIcon(
          fontAwesomeIcons,
          color: Colors.orange,
          size: ScreenUtil().setWidth(12),
        ),
        Text(text)
      ],
    );
  }
}
