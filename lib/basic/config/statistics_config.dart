// Dart imports:
import 'dart:io';

// Package imports:
import 'package:fl_baidu_mob_stat/fl_baidu_mob_stat.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'logger_config.dart';

class StatisticsConfig {
  static Future<FlBaiduMobStat> initStatistics() async {
    logger.i("百度统计开始初始化");
    final bool key = await FlBaiduMobStat.instance
        .setApiKey(androidKey: '1c62ad79da', iosKey: 'd7a60ad100');
    String channelName = 'flutter';
    if (Platform.isAndroid) channelName += '- Android';
    if (Platform.isIOS) channelName += '- IOS';
    // final bool channel =
        await FlBaiduMobStat.instance.setAppChannel(channelName);
    logger.i("百度统计开始初始化成功：$key");
    return FlBaiduMobStat.instance;
  }
}

@module
abstract class StatisticsModule {
  @preResolve
  @singleton
  Future<FlBaiduMobStat> get flBaiduMobStat =>
      StatisticsConfig.initStatistics();
}
