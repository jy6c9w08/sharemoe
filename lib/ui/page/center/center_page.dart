import 'package:flutter/material.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CenterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.normal(title: '功能中心'),
      body: Container(
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
            color: Color(0xFFFAFAFA),
            image: DecorationImage(
                image: AssetImage('image/background.png'),
                fit: BoxFit.fitWidth)),
        child: Center(
          child: IconButton(
            icon: Icon(FontAwesomeIcons.boxes),
            onPressed: () {
              print('点击画集');
              Get.toNamed(Routes.COLLECTION);
            },
          ),
        ),
      ),
    );
  }
}
