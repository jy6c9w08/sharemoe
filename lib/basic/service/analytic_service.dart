import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sharemoe/data/model/ga_info.dart';
import 'package:uuid/uuid.dart';

@singleton
@preResolve
class AnalyticService {
  // late GARepository gaRepository;
  late String clientId;
  late Dio dio;
  late String measurementId;
  late String apiSecret;
  late Map<String, String> param;

  AnalyticService(
      this.clientId, this.dio, this.measurementId, this.apiSecret, this.param);

  @factoryMethod
  static Future<AnalyticService> create(Logger logger) async {
    logger.i("Google Analytic服务初始化");
    String gaInfoJson = await rootBundle.loadString('assets/ga.json');
    GAInfo gaInfo = GAInfo.fromJson(json.decode(gaInfoJson));
    String? clientId;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map<String, String> param = {};
    param['session_id'] = Uuid().v4();
    param['engagement_time_msec'] = "100";
    if (GetPlatform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      clientId =
          Uuid().v5(Uuid.NAMESPACE_DNS, iosDeviceInfo.identifierForVendor);
      param['os'] = iosDeviceInfo.systemName;
      param['os_version'] = iosDeviceInfo.systemVersion;
    }
    if (GetPlatform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      clientId = Uuid().v5(Uuid.NAMESPACE_DNS, androidInfo.fingerprint);
      param['os'] = 'Android';
      param['os_version'] = androidInfo.version.codename;
    }

    AnalyticService analyticService = new AnalyticService(
        clientId!, Dio(), gaInfo.measurementId, gaInfo.apiSecret, param);
    // Response response =await analyticService.logEvent('app-init');
    // print(response.statusCode);
    analyticService.logEvent('app_init');
    logger.i("Google Analytic服务初始化完毕");
    return analyticService;
  }

  Future<Response> logEvent(String eventName) {
    Map<String, dynamic> body = {
      'client_id': this.clientId,
      'events': {"name": eventName, "params": this.param}
    };
    return this.dio.post('https://www.google-analytics.com/mp/collect',
        queryParameters: {
          'api_secret': this.apiSecret,
          'measurement_id': measurementId
        },
        data: body);
  }
}
