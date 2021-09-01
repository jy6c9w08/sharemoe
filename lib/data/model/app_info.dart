import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_info.g.dart';

@JsonSerializable()
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
  @HiveField(6)
  final String updateLog;

  APPInfo({
    required this.appName,
    required this.version,
    required this.releaseDate,
    required this.androidLink,
    required this.iosLink,
    required this.isTest,
    required this.updateLog,
  });

  factory APPInfo.fromJson(Map<String, dynamic> json) =>
      _$APPInfoFromJson(json);

  Map<String, dynamic> toJson() => _$APPInfoToJson(this);
}
