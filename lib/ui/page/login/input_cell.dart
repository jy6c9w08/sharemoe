import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharemoe/controller/login_controller.dart';

class InputCell extends GetView<LoginController> {
  final String label;
  final bool isPassword;
  final int length;
  final String model;

  InputCell(
      {Key? key,
      required this.label,
      required this.isPassword,
      this.length = 254,
      required this.model})
      : super(key: key);

  InputCell.loginPassword({
    Key? key,
    required this.label,
    this.isPassword = true,
    this.length = 254,
    this.model = 'loginPassword',
  });

  InputCell.loginUsername({
    Key? key,
    required this.label,
    this.isPassword = false,
    this.length = 254,
    this.model = 'loginUsername',
  });

  InputCell.registerPassword({
    Key? key,
    required this.label,
    this.isPassword = true,
    this.length = 254,
    this.model = 'registerPassword',
  });

  InputCell.registerRepeatPassword({
    Key? key,
    required this.label,
    this.isPassword = true,
    this.length = 254,
    this.model = 'registerRepeatPassword',
  });

  InputCell.registerUsername({
    Key? key,
    required this.label,
    this.isPassword = false,
    this.length = 254,
    this.model = 'registerUsername',
  });

  InputCell.registerEmail({
    Key? key,
    required this.label,
    this.isPassword = false,
    this.length = 254,
    this.model = 'registerEmail',
  });

  InputCell.verificationCode(
      {Key? key,
      required this.label,
      this.isPassword = false,
      this.length = 254,
      this.model = 'verificationCode'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
      width: ScreenUtil().setWidth(length),
      height: ScreenUtil().setHeight(40),
      child: TextField(
        decoration: InputDecoration(
          hintText: label,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF2994A))),
        ),
        cursorColor: Color(0xFFF2994A),
        controller: chooseEditionController(model),
        obscureText: isPassword,
        onTap: () async {
          // Future.delayed(Duration(milliseconds: 250), () {
          //   double location = mainController.position.extentBefore +
          //       ScreenUtil().setHeight(100);
          //   mainController.position.animateTo(location,
          //       duration: Duration(milliseconds: 100),
          //       curve: Curves.easeInCirc);
          // });
        },
      ),
    );
  }

  TextEditingController chooseEditionController(String model) {
    switch (model) {
      case 'loginPassword':
        return controller.userPasswordController;
      case 'loginUsername':
        return controller.userNameController;
      case 'registerRepeatPassword':
        return controller.userPasswordRepeatController;
      case 'registerUsername':
        return controller.userNameController;
      case 'registerPassword':
        return controller.userPasswordController;
      case 'verificationCode':
        return controller.verificationController;
      case 'registerEmail':
        return controller.emailController;
      default:
        return controller.userPasswordController;
    }
  }
}
