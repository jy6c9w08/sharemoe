import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/controller/login_controller.dart';
import 'package:sharemoe/ui/page/login/input_cell.dart';
import 'package:sharemoe/ui/page/login/verification_cell.dart';

import 'forget_password_button.dart';
import 'login_button.dart';
import 'mode_button.dart';

class LoginPage extends GetView<LoginController> {
  final ScreenUtil screen = ScreenUtil();

  final TextZhLoginPage texts = TextZhLoginPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GetBuilder<LoginController>(
            id: 'switchLogin',
            autoRemove: false,
            init: LoginController(),
            builder: (_) {
              return Container(
                height: screen.setHeight(576),
                padding: EdgeInsets.only(
                    left: screen.setWidth(32),
                    top: ScreenUtil().setHeight(40)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.only(bottom: ScreenUtil().setHeight(8)),
                      child: Text(
                        texts.head,
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF515151)),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(bottom: ScreenUtil().setHeight(8)),
                      child: Text(
                        controller.isLogin
                            ? texts.welcomeLogin
                            : texts.welcomeRegister,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF515151)),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(bottom: ScreenUtil().setHeight(13)),
                      child: Text(
                        controller.isLogin ? texts.tipLogin : texts.tipRegister,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF9E9E9E)),
                      ),
                    ),
                    // InputCell.loginUsername(label: texts.userNameAndEmail),
                    // InputCell.loginPassword(label: texts.password),
                    // Container(),
                    // Container(),
                    controller.isLogin
                        ? InputCell.loginUsername(label: texts.userNameAndEmail)
                        : InputCell.registerUsername(
                            label: texts.userName,
                          ),
                    controller.isLogin
                        ? Container()
                        : InputCell.registerEmail(label: texts.email),
                    InputCell.loginPassword(label: texts.password),
                    controller.isLogin
                        ? Container()
                        : InputCell.registerRepeatPassword(
                            label: texts.passwordRepeat),
                    VerificationCell(),
                    SizedBox(
                      height: ScreenUtil().setHeight(38),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(255),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          LoginButton(),
                          // modeIsLogin ? loginButton() : registerButton(),
                          ForgetPasswordButton(),
                          ModeButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
