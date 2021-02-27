import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputCell extends StatelessWidget {
  final String label;
  final bool isPassword;
  final int length;
  final TextEditingController controller;

  const InputCell(
      {Key key,
      this.label,
      this.isPassword,
      this.length = 254,
      this.controller})
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
        controller: controller,
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
}
