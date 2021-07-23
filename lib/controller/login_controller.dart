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
  final GlobalKey formKey = GlobalKey<FormState>();

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
    if ((formKey.currentState as FormState).validate()) {
      //验证通过提交数据
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
    (formKey.currentState as FormState).reset();

    isLogin = !isLogin;
    update(['switchLogin']);
  }

//发送手机验证码
  sendPhoneCode() async {
    await userBaseRepository
        .queryMessageVerificationCode(verificationCode,
            verificationController.text, int.parse(phoneNumberController.text))
        .then((value) {
      Get.back();
    });
  }

  //注册
  register() async {
    Map<String, String> body = {
      'username': userNameController.text,
      'password': userPasswordController.text,
      'email': emailController.text,
      'exchangeCode': exchangeCodeController.text,
    };
    await userBaseRepository
        .queryUserRegisters(
            phoneNumberController.text, smsController.text, body)
        .then((value) {
      BotToast.showSimpleNotification(title: '注册成功');
      switchLoginModel();
    });
  }

  TextEditingController chooseEditionController(String model) {
    switch (model) {
      case 'loginPassword':
        return userPasswordController;
      case 'loginUsername':
        return userNameController;
      case 'registerRepeatPassword':
        return userPasswordRepeatController;
      case 'registerUsername':
        return userNameController;
      case 'registerPassword':
        return userPasswordController;
      case 'verificationCode':
        return verificationController;
      case 'registerEmail':
        return emailController;
      case 'exchangeCode':
        return exchangeCodeController;
      case 'smsCode':
        return smsController;
      default:
        return userPasswordController;
    }
  }

  FormFieldValidator<String>? chooseValidator(String model) {
    switch (model) {
      case 'loginPassword':
        return null;
      case 'loginUsername':
        return (v) =>
            v!.trim().length >= 4 && v.trim().length <= 10 ? null : "用户名4-10位";
      case 'registerRepeatPassword':
        return (v) => v != userPasswordController.text ? "两次输入密码不同" : null;
      case 'registerUsername':
        return (v) =>
            v!.trim().length >= 4 && v.trim().length <= 10 ? null : "用户名4-10位";
      case 'registerPassword':
        return (v) =>
        v!.trim().length >= 8 && v.trim().length <= 20 ? null : "密码8-20位";
      case 'verificationCode':
        return null;
      case 'registerEmail':
        return null;
      case 'exchangeCode':
        return (value) {
          RegExp reg = new RegExp(r'^\d{16}$');
          if (!reg.hasMatch(value!)) {
            return '请输入16位邀请码';
          }
          return null;
        };
      case 'smsCode':
        return null;
      default:
        return null;
    }
  }
}
