// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/controller/user/user_controller.dart';
import 'package:sharemoe/data/model/user_info.dart';
import 'package:sharemoe/data/repository/user_base_repository.dart';

class UserSettingController extends GetxController {
  late UserInfo userInfo = getIt<UserService>().userInfo()!;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final GlobalKey formKey = GlobalKey<FormState>();

  initCheckEmail() async {
    userInfo.isCheckEmail =
        await getIt<UserBaseRepository>().queryIsUserVerifyEmail(userInfo.id);
    update();
  }

  chooseOnTap(String title) {
    switch (title) {
      case '邮箱换绑':
        return dialog(title, emailController);
      case '修改用户名':
        return dialog(title, userNameController);
      case '修改密码':
        return dialog(title, passwordController);
    }
  }

  dialog(String title, TextEditingController controller) {
    return Get.dialog(AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                title == '修改密码'
                    ? TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: oldPasswordController,
                        decoration: InputDecoration(
                          hintText: TextZhUserSetPage.oldPassword,
                        ),
                      )
                    : SizedBox(),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: chooseHitText(title),
                  ),
                  validator: chooseValidator(title),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          MaterialButton(
            textColor: Colors.white,
            color: Colors.green,
            onPressed: () => sendFunction(title),
            child: Text(chooseButtonText(title)),
          )
        ],
      ),
    ));
  }

  sendFunction(String title) async {
    switch (title) {
      case '邮箱换绑':
        if ((formKey.currentState as FormState).validate()) {
          if (!await getIt<UserBaseRepository>()
              .queryVerifyEmailIsAvailable(emailController.text)) return false;
          getIt<UserBaseRepository>()
              .queryUserSetEmail(userInfo.id, emailController.text)
              .then((value) {
            userInfo = value;
            BotToast.showSimpleNotification(title: '发送成功',hideCloseButton:true);
            getIt<UserService>().updateUserInfo(userInfo);
            update();
            Get.back();
          });
        }
        break;
      case '修改用户名':
        Get.dialog(AlertDialog(
          content: Container(
            child: Text('每半年修改一次哦'),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  if ((formKey.currentState as FormState).validate()) {
                    if (!await getIt<UserBaseRepository>()
                        .queryVerifyUserNameIsAvailable(
                            userNameController.text)) return;
                    getIt<UserBaseRepository>()
                        .queryModifyUserName(
                            userInfo.id, userNameController.text)
                        .then((value) {
                      userInfo = value;
                      BotToast.showSimpleNotification(title: '修改成功',hideCloseButton:true);
                      Get.find<UserController>().updateUserInfo(userInfo);
                      getIt<UserService>().updateUserInfo(userInfo);
                      update();
                      Get.back();
                    });
                  }
                },
                child: Text('确认修改')),
            TextButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                },
                child: Text('取消'))
          ],
        ));
        break;
      case '修改密码':
        if ((formKey.currentState as FormState).validate()) {
          Map<String, dynamic> body = {
            'password': passwordController.text,
            'oldPassword': oldPasswordController.text
          };
          getIt<UserBaseRepository>()
              .queryChangePassword(userInfo.id, body)
              .then((value) {
            BotToast.showSimpleNotification(title: '修改成功',hideCloseButton:true);
            Get.back();
          });
        }
    }
  }

  chooseHitText(String title) {
    switch (title) {
      case '修改用户名':
        return TextZhLoginPage.userName;
      case '邮箱换绑':
        return TextZhLoginPage.email;
      case '修改密码':
        return TextZhLoginPage.password;
      default:
        return null;
    }
  }

  chooseButtonText(String title) {
    switch (title) {
      case '修改用户名':
        return TextZhUserSetPage.confirmUsername;
      case '邮箱换绑':
        return TextZhUserSetPage.confirmMailbox;
      case '修改密码':
        return TextZhUserSetPage.changePassword;
      default:
        return null;
    }
  }

  FormFieldValidator<String>? chooseValidator(String title) {
    switch (title) {
      case '修改用户名':
        return (v) =>
            v!.trim().length >= 4 && v.trim().length <= 10 ? null : "用户名4-10位";
      case '邮箱换绑':
        return (v) => GetUtils.isEmail(v!) ? null : '请输入正确邮箱';
      case '修改密码':
        return (v) =>
            v!.trim().length >= 8 && v.trim().length <= 20 ? null : "密码8-20位";
      default:
        return null;
    }
  }

  @override
  void onInit() {
    initCheckEmail();
    super.onInit();
  }
}
