import 'package:get/get.dart';
import 'package:extended_image/extended_image.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/data/model/local_setting.dart';

class SettingController extends GetxController {
  final LocalSetting localSetting = picBox.get('localSetting');

  Rx<bool> is16R = Rx<bool>(false);
  late Rx<int> imageCash = Rx<int>(0);

  changeR16(){
    localSetting.isR16=!localSetting.isR16;
    update(['updateR16']);
  }

  @override
  void onInit() {
    getCachedSizeBytes().then((value) => imageCash.value = value);
    super.onInit();
  }
}
