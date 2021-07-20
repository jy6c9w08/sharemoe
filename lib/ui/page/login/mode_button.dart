import 'package:flutter/material.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:get/get.dart';
import 'package:sharemoe/controller/login_controller.dart';

class ModeButton extends GetView<LoginController> {
  final TextZhLoginPage texts = TextZhLoginPage();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      id: 'switchLogin',
      builder: (_) {
        return TextButton(
            onPressed: () {
              controller.switchLoginModel();
            },
            child: Text(
                    controller.isLogin ? texts.registerMode : texts.loginMode,
              style: TextStyle(color: Colors.blueAccent[200]),
            ));
      }
    );

    //   Container(
    //   child: GestureDetector(
    //     onTap: () {
    //         // modeIsLogin = !modeIsLogin;
    //         // _userPasswordController.text = '';
    //         // _userPasswordController.text = '';
    //     },
    //     child: Text(
    //       texts.registerMode,
    //       // modeIsLogin ? texts.registerMode : texts.loginMode,
    //       style: TextStyle(color: Colors.blueAccent[200]),
    //     ),
    //   ),
    // );
  }
}
