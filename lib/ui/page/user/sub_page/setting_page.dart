// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bot_toast/bot_toast.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sharemoe/basic/util/sharemoe_theme_util.dart';
import 'package:sharemoe/controller/theme_controller.dart';

// Project imports:
import 'package:sharemoe/controller/user/local_setting_controller.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class SettingPage extends GetView<LocalSettingController> {
  SettingPage({Key? key}) : super(key: key);
  final ScreenUtil screen = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    print(getMemoryImageCache()!.currentSizeBytes);

    return Scaffold(
      appBar: SappBar.normal(
        title: '设置',
      ),
      body: Column(
        children: [
          GetBuilder<LocalSettingController>(
              init: LocalSettingController(),
              id: 'updateR16',
              builder: (_) {
                return ListTile(
                  title: Text('R16'),
                  trailing: controller.userInfo.ageForVerify == null
                      ? Text('未认证')
                      : Switch(
                          onChanged: (bool value) {
                            controller.changeR16(value);
                          },
                          value: controller.is16R!,
                        ),
                  onTap: controller.userInfo.ageForVerify == null
                      ? () {
                          controller.userInfo.phone == null
                              ? controller.verifyPhone()
                              : controller.verifyR16();
                        }
                      : null,
                );
              }),
          ListTile(
            title: Text('切换主题'),
            onTap: () =>controller.themeModeBottomSheet(),
          ),
          GetBuilder<LocalSettingController>(
              init: LocalSettingController(),
              id: 'updateR16',
              builder: (_) {
                return ListTile(
                    title: Text('绑定手机'),
                    trailing:
                        controller.userInfo.phone == null ? Text('未绑定') : null,
                    onTap: () {
                      controller.userInfo.phone == null
                          ? controller.verifyPhone()
                          : BotToast.showSimpleNotification(
                              title: '绑定手机号为' + controller.userInfo.phone!,
                              hideCloseButton: true);
                    });
              }),
          GetX<LocalSettingController>(builder: (_) {
            return ListTile(
              title: Text('清除图片缓存'),
              trailing: Text(
                  (controller.imageCash.value / 1048576).toStringAsFixed(2) +
                      'M'),
              onTap: () {
                print('清除缓存');
                clearDiskCachedImages()
                    .then((value) => controller.imageCash.value = 0);
              },
            );
          }),
          GetBuilder<LocalSettingController>(
              id: 'waterNumber',
              builder: (_) {
                return ListTile(
                  title: Text('瀑布流列数'),
                  trailing: Text(controller.waterNumber.toString()),
                  onTap: () => controller.waterBottomSheet(),
                );
              }),
          GetBuilder<LocalSettingController>(
              id: 'updateSpareKeyboard',
              builder: (_) {
                return ListTile(
                  title: Text('备用键盘'),
                  subtitle: Text('评论表情无法弹出备用'),
                  trailing: Switch(
                    onChanged: (bool value) {
                      controller.changeSpareKeyboard(value);
                    },
                    value: controller.spareKeyboard,
                  ),
                );
              }),
          ListTile(
            title: Text('关于'),
            onTap: () => Get.toNamed(Routes.ABOUT),
          )
        ],
      ),
    );
  }
}
