import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:get/get.dart';

part 'app_info.g.dart';

@HiveType(typeId: 3)
class APPInfo {
  @HiveField(0)
  final String appName;
  @HiveField(1)
  final String version;
  @HiveField(2)
  final DateTime releaseDate;
  @HiveField(3)
  final String androidLink;
  @HiveField(4)
  final String iosLink;
  @HiveField(5)
  final bool isTest;


  Rx<int> downloadPercent = Rx<int>(0);
  Rx<int> fileTotal = Rx<int>(0);

  APPInfo(
      {required this.appName,
      required this.version,
      required this.releaseDate,
      required this.androidLink,
      required this.iosLink,
      required this.isTest});


  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + '%');
    }
  }
}
