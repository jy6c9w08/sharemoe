import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bot_toast/bot_toast.dart';

import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/controller/global_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/data/model/user_info.dart';
import 'package:sharemoe/data/model/verification.dart';
import 'package:sharemoe/data/repository/user_base_repository.dart';

class LoginController extends GetxController {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userPasswordController = TextEditingController();
  final TextEditingController verificationController = TextEditingController();
  final TextEditingController userPasswordRepeatController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController smsController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController exchangeCodeController = TextEditingController();
  static final UserService userService = getIt<UserService>();
  static final UserBaseRepository userBaseRepository =
      getIt<UserBaseRepository>();

  late String userName;
  late String passWord;
  late bool isLogin;

  final verificationImage = Rx<String>('');
  late String verificationCode;

  @override
  void onInit() {
    isLogin = true;
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

  //切换登陆和注册页面
  void switchLoginModel() {
    userPasswordController.text = '';
    userPasswordController.text = '';
    userNameController.text = '';
    verificationController.text = '';
    userPasswordRepeatController.text = '';
    emailController.text = '';
    phoneNumberController.text = '';
    smsController.text = '';

    isLogin = !isLogin;
    update(['switchLogin']);
  }

//发送手机验证码
  sendPhoneCode() async {
    await userBaseRepository.queryMessageVerificationCode(verificationCode,
        verificationController.text, int.parse(phoneNumberController.text));
  }

  //注册
  register() async {
    Map<String, String> body = {
      'username': userNameController.text,
      'password': userPasswordController.text,
      'email': emailController.text,
      'exchangeCode': exchangeCodeController.text,
    };
    await userBaseRepository.queryUserRegisters(
        phoneNumberController.text, smsController.text, body);
  }
}
