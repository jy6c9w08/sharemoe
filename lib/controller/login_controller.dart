// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/controller/global_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/data/model/user_info.dart';
import 'package:sharemoe/data/model/verification.dart';
import 'package:sharemoe/data/repository/user_base_repository.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  late FocusNode usernameFocus;
  late FocusNode emailFocus;
  final GlobalKey formKey = GlobalKey<FormState>();

  final verificationImage = Rx<String>('');
  final loginOnLoading = Rx<bool>(false);
  late String verificationCode;

  @override
  void onInit() {
    isLogin = true;
    getVerificationCode();
    usernameFocus = FocusNode()..addListener(usernameFocusListener);
    emailFocus = FocusNode()..addListener(emailFocusListener);
    super.onInit();
  }

  usernameFocusListener() async {
    if (!usernameFocus.hasFocus &&
        userNameController.text.length >= 4 &&
        userNameController.text.length <= 10) {
      await getIt<UserBaseRepository>()
          .queryVerifyUserNameIsAvailable(userNameController.text);
    }
  }

  emailFocusListener() async {
    if (!emailFocus.hasFocus && GetUtils.isEmail(emailController.text))
      await getIt<UserBaseRepository>()
          .queryVerifyEmailIsAvailable(emailController.text);
  }

  //login
  login() async {
    // loginOnLoading.value=true;
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
          .catchError((error) {
        loginOnLoading.value = false;
        return error;
      });
      await userService.signIn(userInfo);
      loginOnLoading.value = false;
      Get.find<GlobalController>()
        ..isLogin.value = true
        ..setCookie();
      Get.find<WaterFlowController>(tag: 'home').refreshIllustList();
      Get.put(WaterFlowController(model: PicModel.RECOMMEND), tag: PicModel.RECOMMEND);
      Get.put(WaterFlowController(model: PicModel.UPDATE_ILLUST), tag: PicModel.UPDATE_ILLUST);
      Get.put(WaterFlowController(model: PicModel.UPDATE_MAGA), tag: PicModel.UPDATE_MAGA);
      BotToast.showSimpleNotification(
          title: TextZhLoginPage.loginSucceed, hideCloseButton: true);
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
    verificationController.clear();
    getVerificationCode();
    isLogin = !isLogin;
    update(['switchLogin']);
  }

//发送手机验证码
  sendPhoneCode() async {
    getVerificationCode();
    if (!await userBaseRepository
        .queryIsUserVerifyPhone(phoneNumberController.text)) {
      getVerificationCode();
      return false;
    }
    await userBaseRepository
        .queryMessageVerificationCode(verificationCode,
            verificationController.text, int.parse(phoneNumberController.text))
        .then((value) {
      Get.back();
    });
  }

  //注册
  register() async {
    if ((formKey.currentState as FormState).validate()) {
      if (!await getIt<UserBaseRepository>()
          .queryVerifyUserNameIsAvailable(userNameController.text))
        return false;
      if (!await getIt<UserBaseRepository>()
          .queryVerifyEmailIsAvailable(emailController.text)) return false;
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
        BotToast.showSimpleNotification(title: '注册成功', hideCloseButton: true);
        switchLoginModel();
      });
    }
  }

//选择表单控制器
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

//选择输入框后边的Icon
  Widget? chooseSuffixIcon(String model) {
    switch (model) {
      case 'loginPassword':
        return null;
      case 'loginUsername':
        return null;
      case 'registerRepeatPassword':
        return null;
      case 'registerUsername':
        return null;
      case 'registerPassword':
        return null;
      case 'verificationCode':
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          child: GestureDetector(
            onTap: () {
              getVerificationCode();
            },
            child: GetX<LoginController>(builder: (_) {
              return verificationImage.value != ''
                  ? Image.memory(
                      base64Decode(verificationImage.value),
                      width: 70.w,
                    )
                  : Container();
            }),
          ),
        );
      case 'registerEmail':
        return null;
      case 'exchangeCode':
        return MaterialButton(
          color: Colors.blue,
          textColor: Colors.white,
          onPressed: () => getDiaLog(model),
          child: Text(
            '获取',
          ),
        );

      case 'smsCode':
        return MaterialButton(
          color: Colors.blue,
          textColor: Colors.white,
          onPressed: () => getDiaLog(model),
          child: Text(
            '获取',
          ),
        );
      default:
        return null;
    }
  }

//发送手机验证码的弹窗
  getDiaLog(String model) {
    getVerificationCode();
    return model == 'smsCode'
        ? Get.dialog(AlertDialog(
            title: Text('获取短信验证码'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    getVerificationCode();
                  },
                  child: GetX<LoginController>(builder: (_) {
                    return verificationImage.value != ''
                        ? Image.memory(
                            base64Decode(verificationImage.value),
                            width: ScreenUtil().setWidth(70),
                          )
                        : Container();
                  }),
                ),
                TextField(
                  controller: verificationController,
                  decoration:
                      InputDecoration(hintText: TextZhLoginPage.verification),
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    return GetUtils.isPhoneNumber(value!) ? null : '请输入正确手机号码';
                  },
                  controller: phoneNumberController,
                  decoration:
                      InputDecoration(hintText: TextZhLoginPage.phoneNumber),
                ),
                SizedBox(height: 20.h),
                MaterialButton(
                  textColor: Colors.white,
                  color: Colors.green,
                  onPressed: () {
                    sendPhoneCode();
                  },
                  child: Text('获取验证码'),
                )
              ],
            ),
          ))
        : Get.dialog(AlertDialog(
            title: Text('提示'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(onPressed: () => jumpToZCTB(), child: Text('淘宝点我')),
                TextButton(onPressed: () => jumpToZCWD(), child: Text('微店点我')),
              ],
            ),
          ));
  }

  jumpToZCTB() async {
    if (await canLaunchUrlString(PicExternalLinkLink.ZCTB)) {
      await launchUrlString(PicExternalLinkLink.ZCTB);
    } else {
      throw 'Could not launch ${PicExternalLinkLink.ZCTB}';
    }
  }

  jumpToZCWD() async {
    if (await canLaunchUrlString(PicExternalLinkLink.ZCWD)) {
      await launchUrlString(PicExternalLinkLink.ZCWD);
    } else {
      throw 'Could not launch ${PicExternalLinkLink.ZCWD}';
    }
  }

//选择不同的表单验证
  FormFieldValidator<String>? chooseValidator(String model) {
    switch (model) {
      case 'loginPassword':
        return null;
      case 'loginUsername':
        return null;
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
        return (v) => GetUtils.isEmail(v!) ? null : '请输入正确邮箱';
      case 'exchangeCode':
        return (v) => v!.length == 16 ? null : '请输入16位邀请码';
      case 'smsCode':
        return (v) => v!.length == 6 ? null : '请输入6位验证码';
      default:
        return null;
    }
  }

  @override
  void onClose() {
    userNameController.dispose();
    userPasswordController.dispose();
    verificationController.dispose();
    userPasswordRepeatController.dispose();
    emailController.dispose();
    smsController.dispose();
    phoneNumberController.dispose();
    exchangeCodeController.dispose();
    super.onClose();
  }
}
