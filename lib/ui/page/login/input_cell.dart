// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/controller/login_controller.dart';

class InputCell extends GetView<LoginController> {
  final String label;
  final bool isPassword;
  final int length;
  final String model;
  final FocusNode? focusNode;

  InputCell({
    Key? key,
    required this.label,
    required this.isPassword,
    this.length = 254,
    required this.model,
    required this.focusNode,
  }) : super(key: key);

  InputCell.loginPassword({
    Key? key,
    required this.label,
    this.isPassword = true,
    this.length = 254,
    this.model = 'loginPassword',
    this.focusNode,
  });

  InputCell.loginUsername({
    Key? key,
    required this.label,
    this.isPassword = false,
    this.length = 254,
    this.model = 'loginUsername',
    this.focusNode,
  });

  InputCell.registerPassword({
    Key? key,
    required this.label,
    this.isPassword = true,
    this.length = 254,
    this.model = 'registerPassword',
    this.focusNode,
  });

  InputCell.registerRepeatPassword({
    Key? key,
    required this.label,
    this.isPassword = true,
    this.length = 254,
    this.model = 'registerRepeatPassword',
    this.focusNode,
  });

  InputCell.registerUsername({
    Key? key,
    required this.label,
    this.isPassword = false,
    this.length = 254,
    this.model = 'registerUsername',
    this.focusNode,
  });

  InputCell.registerEmail({
    Key? key,
    required this.label,
    this.isPassword = false,
    this.length = 254,
    this.model = 'registerEmail',
    this.focusNode,
  });

  InputCell.verificationCode({
    Key? key,
    required this.label,
    this.isPassword = false,
    this.length = 254,
    this.model = 'verificationCode',
    this.focusNode,
  });

//邀请码
  InputCell.exchangeCode({
    Key? key,
    required this.label,
    this.isPassword = false,
    this.length = 254,
    this.model = 'exchangeCode',
    this.focusNode,
  });

//短信验证码
  InputCell.smsCode({
    Key? key,
    required this.label,
    this.isPassword = false,
    this.length = 254,
    this.model = 'smsCode',
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(length),
      child: TextFormField(
        focusNode: focusNode,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: controller.chooseValidator(model),
        decoration: InputDecoration(
            suffixIconConstraints: BoxConstraints(
              minHeight: 30.h,
              maxHeight: 40.h,
              maxWidth: 80.w,
              minWidth: 60.w,
            ),
            hintText: label,
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF2994A))),
            suffixIcon: controller.chooseSuffixIcon(model)),
        cursorColor: Color(0xFFF2994A),
        controller: controller.chooseEditionController(model),
        obscureText: isPassword,
        // onChanged: (value) {
        //   if (value.length > 4 && model.contains('registerUsername'))
        //     getIt<UserBaseRepository>()
        //         .queryVerifyUserNameIsAvailable(value)
        //         .then((value) => print(value));
        // },
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
