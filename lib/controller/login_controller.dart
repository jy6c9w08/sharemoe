import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bot_toast/bot_toast.dart';

import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/basic/util/pic_url_util.dart';
import 'package:sharemoe/controller/global_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/data/model/user_info.dart';
import 'package:sharemoe/data/model/verification.dart';
import 'package:sharemoe/data/repository/user_base_repository.dart';
import 'package:sharemoe/data/repository/vip_repository.dart';
import 'package:logger/logger.dart';
class LoginController extends GetxController {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController verificationController = TextEditingController();
  TextEditingController userPasswordRepeatController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  static final UserService userService=getIt<UserService>();
  static final UserBaseRepository userBaseRepository=getIt<UserBaseRepository>();

  late String userName;
  late String passWord;

  final verificationImage = Rx<String>('');
  late String verificationCode;

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
    print(verificationCode);
    print(verificationController.text);
    UserInfo userInfo = await userBaseRepository
        .queryUserLogin(verificationCode, verificationController.text, body)
        .catchError((Object obj) {});
    await userService.signIn(userInfo);
    Get.find<GlobalController>().isLogin.value = true;
    Get.delete<LoginController>();
    BotToast.showSimpleNotification(title: TextZhLoginPage().loginSucceed);
    Get.find<WaterFlowController>(tag: 'home').refreshIllustList();
  }

  //获取验证码
  getVerificationCode() async {
    Verification verification =
        await userBaseRepository.queryVerificationCode();
    verificationImage.value = verification.imageBase64;
    verificationCode = verification.vid;
  }
}
