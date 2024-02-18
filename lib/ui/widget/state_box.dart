// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class LoadingBox extends StatelessWidget {
  final ScreenUtil screen = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: screen.setHeight(576),
        width: screen.setWidth(324),
        alignment: Alignment.center,
        child: Center(
          child: Lottie.asset('assets/image/loading-box.json'),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Lottie.asset('assets/image/empty-box.json',
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

class NeedNetWork extends StatelessWidget {
  const NeedNetWork({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().screenHeight-150.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
         Icon(Icons.portable_wifi_off_outlined,size: 100,color: Colors.grey,),
          Text(
            '网络连接异常,刷新试试',
            style: TextStyle(
                color: Colors.grey,
                fontSize: ScreenUtil().setHeight(10),
                decoration: TextDecoration.none),
          ),
          ElevatedButton(onPressed: (){}, child: Text('刷新')),

        ],
      ),
    );
  }
}
