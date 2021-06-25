import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/data/model/image_download_info.dart';

late Box picBox;
//存放下载的画作id
late List imageDownloadList;

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
  static const List<String> keywordsList = ['imageDownload'];

  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ImageDownloadInfoAdapter());
    Hive.registerAdapter(DownloadStateAdapter());
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
    for (var item in keywordsList) {
      if (picBox.get(item) == null) {
        picBox.put(item, <int>[]);
      }
    }
    imageDownloadList = picBox.get('imageDownload');

    getIt<Logger>().i("Hive初始化");
  }
}

class PicBox {
  String get auth => picBox.get('auth');

  String get name => picBox.get('name');

  int get id => picBox.get('id');

  int get permissionLevel => picBox.get('permissionLevel');

  int get star => picBox.get('star');

  String get permissionLevelExpireDate =>
      picBox.get('permissionLevelExpireDate');

  String get avatarLink => picBox.get('avatarLink');

  String get email => picBox.get('email');

  bool get isBindQQ => picBox.get('isBindQQ');

  bool get isCheckEmail => picBox.get('isCheckEmail');

  double get keyboardHeight => picBox.get('keyboardHeight');
}
