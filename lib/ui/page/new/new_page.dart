// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/controller/global_controller.dart';
import 'package:sharemoe/ui/page/needlogin/needlogin.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:sharemoe/ui/widget/tab_view.dart';

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SappBar.normal(
        title: '画师更新',
      ),
      body: GetX<GlobalController>(
        builder: (_) {
          return _.isLogin.value ? TabView.update() : NeedLoginPage();
        },
      ),
    );
  }


}
