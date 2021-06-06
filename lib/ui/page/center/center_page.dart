import 'package:flutter/material.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:extended_image/extended_image.dart';

class CenterPage extends StatelessWidget {
  final ScreenUtil screen = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.normal(title: '功能中心'),
      body: Container(
        alignment: Alignment.centerLeft,
        // decoration: BoxDecoration(
        //     color: Color(0xFFFAFAFA),
        //     image: DecorationImage(
        //         image: AssetImage('image/background.jpg'),
        //         fit: BoxFit.fitWidth)
        // ),
        child: Container(
          padding: EdgeInsets.only(
              top: screen.setWidth(10),
              left: screen.setWidth(15),
              right: screen.setWidth(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "热门画集",
                style: TextStyle(
                    fontSize: screen.setSp(17),
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700),
              ),
              SizedBox(
                height: screen.setHeight(13),
              ),
              Container(
                height: screen.setHeight(150),
                child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(20))),
                  child: Swiper(
                    pagination: SwiperPagination(),
                    itemBuilder: (BuildContext context, int index) {
                      return ExtendedImage.network(
                        'https://2927639c-madman-com-au.akamaized.net/news/wp-content/uploads/FATE-GO-BLOG-HEADER.jpg',
                        fit: BoxFit.fill,
                      );
                    },
                    itemCount: 5,
                  ),
                ),
              ),
              SizedBox(
                height: screen.setHeight(13),
              ),
              Text(
                "画集中心",
                style: TextStyle(
                    fontSize: screen.setSp(17),
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700),
              ),
              SizedBox(
                height: screen.setHeight(13),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  centerElevatedButton(text: '新建', color: Color(0xffFFB6C1)),
                  centerElevatedButton(text: '管理', color: Color(0xff6FCF97)),
                  centerElevatedButton(text: '广场', color: Color(0xff64A6FF)),
                ],
              ),
              SizedBox(
                height: screen.setHeight(13),
              ),
              Text(
                "功能中心",
                style: TextStyle(
                    fontSize: screen.setSp(17),
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  centerElevatedButton(text: '讨论', color: Color(0xffF2C94C)),
                  centerElevatedButton(text: '猜你喜欢', color: Color(0xffB694F6)),
                  centerElevatedButton(text: '设置', color: Color(0xff9E9E9E)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget centerElevatedButton({required String text, required Color color}) {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color),
        fixedSize: MaterialStateProperty.all(
            Size(screen.setHeight(80), screen.setHeight(40))),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        padding: MaterialStateProperty.all(EdgeInsets.all(5)),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: screen.setSp(14),
            color: Colors.black,
            fontWeight: FontWeight.w700),
      ),
    );
  }
}
