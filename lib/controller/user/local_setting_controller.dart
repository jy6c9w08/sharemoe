// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/data/model/user_info.dart';
import 'package:sharemoe/data/model/verification.dart';
import 'package:sharemoe/data/repository/user_base_repository.dart';

// Project imports:

class LocalSettingController extends GetxController {
  // final LocalSetting localSetting = picBox.get('localSetting');
  late UserInfo userInfo = getIt<UserService>().userInfo()!;
  Rx<bool> is16R = Rx<bool>(false);
  late Rx<int> imageCash = Rx<int>(0);
  static final UserBaseRepository userBaseRepository =
      getIt<UserBaseRepository>();

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

  //获取验证码
  getVerificationCode() async {
    Verification verification =
        await userBaseRepository.queryVerificationCode();
    verificationImage.value = verification.imageBase64;
    verificationCode = verification.vid;
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

  changeR16() {
    // localSetting.isR16=!localSetting.isR16;
    // localSetting.save();
    update(['updateR16']);
  }

  verifyPhone() {
    getVerificationCode();
    return Get.dialog(AlertDialog(
      title: Text('绑定手机'),
      content: Column(
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
            decoration: InputDecoration(hintText: TextZhLoginPage.verification),
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
                  onPressed: () {},
                )),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              // return GetUtils.isPhoneNumber(value!) ? null : '请输入正确手机号码';
            },
            controller: smsController,
            decoration: InputDecoration(
              hintText: TextZhLoginPage.smsCode,
            ),
          ),
          SizedBox(height: 20.h),
          MaterialButton(
            textColor: Colors.white,
            color: Colors.green,
            onPressed: () {
              sendPhoneCode();
            },
            child: Text('立即绑定'),
          )
        ],
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
          TextButton(onPressed: () {}, child: Text('微店获取')),
          TextButton(onPressed: () {}, child: Text('淘宝获取')),
          TextField(
            controller: verificationController,
            decoration: InputDecoration(hintText: '姓名'),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: phoneNumberController,
            decoration: InputDecoration(
              hintText: '认证兑换码',
            ),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              // return GetUtils.isPhoneNumber(value!) ? null : '请输入正确手机号码';
            },
            controller: smsController,
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

  //三要素认证
  authenticated() async {
    Map<String, dynamic> body = {
      'name': nameController.text,
      'exchangeCode': redemptionController.text,
      'idCard': identityCardController.text
    };
    await getIt<UserBaseRepository>().queryAuthenticated(userInfo.id, body);
  }

  @override
  void onInit() {
    getCachedSizeBytes().then((value) => imageCash.value = value);
    super.onInit();
  }
}
