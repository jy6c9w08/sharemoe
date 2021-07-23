import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:extended_image/extended_image.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/ImageUrlLevel.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:intl/intl.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/basic/util/pic_url_util.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sharemoe/controller/user/user_controller.dart';

import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class UserPage extends GetView<UserController> {
  final ScreenUtil screen = ScreenUtil();
  final userText = TextZhUserPage();
  final UserService userService = getIt<UserService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SappBar.normal(title: '个人中心'),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.only(
              top: screen.setHeight(7),
              left: screen.setWidth(6),
              right: screen.setWidth(6)),
          child: Column(
            children: [
              //头像
              userAvatar(),
              SizedBox(height: screen.setHeight(12)),
              //消息,会员,反馈,设置
              Container(
                height: screen.setHeight(55),
                width: screen.setWidth(269),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    userButton('msg', '消息', 30),
                    userVerticalDivider(),
                    userButton('vip', '会员', 27),
                    userVerticalDivider(),
                    userButton('feedback', '反馈', 32),
                    userVerticalDivider(),
                    userButton('setting', '设置', 28),
                  ],
                ),
              ),
              SizedBox(height: screen.setHeight(12)),
              optionList()
            ],
          ),
        ));
  }

//用户头像部分

  Widget userAvatar() {
    return Row(
      children: [
        //头像
        Stack(
          children: [
            GestureDetector(
              onTap: () {
                Get.dialog(GetBuilder<UserController>(
                    id: 'getImage',
                    builder: (_) {
                      return AlertDialog(
                          actions: [
                            TextButton(
                                onPressed: () {
                                  controller.getImage();
                                },
                                child: Text('选择图片')),
                            TextButton(
                                onPressed: () {
                                  controller.cropImage();
                                  Get.back();
                                },
                                child: Text('上传头像'))
                          ],
                          content: controller.image == null
                              ? Container(
                                  height: screen.setHeight(200),
                                  child: ExtendedImage.network(
                                      controller.userInfo.value.avatar),
                                )
                              : ExtendedImage.file(
                                  controller.image!,
                                  height: screen.setHeight(200),
                                  fit: BoxFit.contain,
                                  mode: ExtendedImageMode.editor,
                                  enableLoadState: true,
                                  extendedImageEditorKey: controller.editorKey,
                                  cacheRawData: true,
                                  initEditorConfigHandler:
                                      (ExtendedImageState? state) {
                                    return EditorConfig(
                                        maxScale: 8.0,
                                        cropRectPadding:
                                            const EdgeInsets.all(20.0),
                                        hitTestSize: 20.0,
                                        initCropRectType:
                                            InitCropRectType.imageRect,
                                        cropAspectRatio:
                                            CropAspectRatios.ratio1_1,
                                        editActionDetailsIsChanged:
                                            (EditActionDetails? details) {
                                          print(details?.totalScale);
                                        });
                                  },
                                ));
                    }));
              },
              child: Container(
                  height: screen.setWidth(86),
                  width: screen.setWidth(83),
                  child: GetBuilder<UserController>(
                      id: 'updateImage',
                      builder: (_) {
                        return CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: screen.setHeight(25),
                          backgroundImage: ExtendedNetworkImageProvider(
                              controller.userInfo.value.avatar +
                                  '?t=${controller.time}',
                              cache: false),
                        );
                      })),
            ),
            Positioned(
              right: 0,
              bottom: screen.setHeight(2),
              child: SvgPicture.asset('icon/VIP_avatar.svg'),
              height: screen.setHeight(25),
            )
          ],
        ),
        SizedBox(
          width: screen.setWidth(5),
        ),
        Container(
          // color: Colors.red,
          width: screen.setWidth(224),
          height: screen.setHeight(86),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: screen.setHeight(6)),
                  Row(
                    children: [
                      Text(
                        userService.userInfo()!.username,
                        style: TextStyle(fontSize: screen.setSp(15)),
                      ),
                      SvgPicture.asset(
                        'icon/male.svg',
                        height: screen.setHeight(21),
                        width: screen.setWidth(21),
                      ),
                    ],
                  ),
                  Text(
                    controller.userInfo.value.permissionLevelExpireDate ==
                                null ||
                            DateTime.now().isAfter(DateTime.parse(controller
                                .userInfo.value.permissionLevelExpireDate!))
                        ? TextZhVIP.notVip
                        : TextZhVIP.endTime +
                            DateFormat("yyyy-MM-dd").format(DateTime.parse(
                                controller.userInfo.value
                                    .permissionLevelExpireDate!)),
                    style: TextStyle(
                        fontSize: screen.setSp(8), color: Color(0xffA7A7A7)),
                  ),
                  InkWell(
                    onTap: () {
                      print('积分');
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: screen.setWidth(2)),
                      decoration: BoxDecoration(
                        color: Color(0xffFFC0CB),
                        borderRadius: BorderRadius.all(
                            Radius.circular(screen.setWidth(3))),
                      ),
                      height: screen.setHeight(21),
                      width: screen.setWidth(52),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SvgPicture.asset(
                            'icon/coin.svg',
                            height: screen.setHeight(14),
                            color: Colors.white,
                          ),
                          Text(
                            controller.userInfo.value.star.toString(),
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: screen.setWidth(14),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: screen.setHeight(33)),
                  GetBuilder<UserController>(
                      id: 'updateSign',
                      builder: (_) {
                        return InkWell(
                          onTap: () {
                            print('打卡');
                            if (!controller.isSignIn)
                              controller.postDaily().then((value) {
                                dailyDialog();
                              });
                            // dailyDialog();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0xffFFC0CB),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(screen.setWidth(3))),
                            ),
                            height: screen.setHeight(21),
                            width: screen.setWidth(58),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SvgPicture.asset(
                                  'icon/calendar.svg',
                                  height: screen.setHeight(16),
                                  color: Colors.white,
                                ),
                                Text(
                                  controller.isSignIn ? "已打卡" : "打卡",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                  InkWell(
                    onTap: () {},
                    child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 2, color: Color(0xffFFC0CB)),
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(screen.setWidth(3))),
                        ),
                        height: screen.setHeight(21),
                        width: screen.setWidth(113),
                        child: Text(
                          '修改个人资料',
                          style: TextStyle(color: Color(0xffFFC0CB)),
                        )),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  ///不知道起什么名字好
  Widget userButton(String iconName, String text, int iconSize) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.USER_SETTING);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgPicture.asset(
            'icon/$iconName.svg',
            height: screen.setHeight(iconSize),
          ),
          Text(text)
        ],
      ),
    );
  }

  Widget userVerticalDivider() {
    return VerticalDivider(
        color: Color(0xff868B92),
        indent: screen.setHeight(9),
        endIndent: screen.setHeight(29),
        width: screen.setWidth(3));
  }

  Widget userDetailCell(String label, int number) {
    return Column(
      children: <Widget>[
        Text(
          '$number',
          style: TextStyle(
            color: Colors.blueAccent[200],
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(5),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        )
      ],
    );
  }

  Widget optionList() {
    return Column(
      children: <Widget>[
        optionCell(
            SvgPicture.asset(
              'icon/collection.svg',
              height: screen.setHeight(23),
            ),
            userText.favorite),
        optionCell(
          SvgPicture.asset(
            'icon/follow.svg',
            height: screen.setHeight(23),
          ),
          userText.follow,
        ),
        optionCell(
          SvgPicture.asset(
            'icon/history.svg',
            height: screen.setHeight(23),
          ),
          userText.history,
        ),
        optionCell(
          SvgPicture.asset(
            'icon/download.svg',
            height: screen.setHeight(23),
          ),
          "下载列表",
        ),
        optionCell(
          SvgPicture.asset(
            'icon/logout.svg',
            height: screen.setHeight(23),
          ),
          userText.logout,
        )
      ],
    );
  }

  Widget optionCell(Widget icon, String text) {
    return ListTile(
        onTap: () {
          if (text == userText.logout) {
            controller.deleteUserInfo();
            //手动登出
            getIt<UserService>().signOutByUser();
          } else if (text == userText.follow) {
            Get.toNamed(Routes.ARTIST_LIST);
          } else if (text == userText.favorite) {
            Get.toNamed(Routes.BOOKMARK, arguments: 'bookmark');
          } else if (text == userText.history) {
            Get.toNamed(Routes.HISTORY, arguments: 'history');
          } else if (text == "下载列表") {
            Get.toNamed(Routes.DOWNLOAD);
          } else {}
        },
        leading: icon,
        trailing: Icon(
          Icons.keyboard_arrow_right,
          color: Colors.grey,
        ),
        title: Text(text, style: TextStyle(color: Colors.grey[700])));
  }

  dailyDialog() {
    Get.dialog(AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        titlePadding: EdgeInsets.only(top: 15, left: 20),
        contentPadding: EdgeInsets.fromLTRB(0, 15.0, 0, 0.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screen.setWidth(15))),
        title: Text(
          '今日签到卡片',
          style: TextStyle(
            color: Color(0xffFFC0CB),
          ),
        ),
        content: Container(
          constraints: BoxConstraints(
            minWidth: screen.screenWidth - 20,
            minHeight: screen.setHeight(250),
            maxHeight: screen.setHeight(350),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExtendedImage.network(
                getIt<PicUrlUtil>()
                    .dealUrl(controller.dailyImageUrl, ImageUrlLevel.medium),
                cache: false,
                headers: {'Referer': 'https://m.sharemoe.net/'},
                fit: BoxFit.cover,
                height: screen.setHeight(200),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: screen.setWidth(20)),
                alignment: Alignment.center,
                child: Text(
                  controller.dailySentence,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: screen.setSp(12),
                  ),
                ),
              ),
              Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: screen.setWidth(20)),
                  alignment: Alignment.bottomRight,
                  child: Text('--《${controller.originateFrom}》',
                      style: TextStyle(
                        fontSize: screen.setSp(12),
                      ))),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  '知道啦',
                  style: TextStyle(
                      color: Color(0xffFFC0CB), fontSize: screen.setSp(16)),
                ),
              )
            ],
          ),
        )));
  }
}
