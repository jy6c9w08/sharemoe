import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';

import 'package:sharemoe/basic/config/get_it_config.dart';

Box picBox;

class HiveConfig {
  static void initHive() async {
    await Hive.initFlutter();
    picBox = await Hive.openBox('picBox');
    print(picBox.get('auth'));
    getIt<Logger>().i("Hive初始化");
  }
}
