import 'package:flutter/material.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';

class ModeButton extends StatelessWidget {
  final TextZhLoginPage texts = TextZhLoginPage();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
            // modeIsLogin = !modeIsLogin;
            // _userPasswordController.text = '';
            // _userPasswordController.text = '';
        },
        child: Text(
          texts.registerMode,
          // modeIsLogin ? texts.registerMode : texts.loginMode,
          style: TextStyle(color: Colors.blueAccent[200]),
        ),
      ),
    );
  }
}
