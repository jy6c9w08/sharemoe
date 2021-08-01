// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart';

// Project imports:

class SettingController extends GetxController {
  // final LocalSetting localSetting = picBox.get('localSetting');

  Rx<bool> is16R = Rx<bool>(false);
  late Rx<int> imageCash = Rx<int>(0);

  changeR16(){
    // localSetting.isR16=!localSetting.isR16;
    // localSetting.save();
    update(['updateR16']);
  }

  @override
  void onInit() {
    getCachedSizeBytes().then((value) => imageCash.value = value);
    super.onInit();
  }
}
