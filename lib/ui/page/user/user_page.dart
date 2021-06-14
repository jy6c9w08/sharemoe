import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:extended_image/extended_image.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/basic/pic_texts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sharemoe/controller/global_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sharemoe/controller/user_controller.dart';

import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class UserPage extends GetView<UserController> {
  final ScreenUtil screen = ScreenUtil();
  final userText = TextZhUserPage();

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
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        // color: Colors.red,
                        // alignment: Alignment.center,
                        height: screen.setWidth(86),
                        width: screen.setWidth(83),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: screen.setHeight(25),
                          backgroundImage: ExtendedNetworkImageProvider(
                            controller.avatarLink.value,
                          ),
                        ),
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
                                  "生蚝QAQ",
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
                              "会员有效期至2021-10-10",
                              style: TextStyle(
                                  fontSize: screen.setSp(8),
                                  color: Color(0xffA7A7A7)),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                padding:
                                    EdgeInsets.only(left: screen.setWidth(2)),
                                decoration: BoxDecoration(
                                  color: Color(0xffFFC0CB),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(screen.setWidth(3))),
                                ),
                                height: screen.setHeight(21),
                                width: screen.setWidth(52),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SvgPicture.asset(
                                      'icon/coin.svg',
                                      height: screen.setHeight(14),
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "123",
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
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xffFFC0CB),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(screen.setWidth(3))),
                              ),
                              height: screen.setHeight(21),
                              width: screen.setWidth(58),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SvgPicture.asset(
                                    'icon/calendar.svg',
                                    height: screen.setHeight(16),
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "打卡",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Color(0xffFFC0CB)),
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
                        Row(
                          children: [],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: screen.setHeight(12)),
              Container(
                padding: EdgeInsets.only(
                    left: screen.setWidth(25), right: screen.setWidth(25)),
                height: screen.setHeight(55),
                width: screen.setWidth(269),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SvgPicture.asset(
                            'icon/msg.svg',
                            height: screen.setHeight(30),
                          ),
                          Text('消息')
                        ],
                      ),
                    ),
                    VerticalDivider(
                        color: Color(0xff868B92),
                        indent: screen.setHeight(9),
                        endIndent: screen.setHeight(29),
                        width: screen.setWidth(3)),
                    InkWell(
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SvgPicture.asset(
                              'icon/vip.svg',
                              height: screen.setHeight(30),
                            ),
                            Text('会员')
                          ],
                        )),
                    VerticalDivider(
                        color: Color(0xff868B92),
                        indent: screen.setHeight(9),
                        endIndent: screen.setHeight(29),
                        width: screen.setWidth(3)),
                    InkWell(
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SvgPicture.asset(
                              'icon/feedback.svg',
                              height: screen.setHeight(30),
                            ),
                            Text('反馈')
                          ],
                        )),
                    VerticalDivider(
                        color: Color(0xff868B92),
                        indent: screen.setHeight(9),
                        endIndent: screen.setHeight(29),
                        width: screen.setWidth(3)),
                    InkWell(
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SvgPicture.asset(
                              'icon/setting.svg',
                              height: screen.setHeight(30),
                            ),
                            Text('设置')
                          ],
                        )),
                  ],
                ),
              )
            ],
          ),
        )

        // Stack(
        //   children: <Widget>[
        //     // background image
        //     Positioned(
        //       top: 0,
        //       child: ClipRRect(
        //         borderRadius: BorderRadius.only(
        //           bottomLeft: Radius.circular(25),
        //           bottomRight: Radius.circular(25),
        //         ),
        //         child: Image.asset(
        //           'image/userpage_head.jpg',
        //           width: screen.setWidth(324),
        //           height: screen.setHeight(125),
        //           fit: BoxFit.fitWidth,
        //         ),
        //       ),
        //     ),
        //     // user card
        //     Positioned(
        //       left: screen.setWidth(37),
        //       right: screen.setWidth(37),
        //       top: screen.setHeight(58),
        //       child: userCard(),
        //     ),
        //     Positioned(top: ScreenUtil().setHeight(180), child: optionList()),
        //   ],
        // )

        );
  }

  Widget userCard() {
    return Container(
      width: ScreenUtil().setWidth(250),
      height: ScreenUtil().setHeight(115),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: ScreenUtil().setHeight(25),
            child: Container(
              width: screen.setWidth(250),
              height: screen.setHeight(90),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          Positioned(
            left: screen.setWidth(27),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: screen.setHeight(25),
              backgroundImage: ExtendedNetworkImageProvider(
                  controller.avatarLink.value,
                  headers: {'referer': 'https://pixivic.com'}),
            ),
          ),
          Positioned(
            top: ScreenUtil().setHeight(33),
            left: ScreenUtil().setWidth(90),
            child: GestureDetector(
              onLongPressEnd: ((LongPressEndDetails longPressEndDetails) {
                // print(longPressEndDetails.velocity.pixelsPerSecond.dx);
                // if (longPressEndDetails.velocity.pixelsPerSecond.dx < 0 &&
                //     Theme.of(context).platform == TargetPlatform.android) {
                //   print(6);
                //   prefs.setInt('sanityLevel', 6);
                // } else if (longPressEndDetails.velocity.pixelsPerSecond.dx >
                //     0 &&
                //     Theme.of(context).platform == TargetPlatform.android) {
                //   print(3);
                //   prefs.setInt('sanityLevel', 3);
                // }
              }),
              child: Text(
                '${controller.name.value}',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18.00),
              ),
              // child: Obx(
              //       () => Text(
              //     '${userDataController.name.value}',
              //     style: TextStyle(
              //         color: Colors.black,
              //         fontWeight: FontWeight.w400,
              //         fontSize: 18.00),
              //   ),
              // ),
            ),
          ),
          Positioned(
              top: screen.setHeight(65),
              left: screen.setWidth(67),
              child: userDetailCell(userText.info, 0)),
          Positioned(
              top: screen.setHeight(65),
              left: screen.setWidth(167),
              child: userDetailCell(userText.fans, 0)),
        ],
      ),
    );
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
            FaIcon(
              FontAwesomeIcons.solidHeart,
              color: Colors.red,
            ),
            userText.favorite),
        optionCell(
          FaIcon(
            FontAwesomeIcons.podcast,
            color: Colors.blue,
          ),
          userText.follow,
        ),
        optionCell(
          FaIcon(
            FontAwesomeIcons.rocket,
            color: Colors.green,
          ),
          userText.vipSpeed,
        ),
        optionCell(
          FaIcon(
            FontAwesomeIcons.history,
            color: Colors.grey,
          ),
          userText.history,
        ),
        optionCell(
          FaIcon(
            FontAwesomeIcons.download,
            color: Colors.grey,
          ),
          "下载列表",
        ),
        optionCell(
          FaIcon(
            FontAwesomeIcons.signOutAlt,
            color: Colors.orange,
          ),
          userText.logout,
          // () {
          //   showDialog(
          //       context: context,
          //       builder: (context) {
          //         return AlertDialog(
          //           title: Text(text.logout),
          //           content: Text(text.makerSureLogout),
          //           actions: <Widget>[
          //             FlatButton(
          //               child: Text("取消"),
          //               onPressed: () => Navigator.of(context).pop(), //关闭对话框
          //             ),
          //             FlatButton(
          //               child: Text("确定"),
          //               onPressed: () {
          //                 logout(context);
          //                 Navigator.of(context).pop(true); //关闭对话框
          //               },
          //             ),
          //           ],
          //         );
          //       });
          // }
        )
      ],
    );
  }

  Widget optionCell(FaIcon icon, String text) {
    return Container(
      height: ScreenUtil().setHeight(40),
      width: ScreenUtil().setWidth(324),
      child: ListTile(
          onTap: () {
            if (text == userText.logout) {
              picBox.put('auth', '');
              picBox.put('id', 0);
              picBox.put('permissionLevel', 0);
              picBox.put('star', 0);

              picBox.put('name', '');
              picBox.put('email', '');
              picBox.put('permissionLevelExpireDate', '');
              picBox.put('avatarLink', '');

              picBox.put('isBindQQ', false);
              picBox.put('isCheckEmail', false);
              Get.find<GlobalController>().isLogin.value = false;
            } else if (text == userText.follow) {
              Get.toNamed(Routes.ARTIST_LIST);
            } else if (text == userText.favorite) {
              Get.toNamed(Routes.BOOKMARK, arguments: 'bookmark');
            } else if (text == userText.history) {
              Get.toNamed(Routes.HISTORY, arguments: 'history');
            } else if (text == "下载列表") {
              ///下载页面UI
              // Get.toNamed(Routes.DOWNLOAD);
            } else {
              print("点击按钮");
            }
          },
          leading: icon,
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: Colors.grey,
          ),
          title: Text(text, style: TextStyle(color: Colors.grey[700]))),
    );
  }
}
