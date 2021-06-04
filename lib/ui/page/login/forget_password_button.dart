import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharemoe/basic/pic_texts.dart';

class ForgetPasswordButton extends StatelessWidget {

  final ScreenUtil screen=ScreenUtil();
  final TextZhLoginPage texts = TextZhLoginPage();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: screen.setWidth(25)),
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(texts.forgetPasswordTitle),
                content: TextField(
                  autofocus: true,
                  // controller: controller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: texts.mailForForget),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(texts.mailForForgetCancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(texts.mailForForgetSubmit),
                    onPressed: () {
                      // _submitMailForForget(controller.text);
                    },
                  ),
                ],
              ));
        },
        child: Text(
          texts.forgetPassword,
          style: TextStyle(color: Colors.blueAccent[200]),
        ),
      ),
    );
  }
}
