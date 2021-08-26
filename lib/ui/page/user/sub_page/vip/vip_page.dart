// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/controller/user/user_controller.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class VIPPage extends GetView<UserController> {
  VIPPage({Key? key}) : super(key: key);
  final UserService userService = getIt<UserService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.normal(title: '会员'),
      body: Container(
        width: 1.sw,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              topTitle(),
              useExchangeCode(),
              howToUseExchangeCode(),
            ],
          ),
        ),
      ),
    );
  }

  Widget topTitle() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Container(
        alignment: Alignment.center,
        width: 293.w,
        height: 112.h,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 25.h,
            backgroundImage:
                ExtendedNetworkImageProvider(userService.userInfo()!.avatar),
          ),
          title: Text(controller.userInfo.username),
          subtitle: Padding(
              padding: EdgeInsets.only(top: 15),
              child: GetBuilder<UserController>(
                  id: 'updateVIP',
                  builder: (_) {
                    return Text(
                      controller.userInfo.permissionLevel <= 2
                          ? TextZhVIP.notVip
                          : TextZhVIP.endTime +
                              DateFormat("yyyy-MM-dd").format(DateTime.parse(
                                  controller
                                      .userInfo.permissionLevelExpireDate!)),
                      style:
                          TextStyle(fontSize: 10.sp, color: Color(0xffA7A7A7)),
                    );
                  })),
        ),
      ),
    );
  }

  Widget useExchangeCode() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Container(
        width: 293.w,
        padding: EdgeInsets.only(top: 15, left: 30, right: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              TextZhVIP.code,
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp),
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (v) => v!.length == 16 ? null : '请输入16位兑换码',
              controller: controller.codeInputTextEditingController,
            ),
            TextButton(
              onPressed: () => controller.getVIP(),
              child: Text(TextZhVIP.convert),
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.orange),
                  textStyle: MaterialStateProperty.all(TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w300,
                      fontSize: 12.sp))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () => controller.jumpToVIPTB(),
                    icon: FaIcon(
                      FontAwesomeIcons.alipay,
                      color: Colors.blue,
                      size: 26.sp,
                    )),
                IconButton(
                    onPressed: () => controller.jumpToVIPWD(),
                    icon: FaIcon(
                      FontAwesomeIcons.weixin,
                      color: Colors.green,
                      size: 26.sp,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget howToUseExchangeCode() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Container(
        width: 293.w,
        height: 108.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Lottie.asset(
              'image/train-speed.json',
              repeat: true,
              height: 66.h,
            ),
            TextButton(
                onPressed: () {},
                child: Text(
                  TextZhVIP.learnMore,
                  style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w300,
                      fontSize: 12.sp),
                ))
          ],
        ),
      ),
    );
  }
}
