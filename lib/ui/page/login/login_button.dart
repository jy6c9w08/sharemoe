import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/controller/login_controller.dart';

class LoginButton extends GetView<LoginController> {
  final loginOnLoading = false;

  @override
  Widget build(BuildContext context) {
    return loginOnLoading
        ? OutlinedButton(
            onPressed: () {},
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(Size(80.w, 30.h)),
              side: MaterialStateProperty.all(
                  BorderSide(color: Colors.grey, width: 1)),
            ),
            child: Text(
              TextZhLoginPage.buttonLoginLoading,
              style: TextStyle(color: Colors.grey),
            ))
        : OutlinedButton(
            onPressed: () async {
              controller.isLogin ? controller.login() : controller.register();
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(Size(80.w, 30.h)),
              side: MaterialStateProperty.all(
                  BorderSide(color: Colors.grey, width: 1)),
            ),
            child: Text(
              controller.isLogin ? TextZhLoginPage.buttonLogin : TextZhLoginPage.buttonRegister,
              style: TextStyle(color: Color(0xFF515151)),
            ));
  }
}
