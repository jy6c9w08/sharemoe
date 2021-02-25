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
