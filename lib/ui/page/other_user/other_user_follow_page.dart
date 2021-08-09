import 'package:flutter/material.dart';
import 'package:sharemoe/data/model/bookmarked_user.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:extended_image/extended_image.dart';
import 'package:sharemoe/ui/widget/tab_view.dart';
import 'package:get/get.dart';

class OtherUserMarkPage extends StatelessWidget {
  OtherUserMarkPage({Key? key, required this.bookmarkedUser}) : super(key: key);
  final BookmarkedUser bookmarkedUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.normal(
        title: bookmarkedUser.username,
      ),
      body: Container(
        // width: 1.sw,
        // color: Colors.red,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 30.h),
          children: [
            Container(
              // padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
              // margin: EdgeInsets.all(ScreenUtil().setHeight(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                      backgroundImage: ExtendedNetworkImageProvider(
                          'https://static.sharemoe.net/avatar/299x299/${bookmarkedUser.userId.toString()}.jpg')),
                  SizedBox(height: 20.h),
                  Text(
                    bookmarkedUser.username,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                        decoration: TextDecoration.none),
                  ),
                  SizedBox(height: 20.h),
                  TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.ARTIST_LIST,
                            arguments: bookmarkedUser.userId);
                      },
                      child: Text('他的关注')),
                  SizedBox(height: 20.h),
                ],

              ),
            ),
            Container(
              height: ScreenUtil().setHeight(521),
              width: ScreenUtil().setWidth(324),
              child: TabView.bookmark(
                firstView: "插画",
                secondView: "漫画",
                userId: bookmarkedUser.userId,
                showAppbar: false,
              ),
            )
          ],
        ),
      ),
    );
  }
}
