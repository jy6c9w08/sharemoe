// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'ga_info.g.dart';

@JsonSerializable()
class GAInfo {
  final String measurementId;
  final String apiSecret;


  GAInfo({
    required this.measurementId,
    required this.apiSecret,
  });

  factory GAInfo.fromJson(Map<String, dynamic> json) =>
      _$GAInfoFromJson(json);

  Map<String, dynamic> toJson() => _$GAInfoToJson(this);
}