import 'package:flutter/material.dart';
import 'package:sharemoe/controller/user/setting_controller.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:extended_image/extended_image.dart';

class SettingPage extends GetView<SettingController> {
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
          GetBuilder<SettingController>(
              id: 'updateR16',
              builder: (_) {
                return ListTile(
                  title: Text('R16'),
                  trailing: Switch(
                    onChanged: (bool value) {
                      controller.changeR16();
                    },
                    value: controller.localSetting.isR16,
                  ),
                );
              }),
          GetX<SettingController>(builder: (_) {
            return ListTile(
              title: Text('清除图片缓存'),
              trailing: Text(
                  (controller.imageCash.value / 1048576).toStringAsFixed(2) +
                      'M'),
              onTap: () {
                print('清除缓存');
                clearDiskCachedImages()
                    .then((value) => controller.imageCash.value = 0);
                ;
              },
            );
          })
        ],
      ),
    );
  }
}
