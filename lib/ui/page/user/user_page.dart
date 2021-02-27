import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SappBar(title: '用户中心'),
        body: Center(
          child: RaisedButton(
            onPressed: () {
              Get.toNamed(Routes.LOGIN);
            },
            child: Text("跳转"),
          ),
        ));
  }
}
