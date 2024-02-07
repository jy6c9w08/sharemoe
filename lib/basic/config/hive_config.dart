// Package imports:
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:sharemoe/data/model/app_info.dart';
import 'package:sharemoe/data/model/image_download_info.dart';
import 'package:sharemoe/data/model/user_info.dart';
import 'logger_config.dart';

// late Box picBox;

class HiveConfig {
  static Future<Box> initHive() async {
    logger.i("hive开始初始化");
    await Hive.initFlutter();
    Hive.registerAdapter(ImageDownloadInfoAdapter());
    Hive.registerAdapter(UserInfoAdapter());
    // Hive.registerAdapter(LocalSettingAdapter());
    Hive.registerAdapter(APPInfoAdapter());
    Hive.registerAdapter(ThemeModeAdapter());
    logger.i("hive初始化完毕");
    return await Hive.openBox('picBox');
  }
}

@module
abstract class HiveModule {
  @preResolve
  @singleton
  Future<Box> get initHive => HiveConfig.initHive();
}

class ThemeModeAdapter extends TypeAdapter<ThemeMode> {
  @override
  final int typeId = 101; // Unique ID for ThemeMode

  @override
  ThemeMode read(BinaryReader reader) {
    return ThemeMode.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, ThemeMode obj) {
    writer.writeByte(obj.index);
  }
}
