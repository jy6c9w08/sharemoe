// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/controller/login_controller.dart';

class LoginButton extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return GetX<LoginController>(
      builder: (_) {
        return controller.loginOnLoading.value
            ? OutlinedButton(
                onPressed: () {},
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(80.w, 30.h)),
                  side: MaterialStateProperty.all(
                      BorderSide(color: Colors.grey, width: 1)),
                ),
                child: Text(
                  controller.isLogin
                      ? TextZhLoginPage.buttonLoginLoading
                      : TextZhLoginPage.buttonRegisterLoading,
                ))
            : OutlinedButton(
                onPressed: () async {
                  controller.getVerificationCode();
                  controller.isLogin
                      ? controller.login()
                      : controller.register();
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(80.w, 30.h)),
                  side: MaterialStateProperty.all(
                      BorderSide(color: Colors.grey, width: 1)),
                ),
                child: Text(controller.isLogin
                    ? TextZhLoginPage.buttonLogin
                    : TextZhLoginPage.buttonRegister));
      },
    );
  }
}
