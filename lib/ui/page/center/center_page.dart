import 'package:flutter/material.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/page/collection/collection_page.dart';
import 'package:sharemoe/ui/widget/center_button.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

class CenterPage extends StatelessWidget {
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
            top: 10.w,
            left: 15.w,
            right: 15.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "热门画集",
              )
                  .fontSize(17.sp)
                  .fontWeight(FontWeight.bold)
                  .textColor(Colors.grey.shade700)
                  .padding(bottom: 8.h),
              Container(
                padding: EdgeInsets.only(bottom: 13.h),
                height: 144.h,
                child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.all(Radius.circular(20.w)),
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
              Text(
                "画集中心",
              )
                  .fontSize(17.sp)
                  .fontWeight(FontWeight.bold)
                  .textColor(Colors.grey.shade700)
                  .padding(bottom: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  centerOptionButton(
                      text: '新建',
                      color: Colors.blue,
                      icon: Icons.add,
                      onPressed: () => Get.snackbar('test', 'test')),
                  centerOptionButton(
                      text: '管理',
                      color: Colors.green,
                      icon: Icons.photo_library,
                      onPressed: () => Get.snackbar('test', 'test')),
                  centerOptionButton(
                      text: '广场',
                      color: Colors.deepPurple.shade300,
                      icon: Icons.attractions,
                      onPressed: () => Get.snackbar('test', 'test')),
                ],
              ).padding(bottom: 13.h),
              Text(
                "功能中心",
              )
                  .fontSize(17.sp)
                  .fontWeight(FontWeight.bold)
                  .textColor(Colors.grey.shade700)
                  .padding(bottom: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  centerOptionButton(
                      text: '讨论',
                      color: Colors.yellow.shade800,
                      icon: Icons.people,
                      onPressed: () => Get.snackbar('test', 'test')),
                  centerOptionButton(
                      text: '猜你喜欢',
                      color: Colors.pink.shade200,
                      icon: Icons.favorite,
                      onPressed: () => Get.snackbar('test', 'test')),
                  centerOptionButton(
                      text: '设置',
                      color: Colors.grey,
                      icon: Icons.tune,
                      onPressed: () => Get.snackbar('test', 'test')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
