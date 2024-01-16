import 'package:json_annotation/json_annotation.dart';

part 'expose_illust.g.dart';

@JsonSerializable()
//带有三张图片的画师
class ExposeIllust {
  int illustId;
  int createTime;

  ExposeIllust({required this.illustId,required this.createTime});

  factory ExposeIllust.fromJson(Map<String, dynamic> json) =>
      _$ExposeIllustFromJson(json);

  Map<String, dynamic> toJson() => _$ExposeIllustToJson(this);

  @override
  String toString() {
    return 'ExposeIllust{illustId: $illustId, createTime: $createTime}';
  }
}
