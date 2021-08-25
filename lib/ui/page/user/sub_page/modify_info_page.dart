// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';

// Project imports:
import 'package:sharemoe/controller/user/local_setting_controller.dart';
import 'package:sharemoe/controller/user/user_setting_controller.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class ModifyInfoPage extends GetView<UserSettingController> {
  const ModifyInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.normal(title: '修改信息'),
      body: GetBuilder<UserSettingController>(
          init: UserSettingController(),
          builder: (_) {
            return Column(
              children: [
                modifyCell(TextZhUserSetPage.mailboxVerification),
                modifyCell(TextZhUserSetPage.changePassword),
                modifyCell(TextZhUserSetPage.changeUsername),
                modifyCell(TextZhUserSetPage.changeEmailBinding),
              ],
            );
          }),
    );
  }

  Widget modifyCell(String title) {
    return ListTile(
      title: Text(title),
      trailing: title == TextZhUserSetPage.mailboxVerification
          ? !controller.userInfo.isCheckEmail
              ? Text('未验证')
              : Text('已验证')
          : null,
      onTap: () => controller.chooseOnTap(title),
    );
  }
}
