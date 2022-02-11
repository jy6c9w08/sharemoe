// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:sharemoe/controller/other_user/other_user_List_controller.dart';
import 'package:sharemoe/data/model/bookmarked_user.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class OtherUserListPage extends GetView<OtherUserListController> {
  OtherUserListPage({Key? key, required this.tag}) : super(key: key);
  @override
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SappBar.normal(title: '这些用户也收藏了'),
      body: Container(
        child: GetX<OtherUserListController>(
            tag: tag,
            builder: (_) {
              return ListView.builder(
                itemExtent:60.h,
                controller: controller.scrollController,
                itemBuilder: (context, index) {
                  return userCell(controller.otherUserList.value[index]);
                },
                itemCount: controller.otherUserList.value.length,
              );
            }),
      ),
    );
  }

  Widget userCell(BookmarkedUser user) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: ExtendedNetworkImageProvider(
          'https://s.edcms.pw/avatar/299x299/${user.userId.toString()}.jpg',
          headers: {
            'Referer': 'https://m.sharemoe.net/',
            // 'authorization': picBox.get('auth')
          },
        ),
      ),
      title: Text(user.username),
      subtitle: Text(
          DateFormat("yyyy-MM-dd").format(DateTime.parse(user.createDate))),
      onTap: (){
        Get.toNamed(Routes.OTHER_USER_FOLLOW,arguments: user);
      },
    );
  }
}
