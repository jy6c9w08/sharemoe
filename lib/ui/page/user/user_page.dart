import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:extended_image/extended_image.dart';
import 'package:sharemoe/basic/texts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:sharemoe/controller/user_controller.dart';

import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class UserPage extends GetView<UserController> {
  final ScreenUtil screen = ScreenUtil();
  final text = TextZhUserPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SappBar(title: '用户中心'),
        body: Stack(
          children: <Widget>[
            // background image
            Positioned(
              top: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                child: Image.asset(
                  'image/userpage_head.jpg',
                  width: screen.setWidth(324),
                  height: screen.setHeight(125),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            // user card
            Positioned(
              left: screen.setWidth(37),
              right: screen.setWidth(37),
              top: screen.setHeight(58),
              child: userCard(),
            ),
            Positioned(top: ScreenUtil().setHeight(180), child: optionList()),
          ],
        ));
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
              child: userDetailCell(text.info, 0)),
          Positioned(
              top: screen.setHeight(65),
              left: screen.setWidth(167),
              child: userDetailCell(text.fans, 0)),
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
            text.favorite),
        optionCell(
          FaIcon(
            FontAwesomeIcons.podcast,
            color: Colors.blue,
          ),
          text.follow,
        ),
        optionCell(
          FaIcon(
            FontAwesomeIcons.rocket,
            color: Colors.green,
          ),
          text.vipSpeed,
        ),
        optionCell(
          FaIcon(
            FontAwesomeIcons.history,
            color: Colors.grey,
          ),
          text.history,
        ),
        optionCell(
          FaIcon(
            FontAwesomeIcons.signOutAlt,
            color: Colors.orange,
          ),
          text.logout,
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

  Widget optionCell(FaIcon icon, String ext) {
    return Container(
      height: ScreenUtil().setHeight(40),
      width: ScreenUtil().setWidth(324),
      child: ListTile(
          onTap: () {
            if(ext==text.logout){
              Get.toNamed(Routes.LOGIN);
            }
           else{
              Get.toNamed(Routes.BOOKMARK);
            }
          },
          leading: icon,
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: Colors.grey,
          ),
          title: Text(ext, style: TextStyle(color: Colors.grey[700]))),
    );
  }
}
