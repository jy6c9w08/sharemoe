// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'image_url_pre.g.dart';

@JsonSerializable()
class ImageUrlPre {
  String smallCn;
  String small;
  String original;
  String originalBackup;

  ImageUrlPre(
      {required this.smallCn,
        required this.small,
        required this.original,
        required this.originalBackup,
      });

  factory ImageUrlPre.fromJson(Map<String, dynamic> json) =>
      _$ImageUrlPreFromJson(json);

  Map<String, dynamic> toJson() => _$ImageUrlPreToJson(this);
}

