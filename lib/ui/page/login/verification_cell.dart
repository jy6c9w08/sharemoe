import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/controller/login_controller.dart';
import 'package:sharemoe/ui/page/login/input_cell.dart';

class VerificationCell extends GetView<LoginController> {
  final TextZhLoginPage texts = TextZhLoginPage();
  @override
  Widget build(BuildContext context) {
    return GetX<LoginController>(
      autoRemove: false,
      builder: (_) {
        return Container(
          alignment: Alignment.topLeft,
          height: ScreenUtil().setHeight(40),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                child: InputCell(
                  label: texts.verification,
                  isPassword: false,
                  controller: controller.verificationController,
                ),
              ),
              Positioned(
                right: ScreenUtil().setWidth(46),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                      minWidth: ScreenUtil().setWidth(85),
                      minHeight: ScreenUtil().setHeight(40)),
                  padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                  child: GestureDetector(
                      onTap: () {
                        controller.getVerificationCode();
                      },
                      child: controller.verificationImage.value != ''
                          ? Image.memory(
                              base64Decode(controller.verificationImage.value),
                              width: ScreenUtil().setWidth(70),
                            )
                          : Container()),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
