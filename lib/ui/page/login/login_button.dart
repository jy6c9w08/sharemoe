import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/controller/login_controller.dart';

class LoginButton extends GetView<LoginController> {
  final TextZhLoginPage texts = TextZhLoginPage();
  final loginOnLoading = false;

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
              controller.login();
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
