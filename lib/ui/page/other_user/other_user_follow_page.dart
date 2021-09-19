// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/controller/other_user/other_user_follow_controller.dart';
import 'package:sharemoe/data/model/bookmarked_user.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:sharemoe/ui/widget/tab_view.dart';

class OtherUserMarkPage extends GetView<OtherUserFollowController> {
  OtherUserMarkPage({Key? key, required this.bookmarkedUser}) : super(key: key);
  final BookmarkedUser bookmarkedUser;
  @override
  final String tag = (Get.arguments as BookmarkedUser).userId.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SappBar.normal(
        title: bookmarkedUser.username,
      ),
      body: Container(
        // width: 1.sw,
        // color: Colors.red,
        child: ListView(
          physics: ClampingScrollPhysics(),
          controller: controller.scrollController,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 30.h),
          children: [
            Container(
              // padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
              // margin: EdgeInsets.all(ScreenUtil().setHeight(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 60.w,
                    width: 60.w,
                    child: CircleAvatar(
                        backgroundImage: ExtendedNetworkImageProvider(
                            'https://static.sharemoe.net/avatar/299x299/${bookmarkedUser.userId.toString()}.jpg')),
                  ),
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
