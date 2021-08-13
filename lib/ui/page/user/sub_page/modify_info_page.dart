import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                modifyCell('邮箱验证'),
                modifyCell('密码修改'),
                modifyCell('用户名修改'),
                modifyCell('邮箱换绑'),
              ],
            );
          }),
    );
  }

  Widget modifyCell(String title) {
    return ListTile(
      title: Text(title),
      trailing: title == '邮箱验证'
          ? !controller.userInfo.isCheckEmail
              ? Text('未验证')
              : Text('已验证')
          : null,
    );
  }
}
