import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:hive/hive.dart';

import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/basic/pic_texts.dart';
import 'package:sharemoe/controller/global_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/data/model/user_info.dart';
import 'package:sharemoe/data/model/verification.dart';
import 'package:sharemoe/data/repository/user_base_repository.dart';
import 'package:sharemoe/routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController verificationController = TextEditingController();
  TextEditingController userPasswordRepeatController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String userName;
  String passWord;


  // final isLogin = Rx<bool>(false);
  final verificationImage = Rx<String>('');
  String verificationCode;

  @override
  void onInit() {
    getVerificationCode();
    super.onInit();
  }

  //login
  login() async {
    Map<String, String> body = {
      'username': userNameController.text,
      'password': userPasswordController.text
    };
    Map<String, String> header = {'Content-Type': 'application/json'};
    // var encoder = JsonEncoder.withIndent("     ");
    print(verificationCode);
    print(verificationController.text);
    UserInfo userInfo = await getIt<UserBaseRepository>()
        .queryUserLogin(verificationCode, verificationController.text, body)
        .catchError((Object obj) {
      final res = (obj as DioError).response;

    });
    Map<String, dynamic> data = {
      'id': userInfo.id,
      'permissionLevel': userInfo.permissionLevel,
      'star': userInfo.star,
      'name': userInfo.username,
      'email': userInfo.email,
      'permissionLevelExpireDate': userInfo.permissionLevelExpireDate,
      'avatarLink':
          'https://static.pixivic.net/avatar/299x299/${userInfo.id}.jpg',
      'isBindQQ': userInfo.isBindQQ,
      'isCheckEmail': userInfo.isCheckEmail,
    };

    picBox.putAll(data);
    if (userInfo.signature != null) picBox.put('signature', userInfo.signature);
    if (userInfo.location != null) picBox.put('location', userInfo.location);

    Get.find<GlobalController>().isLogin.value = true;
    Get.delete<LoginController>();
    BotToast.showSimpleNotification(title: TextZhLoginPage().loginSucceed);
    Get.find<WaterFlowController>(tag:'home').refreshIllustList();
  }

  //获取验证码
  getVerificationCode() async {
    Verification verification =
        await getIt<UserBaseRepository>().queryVerificationCode();
    verificationImage.value = verification.imageBase64;
    verificationCode = verification.vid;
  }
}
