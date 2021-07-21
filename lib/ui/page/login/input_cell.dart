import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/controller/login_controller.dart';
import 'package:sharemoe/data/repository/user_base_repository.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

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
      this.length = 169,
      this.model = 'verificationCode'});

//邀请码
  InputCell.exchangeCode(
      {Key? key,
      required this.label,
      this.isPassword = false,
      this.length = 169,
      this.model = 'exchangeCode'});

//短信验证码
  InputCell.smsCode(
      {Key? key,
      required this.label,
      this.isPassword = false,
      this.length = 169,
      this.model = 'smsCode'});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(length),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: controller.chooseValidator(model),
        decoration: InputDecoration(
          hintText: label,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF2994A))),
        ),
        cursorColor: Color(0xFFF2994A),
        controller: controller.chooseEditionController(model),
        obscureText: isPassword,
        onChanged: (value) {
          if (value.length > 4 && model.contains('registerUsername'))
            print(getIt<UserBaseRepository>()
                .queryVerifyUserNameIsAvailable(value));
        },
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
}
