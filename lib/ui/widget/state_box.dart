import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingBox extends StatelessWidget {
  final ScreenUtil screen = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: screen.setHeight(576),
        width: screen.setWidth(324),
        alignment: Alignment.center,
        color: Colors.white,
        child: Center(
          child: Lottie.asset('image/loading-box.json'),
        ));
  }
}


class EmptyBox extends StatelessWidget {
  final ScreenUtil screen = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screen.setHeight(576),
      width: screen.setWidth(324),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Lottie.asset('image/empty-box.json',
              repeat: false, height: ScreenUtil().setHeight(100)),
          Text(
            '这里什么都没有呢',
            style: TextStyle(
                color: Colors.grey,
                fontSize: ScreenUtil().setHeight(10),
                decoration: TextDecoration.none),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(250),
          )
        ],
      ),
    );
  }
}
