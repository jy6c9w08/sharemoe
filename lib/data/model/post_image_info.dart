// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'post_image_info.g.dart';

@JsonSerializable()
class PostImageInfo {
  String uuid;
  int uploadFrom;
  String? original;
  String? large;
  String? medium;
  String squareMedium;
  String moduleName;

  PostImageInfo(
      {required this.uuid,
      required this.uploadFrom,
      this.original,
      this.large,
      this.medium,
      required this.squareMedium,
      required this.moduleName});

  factory PostImageInfo.fromJson(Map<String, dynamic> json) =>
      _$PostImageInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PostImageInfoToJson(this);
}
