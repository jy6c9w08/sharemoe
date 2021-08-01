import 'package:flutter/material.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/controller/user/vip_controller.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:extended_image/extended_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

class VIPPage extends GetView<VIPController> {
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
          title: Text('jy6c9w08'),
          subtitle:
              Padding(padding: EdgeInsets.only(top: 15), child: Text('还不是会员')),
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
              '兑换码',
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp),
            ),
            TextField(
              controller: controller.codeInputTextEditingController,
            ),
            TextButton(
              onPressed: () {},
              child: Text('立即兑换'),
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
                    onPressed: () {},
                    icon: FaIcon(
                      FontAwesomeIcons.alipay,
                      color: Colors.blue,
                      size: 26.sp,
                    )),
                IconButton(
                    onPressed: () {},
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
                  '了解如何使用兑换码',
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
