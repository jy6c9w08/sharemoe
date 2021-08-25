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
import 'package:sharemoe/data/model/user_info.dart';
import 'package:sharemoe/data/repository/user_base_repository.dart';

class UserSettingController extends GetxController {
  late UserInfo userInfo = getIt<UserService>().userInfo()!;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final GlobalKey formKey = GlobalKey<FormState>();

  chooseOnTap(String title) {
    switch (title) {
      case '邮箱换绑':
        return dialog(title, emailController);
      case '修改用户名':
        dialog(title, userNameController);
    }
  }

  dialog(String title, TextEditingController controller) {
    return Get.dialog(AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            decoration: InputDecoration(
              hintText: chooseHitText(title),
            ),
            validator: chooseValidator(title),
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
      case '输入新邮箱':
        if ((formKey.currentState as FormState).validate()) {
          if (!await getIt<UserBaseRepository>()
              .queryVerifyEmailIsAvailable(emailController.text)) return false;
          getIt<UserBaseRepository>()
              .queryUserSetEmail(userInfo.id, emailController.text)
              .then((value) {
            userInfo = value;
            BotToast.showSimpleNotification(title: '发送成功');
            getIt<UserService>().updateUserInfo(userInfo);
            update();
            Get.back();
          });
        }
        break;
      case '用户名修改':
    }
  }

  chooseHitText(String title) {
    switch (title) {
      case '修改用户名':
        return TextZhLoginPage.userName;
      case '邮箱换绑':
        return TextZhLoginPage.email;
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
      default:
        return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
