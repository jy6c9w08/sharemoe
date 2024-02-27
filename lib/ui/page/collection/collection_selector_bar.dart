// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/controller/collection/collection_selector_controller.dart';

class CollectionSelectionBar extends GetView<CollectionSelectorCollector> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leadingWidth: 0,
      floating: true,
      pinned: true,
      automaticallyImplyLeading: false,
      actions: [action()],
      title: title(),
      toolbarHeight: controller.animation.value,
    );
  }

  Widget title() {
    return Row(
      children: [
        Text("已选", style: TextStyle(color: Colors.orange, fontSize: 14.sp)),
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
            getIt<UserService>().isLogin()
                ? controller.showAddToCollection()
                : BotToast.showSimpleNotification(
                    title: '用户未登录', hideCloseButton: true);

            break;
          case 'removeFromCollection':
            controller.removeFromCollection();
            break;
          case 'setCover':
            controller.setCollectionCover();
            break;
          case 'batchDownload':
            controller.batchDownload();
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

  List<PopupMenuEntry> popupMenu() {
    // print('selectMode: $selectMode');
    if (!Get.routing.current.contains('collection_detail'))
      return <PopupMenuItem>[
        PopupMenuItem(
          child: popupCell('添加至画集', FontAwesomeIcons.solidBookmark),
          value: 'addToCollection',
        ),
        PopupMenuItem(
          child: popupCell('批量下载', FontAwesomeIcons.download),
          value: 'batchDownload',
        ),
        PopupMenuItem(
          child: popupCell('退出多选', FontAwesomeIcons.doorOpen),
          value: 'exit',
        ),
      ];
    else if (Get.routing.current.contains('collection_detail'))
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
