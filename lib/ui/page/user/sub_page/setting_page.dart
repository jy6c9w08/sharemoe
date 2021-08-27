// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';

// Project imports:
import 'package:sharemoe/controller/user/local_setting_controller.dart';
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
      body: ListView(
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
                onTap: () {
                  Get.bottomSheet(
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                                onPressed: () => controller.setWaterNumber(1),
                                child: Text('1')),
                            TextButton(
                                onPressed: () => controller.setWaterNumber(2),
                                child: Text('2')),
                            TextButton(
                                onPressed: () => controller.setWaterNumber(3),
                                child: Text('3')),
                            TextButton(
                                onPressed: () => controller.setWaterNumber(4),
                                child: Text('4')),
                          ],
                        ),
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30)),
                      ));
                },
              );
            }
          )
        ],
      ),
    );
  }
}
