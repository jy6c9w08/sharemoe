
import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sharemoe/data/model/ga_info.dart';
import 'package:dart_mp_analytics/dart_mp_analytics.dart';
import 'package:uuid/uuid.dart';

@singleton
@preResolve
class AnalyticService{
  late MPAnalytics mpAnalytics;


  AnalyticService(this.mpAnalytics);

  @factoryMethod
  static Future<AnalyticService> create(Logger logger) async {
    logger.i("Google Analytic服务初始化");
    String gaInfoJson = await rootBundle.loadString('assets/ga.json');
    //fromJson 前先加入 version 内容
    // var dataJson = json.decode(data);
    // dataJson['version'] = packageInfo.version;
    GAInfo gaInfo = GAInfo.fromJson(json.decode(gaInfoJson));

    String? clientId;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if(GetPlatform.isIOS){
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      clientId=Uuid().v5(Uuid.NAMESPACE_DNS,iosDeviceInfo.identifierForVendor);
    }
    if(GetPlatform.isAndroid){
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      clientId=Uuid().v5(Uuid.NAMESPACE_DNS, androidInfo.fingerprint);
    }
    final webStreamOptions = MPAnalyticsOptions.webStream(
      measurementId: gaInfo.measurementId,
      clientId: clientId==null?Uuid().v4():clientId,
      apiSecret: gaInfo.apiSecret,
    );

    MPAnalytics analytics = MPAnalytics(verbose: true,logger: logger,
        options: webStreamOptions
    );
    AnalyticService analyticService=new AnalyticService(analytics);
    analyticService.logEvent('app init');
    logger.i("Google Analytic服务初始化完毕");
    return analyticService;
  }

  Future<void> logEvent(String eventName){
    return this.mpAnalytics.logEvent(eventName);
  }



}