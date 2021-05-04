import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:sharemoe/basic/pic_texts.dart';
import 'package:sharemoe/controller/login_controller.dart';

class LoginButton extends GetView<LoginController> {
  final TextZhLoginPage texts = TextZhLoginPage();
  final  loginOnLoading=false;
  @override
  Widget build(BuildContext context) {
    return loginOnLoading
        ? OutlineButton(
        onPressed: () {},
        borderSide: BorderSide(color: Colors.orange),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.0),
        ),
        child: Text(
          texts.buttonLoginLoading,
          style: TextStyle(color: Colors.grey),
        ))
        : OutlineButton(
        onPressed: () async {
          print(controller.userPasswordController.text);
          print(controller.userPasswordController.text);
          controller.login();
          //   loginOnLoading = true;
          //   _getVerificationCode();
          // int loginResult = await identity.login(
          //   context,
          //   _userNameController.text,
          //   _userPasswordController.text,
          //   verificationCode,
          //   _verificationController.text,
          //   widgetFrom: widget.widgetFrom,
          // );
          // if (loginResult != 200) {
          //   _resetMode('login');
          // }
        },
        borderSide: BorderSide(
          color: Colors.grey,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.0),
        ),
        child: Text(
          texts.buttonLogin,
          style: TextStyle(color: Color(0xFF515151)),
        ));
  }
}

