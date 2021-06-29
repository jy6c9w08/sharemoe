import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'get_it_config.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/data/model/image_download_info.dart';
import 'package:sharemoe/data/model/user_info.dart';
import 'package:injectable/injectable.dart';
import 'logger_config.dart';
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

  static Future<Box> initHive() async {
    logger.i("hive开始初始化");
    await Hive.initFlutter();
    Hive.registerAdapter(ImageDownloadInfoAdapter());
    Hive.registerAdapter(UserInfoAdapter());
    picBox = await Hive.openBox('picBox');
    initbiz();
    logger.i("hive初始化完毕");
    return picBox;
  }

   static void initbiz(){
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
  }
}

class AuthBox {
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

@module
abstract class HiveModule {
  @preResolve
  @singleton
  Future<Box> get initHive => HiveConfig.initHive();

}