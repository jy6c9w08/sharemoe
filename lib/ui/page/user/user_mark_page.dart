import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

import '../../widget/tab_view.dart';

class UserMarkPage extends StatelessWidget {
   UserMarkPage({Key? key, required this.userId}) : super(key: key);
  final int userId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: SappBar.normal(title: '我的收藏'),
      body: TabView.bookmark(
        userId: Get.arguments,
        title: '我的收藏',
        showAppbar: true,
      ),
    );
  }
}
