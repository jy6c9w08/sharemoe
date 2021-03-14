import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';

import 'package:sharemoe/basic/config/get_it_config.dart';

Box picBox;

class HiveConfig {
  static const List<String> keywordsString = [
    'auth',
    'name',
    'email',
    'qqcheck',
    'avatarLink',
    'gender',
    'signature',
    'location',
    'previewQuality',
    'phone'
  ];
  static const List<String> keywordsInt = [
    'id',
    'star',
    'sanityLevel',
    'previewRule',
  ];
  static const List<String> keywordsBool = [
    'isBindQQ',
    'isCheckEmail',
    'isOnPixivicServer',
    'isBackTipsKnown',
    'isLongPressCollectionKnown',
  ];
  static const List<String> keywordsDouble = ['keyboardHeight'];

  static void initHive() async {
    await Hive.initFlutter();
    picBox = await Hive.openBox('picBox');
    for (var item in keywordsString) {
      if (picBox.get(item) == null) picBox.put(item, '');
    }
    for (var item in keywordsInt) {
      if (picBox.get(item) == null) {
        if (item == 'sanityLevel')
          picBox.put(item, 3);
        else if (item == 'previewRule') // 缓存时长
          picBox.put(item, 7);
        else
          picBox.put(item, 0);
      }
    }
    for (var item in keywordsBool) {
      if (picBox.get(item) == null) picBox.put(item, false);
    }
    for (var item in keywordsDouble) {
      if (picBox.get(item) == null) {
        picBox.put(item, 0.0);
      }
    }
    getIt<Logger>().i("Hive初始化");
  }
}
