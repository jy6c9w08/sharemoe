// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bot_toast/bot_toast.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/controller/theme_controller.dart';
import 'package:sharemoe/data/model/user_info.dart';
import 'package:sharemoe/data/model/verification.dart';
import 'package:sharemoe/data/repository/user_base_repository.dart';
import 'package:url_launcher/url_launcher_string.dart';

// Project imports:

class LocalSettingController extends GetxController {
  // final LocalSetting localSetting = picBox.get('localSetting');
  late UserInfo userInfo = getIt<UserService>().userInfo()!;
  late bool? is16R = getIt<UserService>().r16FromHive();
  late Rx<int> imageCash = Rx<int>(0);
  late int waterNumber = userService.waterNumber();
  late String themeState;
  late bool spareKeyboard = userService.spareKeyboard();
  static final UserBaseRepository userBaseRepository =
      getIt<UserBaseRepository>();
  static final UserService userService = getIt<UserService>();

  //姓名
  final TextEditingController nameController = TextEditingController();

  //手机号
  final TextEditingController phoneNumberController = TextEditingController();

  //身份证
  final TextEditingController identityCardController = TextEditingController();

  //图片验证码
  final TextEditingController verificationController = TextEditingController();

  //认证兑换码
  final TextEditingController redemptionController = TextEditingController();

//短信验证码
  final TextEditingController smsController = TextEditingController();

  final verificationImage = Rx<String>('');
  late String verificationCode;
  final GlobalKey formKey = GlobalKey<FormState>();

  //获取验证码
  getVerificationCode() async {
    Verification verification =
        await userBaseRepository.queryVerificationCode();
    verificationImage.value = verification.imageBase64;
    verificationCode = verification.vid;
  }

  //发送手机验证码
  sendPhoneCode() async {
    if (!await userBaseRepository
        .queryIsUserVerifyPhone(phoneNumberController.text)) {
      getVerificationCode();
      return false;
    }
    await userBaseRepository
        .queryMessageVerificationCode(verificationCode,
            verificationController.text, int.parse(phoneNumberController.text))
        .then((value) {
      BotToast.showSimpleNotification(title: '发送成功', hideCloseButton: true);
      // Get.back();
    });
  }

  changeSpareKeyboard(bool value) {
    userService.setSpareKeyboard(value);
    spareKeyboard = value;
    update(['updateSpareKeyboard']);
  }

  changeR16(bool value) {
    userService.setR16(value);
    is16R = value;
    update(['updateR16']);
  }

