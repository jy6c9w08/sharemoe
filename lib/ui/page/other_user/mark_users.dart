// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/controller/other_user/other_user_List_controller.dart';
import 'package:sharemoe/routes/app_pages.dart';

class MarkUsers extends GetView<OtherUserListController> {
  MarkUsers({Key? key, required this.tag}) : super(key: key);
  @override
  final String tag;

  @override
  Widget build(BuildContext context) {
    return GetX<OtherUserListController>(
        tag: tag,
        builder: (_) {
          return _.otherUserList.value.isEmpty
              ? Container()
              : GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.OTHER_USER_LIST,arguments: tag);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.white,
                    width: 60.w,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        singleCircle(0),
                        singleCircle(1),
                        singleCircle(2)
                      ],
                    ),
                  ),
                );
        });
  }

  Widget singleCircle(int index) {
    num rightDistance = index * ScreenUtil().setWidth(12);
    if (index >= controller.otherUserList.value.length)
      return Container();
    else
      return Positioned(
        right: rightDistance.toDouble(),
        child: CircleAvatar(
          backgroundImage: ExtendedNetworkImageProvider(
            'https://s.edcms.pw/avatar/299x299/${controller.otherUserList.value[index].userId.toString()}.jpg',
            headers: {
              'Referer': 'https://m.sharemoe.net/',
              // 'authorization': picBox.get('auth')
            },
          ),
        ),
      );
  }
}
