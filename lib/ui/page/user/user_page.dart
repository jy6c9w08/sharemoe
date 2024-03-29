// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/ImageUrlLevel.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/util/pic_url_util.dart';
import 'package:sharemoe/basic/util/sharemoe_theme_util.dart';
import 'package:sharemoe/controller/theme_controller.dart';
import 'package:sharemoe/controller/user/user_controller.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class UserPage extends GetView<UserController> {
  final ScreenUtil screen = ScreenUtil();

  // final UserService userService = getIt<UserService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SappBar.normal(title: '个人中心'),
        body: GetBuilder<UserController>(
            init: UserController(),
            id: 'updateUserInfo',
            builder: (_) {
              return Container(
                padding: EdgeInsets.only(
                    top: screen.setHeight(7),
                    left: screen.setWidth(6),
                    right: screen.setWidth(6)),
                child: Column(
                  children: [
                    //头像
                    userAvatar(context),
                    SizedBox(height: screen.setHeight(12)),
                    //消息,会员,反馈,设置
                    Container(
                      height: screen.setHeight(55),
                      width: screen.screenWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              );
            }));
  }

//用户头像部分

  Widget userAvatar(BuildContext context) {
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
                                      controller.userInfo.avatar +
                                          '?t=${controller.time}'),
                                )
                              : ClipRect(
                                  child: ExtendedImage.file(
                                    controller.image!,
                                    height: screen.setHeight(200),
                                    fit: BoxFit.contain,
                                    mode: ExtendedImageMode.editor,
                                    enableLoadState: true,
                                    extendedImageEditorKey:
                                        controller.editorKey,
                                    cacheRawData: true,
                                    initEditorConfigHandler:
                                        (ExtendedImageState? state) {
                                      return EditorConfig(
                                          maxScale: 5.0,
                                          cropRectPadding:
                                              const EdgeInsets.all(20.0),
                                          hitTestSize: 20.0,
                                          initCropRectType:
                                              InitCropRectType.imageRect,
                                          cropAspectRatio:
                                              CropAspectRatios.ratio1_1);
                                    },
                                  ),
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
                              controller.userInfo.avatar +
                                  '?t=${controller.time}',
                              cache: true),
                        );
                      })),
            ),
            if (controller.userInfo.permissionLevel > 2)
              Positioned(
                right: 0,
                bottom: screen.setHeight(2),
                child: SvgPicture.asset('assets/icon/VIP_avatar.svg'),
                height: screen.setHeight(25),
              )
          ],
        ),
        SizedBox(
          width: screen.setWidth(5),
        ),
        Container(
          width: screen.setWidth(224),
          height: screen.setHeight(86),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: screen.setHeight(6)),
              Row(
                children: [
                  Text(
                    controller.userInfo.username,
                    style: TextStyle(fontSize: screen.setSp(15)),
                  ),
                  SvgPicture.asset(
                    'assets/icon/male.svg',
                    height: screen.setHeight(21),
                    width: screen.setWidth(21),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GetBuilder<UserController>(
                      id: 'updateVIP',
                      builder: (_) {
                        return Text(
                          controller.userInfo.permissionLevel <= 2
                              ? TextZhVIP.notVip
                              : TextZhVIP.endTime +
                                  DateFormat("yyyy-MM-dd").format(
                                      DateTime.parse(controller.userInfo
                                          .permissionLevelExpireDate!)),
                          style: TextStyle(
                              fontSize: screen.setSp(8),
                              color: Color(0xffA7A7A7)),
                        );
                      }),
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
                              color: Theme.of(context)
                                  .extension<CustomColors>()!
                                  .sharemoePink,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(screen.setWidth(3))),
                            ),
                            height: screen.setHeight(21),
                            width: screen.setWidth(58),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SvgPicture.asset(
                                  'assets/icon/calendar.svg',
                                  height: screen.setHeight(16),
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
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      print('积分');
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: screen.setWidth(2)),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .extension<CustomColors>()!
                            .sharemoePink,
                        borderRadius: BorderRadius.all(
                            Radius.circular(screen.setWidth(3))),
                      ),
                      height: screen.setHeight(21),
                      width: screen.setWidth(52),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SvgPicture.asset('assets/icon/coin.svg',
                              height: screen.setHeight(14),
                              colorFilter: ColorFilter.mode(
                                  Colors.white70, BlendMode.srcIn)
                              // color: Colors.white70,
                              ),
                          Text(
                            (controller.userInfo.star ?? 0).toString(),
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed(Routes.MODIFY_INFO);
                    },
                    child: GetBuilder<ThemeController>(
                        id: 'icon',
                        builder: (_) {
                          return Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(Get.context!)
                                    .colorScheme
                                    .background,
                                border: Border.all(
                                    width: 2,
                                    color: Theme.of(context)
                                        .extension<CustomColors>()!
                                        .sharemoePink!),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(screen.setWidth(3))),
                              ),
                              height: screen.setHeight(21),
                              width: screen.setWidth(113),
                              child: Text(
                                '修改个人资料',
                                style: TextStyle(
                                    color: Theme.of(Get.context!)
                                        .extension<CustomColors>()!
                                        .sharemoePink),
                              ));
                        }),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  ///不知道起什么名字好
  Widget userButton(String iconName, String text, int iconSize) {
    return Container(
      width: 50.w,
      child: InkWell(
        borderRadius: BorderRadius.zero,
        onTap: () {
          if (iconName == 'msg') {
            Get.toNamed(Routes.USER_MESSAGE_TYPE);
          } else if (iconName == 'setting')
            Get.toNamed(Routes.USER_SETTING);
          else if (iconName == 'vip')
            Get.toNamed(Routes.USER_VIP);
          else if (iconName == 'feedback') Get.toNamed(Routes.DISCUSSION);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Stack(
              children: [
                GetBuilder<ThemeController>(
                    id: 'icon',
                    builder: (_) {
                      return SvgPicture.asset(
                        'assets/icon/$iconName.svg',
                        height: screen.setHeight(iconSize),
                        colorFilter: ColorFilter.mode(
                            _.isDark
                                ? Color(0xff1C1B1F).withOpacity(0.4)
                                : Colors.white,
                            _.isDark ? BlendMode.srcATop : BlendMode.modulate),
                      );
                    }),
                if (iconName == 'msg')
                  Positioned(
                      top: 0,
                      right: 0,
                      child: GetBuilder<UserController>(
                          id: 'UnReadeMessageNumber',
                          builder: (_) {
                            return _.unReadMessageCount == 0
                                ? SizedBox()
                                : Container(
                                    alignment: Alignment.center,
                                    height: 16.w,
                                    width: 16.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                    child: Text(
                                      _.unReadMessageCount.toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                          }))
              ],
            ),
            Text(text)
          ],
        ),
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
        optionCell('assets/icon/collection.svg', TextZhUserPage.favorite),
        optionCell(
          'assets/icon/follow.svg',
          TextZhUserPage.follow,
        ),
        optionCell(
          'assets/icon/history.svg',
          TextZhUserPage.history,
        ),
        optionCell(
          'assets/icon/download.svg',
          "下载列表",
        ),
        optionCell(
          'assets/icon/logout.svg',
          TextZhUserPage.logout,
        )
      ],
    );
  }

  Widget optionCell(String imagePath, String text) {
    return ListTile(
        onTap: () {
          if (text == TextZhUserPage.logout) {
            controller.logout();
            //手动登出
          } else if (text == TextZhUserPage.follow) {
            Get.toNamed(Routes.ARTIST_LIST, arguments: controller.userInfo.id);
          } else if (text == TextZhUserPage.favorite) {
            Get.toNamed(Routes.BOOKMARK, arguments: controller.userInfo.id);
          } else if (text == TextZhUserPage.history) {
            Get.toNamed(Routes.HISTORY, arguments: 'history');
          } else if (text == "下载列表") {
            Get.toNamed(Routes.DOWNLOAD);
          } else {}
        },
        leading: GetBuilder<ThemeController>(
            id: 'icon',
            builder: (_) {
              return SvgPicture.asset(
                imagePath,
                height: screen.setHeight(23),
                colorFilter: ColorFilter.mode(
                  _.isDark ? Color(0xff1C1B1F).withOpacity(0.4) : Colors.white,
                  _.isDark ? BlendMode.srcATop : BlendMode.modulate,
                ),
              );
            }),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          color: Colors.grey,
        ),
        title: Text(text));
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
            color:
                Theme.of(Get.context!).extension<CustomColors>()!.sharemoePink,
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
                headers: {'Referer': 'https://m.pixivic.com'},
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
                      color: Theme.of(Get.context!)
                          .extension<CustomColors>()!
                          .sharemoePink),
                ),
              )
            ],
          ),
        )));
  }
}