  verifyPhone() {
    getVerificationCode();
    return Get.dialog(AlertDialog(
      title: Text('绑定手机'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                getVerificationCode();
              },
              child: GetX<LocalSettingController>(builder: (_) {
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
              decoration: InputDecoration(
                  hintText: TextZhLoginPage.phoneNumber,
                  suffixIcon: TextButton(
                    child: Text('获取验证码'),
                    onPressed: () {
                      sendPhoneCode();
                    },
                  )),
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: smsController,
              decoration: InputDecoration(
                hintText: TextZhLoginPage.smsCode,
              ),
            ),
            SizedBox(height: 20.h),
            MaterialButton(
              textColor: Colors.white,
              color: Colors.green,
              onPressed: () => phoneBinding(),
              child: Text('立即绑定'),
            )
          ],
        ),
      ),
    ));
  }

  verifyR16() {
    return Get.dialog(AlertDialog(
      title: Text('实名认证'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('实名认证需要兑换码'),
          TextButton(onPressed: () => jumpToRZWD(), child: Text('微店获取')),
          TextButton(onPressed: () => jumpToRZTB(), child: Text('淘宝获取')),
          TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: '姓名'),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: redemptionController,
            decoration: InputDecoration(
              hintText: '认证兑换码',
            ),
            validator: (v) {
              return v!.length == 16 ? null : '请输入16位兑换码';
            },
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (v) {
              return v!.length == 18 ? null : '请输入18位身份证';
            },
            controller: identityCardController,
            decoration: InputDecoration(
              hintText: '身份证',
            ),
          ),
          SizedBox(height: 20.h),
          MaterialButton(
            textColor: Colors.white,
            color: Colors.green,
            onPressed: () {
              authenticated();
            },
            child: Text('立即绑定'),
          )
        ],
      ),
    ));
  }

  jumpToRZTB() async {
    if (await canLaunchUrlString(PicExternalLinkLink.RZTB)) {
      await launchUrlString(PicExternalLinkLink.RZTB);
    } else {
      throw 'Could not launch ${PicExternalLinkLink.RZTB}';
    }
  }

  jumpToRZWD() async {
    if (await canLaunchUrlString(PicExternalLinkLink.RZWD)) {
      await launchUrlString(PicExternalLinkLink.RZWD);
    } else {
      throw 'Could not launch ${PicExternalLinkLink.RZWD}';
    }
  }

  //三要素认证
  authenticated() async {
    Map<String, dynamic> body = {
      'name': nameController.text,
      'exchangeCode': redemptionController.text,
      'idCard': identityCardController.text
    };
    getIt<UserBaseRepository>()
        .queryAuthenticated(userInfo.id, body)
        .then((value) {
      userInfo = value;
      getIt<UserService>().updateUserInfo(userInfo);
      getIt<UserService>().setR16(true);
      is16R = true;
      update(['updateR16']);

      BotToast.showSimpleNotification(title: '认证成功', hideCloseButton: true);

      Get.back();
    });
  }

  //手机绑定
  phoneBinding() {
    getIt<UserBaseRepository>()
        .queryPhoneBinding(
            userInfo.id, phoneNumberController.text, smsController.text)
        .then((value) {
      userInfo = value;
      getIt<UserService>().updateUserInfo(userInfo);
      update(['updateR16']);
      BotToast.showSimpleNotification(title: '认证成功', hideCloseButton: true);
      Get.back();
    });
  }

  setThemeModel(ThemeMode themeMode) {
    Get.changeThemeMode(themeMode);
    Future.delayed(Duration(milliseconds: 500))
        .then((value) => Get.find<ThemeController>()
          ..isDark = Get.isDarkMode
          ..updateThemeIcon());
    userService.setThemeModel(themeMode);
    if (themeMode == ThemeMode.dark) themeState = '夜间';
    if (themeMode == ThemeMode.light) themeState = '日间';
    if (themeMode == ThemeMode.system) themeState = '跟随系统';
    Get.back();
    update(['themeMode']);
  }

  setWaterNumber(int number) {
    waterNumber = number;
    userService.setWaterNumber(number);
    Get.back();
    BotToast.showSimpleNotification(title: '重启应用生效', hideCloseButton: true);
    update(['waterNumber']);
  }

  waterBottomSheet() {
    return Get.bottomSheet(
        Container(
          width: ScreenUtil().screenWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(onPressed: () => setWaterNumber(1), child: Text('1')),
              TextButton(onPressed: () => setWaterNumber(2), child: Text('2')),
              TextButton(onPressed: () => setWaterNumber(3), child: Text('3')),
              TextButton(onPressed: () => setWaterNumber(4), child: Text('4')),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        backgroundColor:
            Theme.of(Get.context!).bottomSheetTheme.backgroundColor);
  }

  themeModeBottomSheet() {
    return Get.bottomSheet(
        Container(
          width: ScreenUtil().screenWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                  onPressed: () => setThemeModel(ThemeMode.system),
                  child: Text('跟随系统')),
              TextButton(
                  onPressed: () => setThemeModel(ThemeMode.light),
                  child: Text('日间模式')),
              TextButton(
                  onPressed: () => setThemeModel(ThemeMode.dark),
                  child: Text('夜间模式')),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        backgroundColor:
            Theme.of(Get.context!).bottomSheetTheme.backgroundColor);
  }

  @override
  void onInit() {
    if (userService.themeModelFromHive() == ThemeMode.dark) themeState = '夜间';
    if (userService.themeModelFromHive() == ThemeMode.light) themeState = '日间';
    if (userService.themeModelFromHive() == ThemeMode.system)
      themeState = '跟随系统';
    getCachedSizeBytes().then((value) => imageCash.value = value);
    super.onInit();
  }
}
