import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/controller/login_controller.dart';
import 'package:sharemoe/ui/page/login/input_cell.dart';

class VerificationCell extends GetView<LoginController> {
  final TextZhLoginPage texts = TextZhLoginPage();
  final String model;
  final String label;

  VerificationCell({required this.model, required this.label});

//登陆验证码
  VerificationCell.verificationCode(
      {this.model = 'verificationCode', required this.label});

//注册短信验证码
  VerificationCell.smsCode({this.model = 'smsCode', required this.label});

//食用码
  VerificationCell.registerCode(
      {this.model = 'registerCode', required this.label});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
        autoRemove: false,
        builder: (_) {
          return Container(
              alignment: Alignment.topLeft,
              width: ScreenUtil().setHeight(254),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  model == 'verificationCode'
                      ? InputCell.verificationCode(label: label)
                      : model == 'smsCode'
                          ? InputCell.smsCode(label: label)
                          : InputCell.exchangeCode(label: label),
                  model == 'verificationCode'
                      ? AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          child: GestureDetector(
                            onTap: () {
                              controller.getVerificationCode();
                            },
                            child: GetX<LoginController>(builder: (_) {
                              return controller.verificationImage.value != ''
                                  ? Image.memory(
                                      base64Decode(
                                          controller.verificationImage.value),
                                      width: ScreenUtil().setWidth(70),
                                    )
                                  : Container();
                            }),
                          ),
                        )
                      : MaterialButton(
                          height: 25.h,
                          minWidth: 1,
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: getDiaLog,
                          child: Text(
                            '获取',
                          ),
                        )
                ],
              ));
        });
  }

  //获取弹窗
  getDiaLog() {
    controller.getVerificationCode();
    return model == 'smsCode'
        ? Get.dialog(AlertDialog(
            title: Text('获取短信验证码'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.getVerificationCode();
                  },
                  child: GetX<LoginController>(builder: (_) {
                    return controller.verificationImage.value != ''
                        ? Image.memory(
                            base64Decode(controller.verificationImage.value),
                            width: ScreenUtil().setWidth(70),
                          )
                        : Container();
                  }),
                ),
                TextField(
                  controller: controller.verificationController,
                  decoration: InputDecoration(hintText: texts.verification),
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    RegExp reg = new RegExp(r'^\d{11}$');
                    if (!reg.hasMatch(value!)) {
                      return '请输入11位手机号码';
                    }
                    return null;
                  },
                  controller: controller.phoneNumberController,
                  decoration: InputDecoration(hintText: texts.phoneNumber),
                ),
                SizedBox(height: 20.h),
                MaterialButton(
                  textColor: Colors.white,
                  color: Colors.green,
                  onPressed: () {
                    controller.sendPhoneCode();
                  },
                  child: Text('获取验证码'),
                )
              ],
            ),
          ))
        : Get.dialog(AlertDialog(
            content: Text('跳转网页'),
          ));
  }
}
