// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:sharemoe/controller/user/message_controller.dart';
import 'package:sharemoe/data/model/message.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class MessageListPage extends GetView<MessageController> {
  MessageListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.normal(title: '消息列表'),
      body: GetX<MessageController>(builder: (_) {
        return ListView.builder(
          controller: controller.scrollController,
          itemBuilder: (BuildContext context, int index) {
            return messageCell(controller.messageList.value[index]);
          },
          itemCount: controller.messageList.value.length,
        );
      }),
    );
  }

  Widget messageCell(Message info) {
    return ListTile(
      contentPadding: EdgeInsets.all(10),
      minVerticalPadding: 4.h,
      leading: ExtendedImage.network(
        'https://s.edcms.pw/avatar/299x299/${info.actors[0].userId}.jpg',
        shape: BoxShape.circle,
        height: 35.w,
        width: 35.w,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(info.actors[0].username),
              SizedBox(
                width: 5,
              ),
              Text(
                info.message,
                style: TextStyle(color: Colors.grey.shade600),
              )
            ],
          ),
          Text(info.extend ?? '')
        ],
      ),
      subtitle: Text(
          DateFormat("yyyy-MM-dd").format(DateTime.parse(info.createDate))),
      trailing: Container(
        width: 50.w,
        child: Text(
          info.objectTitle,
          style: TextStyle(color: Colors.grey),
        ),
      ),
      onTap: () async {
        Get.toNamed(Routes.USER_SINGLE_COMMENT,
            arguments: info.objectId.toString());
      },
    );
  }
}
