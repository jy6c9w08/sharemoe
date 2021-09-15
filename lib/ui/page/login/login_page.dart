// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/controller/login_controller.dart';
import 'package:sharemoe/ui/page/login/input_cell.dart';
import 'forget_password_button.dart';
import 'login_button.dart';
import 'mode_button.dart';

class LoginPage extends GetView<LoginController> {
  final ScreenUtil screen = ScreenUtil();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<LoginController>(
          id: 'switchLogin',
          init: LoginController(),
          builder: (_) {
            return Container(
              // height: screen.setHeight(576),
              padding: EdgeInsets.only(
                  left: screen.setWidth(32), top: ScreenUtil().setHeight(40)),
              child: SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        margin:
                            EdgeInsets.only(bottom: ScreenUtil().setHeight(8)),
                        child: Text(
                          TextZhLoginPage.head,
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
                              ? TextZhLoginPage.welcomeLogin
                              : TextZhLoginPage.welcomeRegister,
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
                          controller.isLogin
                              ? TextZhLoginPage.tipLogin
                              : TextZhLoginPage.tipRegister,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Color(0xFF9E9E9E)),
                        ),
                      ),
                      controller.isLogin
                          ? InputCell.loginUsername(
                              label: TextZhLoginPage.userNameAndEmail)
                          : InputCell.registerUsername(label: TextZhLoginPage.userName,focusNode: controller.usernameFocus,),
                      SizedBox(height: 10.h),
                      controller.isLogin
                          ? Container()
                          : InputCell.registerEmail(label: TextZhLoginPage.email,focusNode: controller.emailFocus,),
                      SizedBox(height: 10.h),
                      controller.isLogin
                          ? InputCell.loginPassword(label: TextZhLoginPage.password)
                          : InputCell.registerPassword(label: TextZhLoginPage.password),
                      SizedBox(height: 10.h),
                      controller.isLogin
                          ? Container()
                          : InputCell.registerRepeatPassword(
                              label: TextZhLoginPage.passwordRepeat),
                      SizedBox(height: 10.h),
                      controller.isLogin
                          ? InputCell.verificationCode(
                              label: TextZhLoginPage.verification,
                            )
                          : InputCell.exchangeCode(
                              label: TextZhLoginPage.registerCode,
                            ),
                      SizedBox(height: 10.h),
                      controller.isLogin
                          ? Container()
                          : InputCell.smsCode(label: TextZhLoginPage.smsCode),
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
                      SizedBox(
                        height: 80.h,
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
